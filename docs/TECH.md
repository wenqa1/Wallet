# 卡包（Wallet 平替）· 技术设计文档

> 版本：v1.0　|　日期：2026-08-02

---

## 1. 技术选型与理由

### 1.1 框架：Flutter

| 方案 | 结论 | 理由 |
|---|---|---|
| **Flutter** | ✅ **选定** | ① 无 Mac 也能开发：Windows 上写代码、跑桌面/Android 验证，iOS 出包走云端 CI；② 满足 iOS 16+ 目标（Flutter 最低 iOS 11）；③ CustomPainter + 动画控制器能做出钱包级卡片翻转效果；④ 顺带可出 Android 版 |
| 原生 SwiftUI | ❌ | 无 Xcode/Mac 无法本地编译调试，开发循环断裂 |
| React Native / Expo | ⚠️ 备选 | EAS 云构建成熟，但 OCR 生态与自定义绘制体验弱于 Flutter |

### 1.2 核心依赖

| 依赖 | 用途 | 说明 |
|---|---|---|
| `flutter_riverpod` | 状态管理 | Provider 分层，数据流清晰可测 |
| `go_router` | 路由 | 声明式导航，支持深链 |
| `drift` | 本地数据库 | SQLite + 类型安全 DSL，存储卡片元数据 |
| `flutter_secure_storage` | 安全存储 | 敏感字段写入 iOS Keychain |
| `camera` / `google_mlkit_text_recognition` | OCR | 相机采集 + 端侧文本识别（离线） |
| `dio` | 网络 | 卡面资源下载，支持缓存/断点 |
| `cached_network_image` | 图片缓存 | 远程卡面懒加载与磁盘缓存 |
| `image_picker` | 相册 | 自定义卡面背景图 |

### 1.3 最低部署目标

- **iOS 16.0+**（部署目标按 16 起，开发期间可用 17/18 真机验证）
- 开发期验证设备：iPhone SE（2 代/3 代）+ 用户 iPhone

---

## 2. 总体架构

三层 + 功能分模块（feature-first）：

```
┌─────────────────────────────────────────────┐
│  Presentation 层                              │
│  Widgets / Pages / Controllers (Riverpod)    │
├─────────────────────────────────────────────┤
│  Domain 层                                    │
│  实体模型 / 用例（增删改查、Luhn 校验、卡面匹配） │
├─────────────────────────────────────────────┤
│  Data 层                                      │
│  Drift(元数据) + Keychain(敏感) + 卡面Repo + API │
└─────────────────────────────────────────────┘
```

### 2.1 目录结构（Flutter 工程 `app/`）

```
app/lib/
├── main.dart
├── app/
│   ├── app.dart            # MaterialApp + 主题
│   └── router.dart         # go_router 路由表
├── core/
│   ├── theme/              # 主题、卡片样式 tokens
│   ├── constants/          # 银行代码表、卡类型枚举
│   ├── security/
│   │   ├── secure_storage_service.dart   # Keychain 封装
│   │   └── card_number_mask.dart         # 遮挡工具
│   └── utils/
│       ├── luhn.dart                      # Luhn 校验
│       └── card_number_parser.dart        # OCR 结果→卡号提取
├── data/
│   ├── local/
│   │   ├── app_database.dart              # Drift 数据库
│   │   ├── card_table.dart                # 卡片表
│   │   └── card_face_table.dart           # 卡面缓存表
│   ├── network/
│   │   ├── card_face_api.dart             # 卡面清单拉取
│   │   └── card_face_downloader.dart      # 增量下载
│   └── repositories/
│       ├── card_repository.dart           # 卡片读写（组合 DB+Keychain）
│       └── card_face_repository.dart      # 卡面合并/解析
├── features/
│   ├── card_list/          # 首页轮播/网格 + 卡片 Widget
│   ├── card_detail/        # 详情 + 3D 翻转 + 遮挡/显示
│   ├── add_card/           # 添加表单 + OCR 扫描页
│   ├── card_face/          # 卡面库选择器 + 自定义编辑器
│   ├── balance/            # 余额录入/更新
│   └── settings/           # 设置页
└── shared/                 # 公共组件（卡片渲染、SegmentedControl 等）
```

### 2.2 数据流

```
卡片列表页 ──watch──▶ CardListController (Riverpod)
                            │
                            ▼
                 CardRepository
                   ├─ 读: Drift(CardMeta) + Keychain(CardSecret)
                   ├─ 写: Drift + Keychain 事务
                   └─ 卡面: CardFaceRepository
```

**读写一致性**：卡片元数据与敏感字段分库存储，用 `cardId` 关联；删除卡片时两个库一起删，保证不留残余。

---

## 3. 数据模型

### 3.1 卡片（Drift 表 + Keychain）

```dart
// Drift: card_meta —— 非敏感元数据
class CardMeta {
  String id;             // UUID
  String bankCode;       // 如 ICBC / CMB / ABC ...
  String bankName;
  String cardType;       // debit | credit | membership | transport | other
  String? nickname;      // 昵称，如"工资卡"
  String? faceId;        // 当前卡面 id（内置/远程/自定义）
  String? customFace;    // 自定义卡面 JSON（见 §5.3）
  double? balance;
  String? currency;      // 默认 ¥
  DateTime? balanceUpdatedAt;
  String? notes;
  int orderIndex;        // 排序
  DateTime createdAt, updatedAt;
}

// Keychain: card_secret —— 敏感字段（不落 SQLite）
class CardSecret {
  String cardId;
  String cardNumber;     // 明文只存在 Keychain
  String? holderName;
  String? expiry;        // "MM/YY"
  String? cvv;
}
```

> 为什么 CardSecret 进 Keychain 而不是数据库：Keychain 本身加密且系统级保护，冷启动外泄面最小；普通 SQLite 文件即使加了文件保护，也暴露给所有能解密文件保护层的进程。

### 3.2 卡面资源模型

```dart
class CardFace {
  String faceId;            // 全局唯一
  String bankCode;          // 匹配银行
  String bankName;
  List<String> cardTypes;   // 适用类型
  FaceAssetType assetType;  // bundled | remote | gradient
  String? imageUrl;         // remote 时
  String? assetKey;         // bundled 时（assets 内路径）
  FaceFallback fallback;    // 兜底渐变 + 卡面文字
  int version;              // 版本号，用于增量更新
}

class FaceFallback {
  List<String> colors;      // 渐变 [start, end]
  String logoText;          // 如 "ICBC"
  double? cornerRadius;
  String? foreground;       // 文字颜色
}
```

---

## 4. 安全设计

### 4.1 分层加密

| 层 | 手段 |
|---|---|
| 敏感字段 | iOS Keychain（`flutter_secure_storage`，accessibility = `first_unlock_this_device`） |
| 元数据/余额 | SQLite + iOS 文件保护（`NSFileProtectionComplete`，启用 Data Protection capability） |
| 传输 | 卡面资源走 HTTPS |
| 截图防护 | 无法阻止系统截图，通过 F-19/F-20（临时显示 + 后台清屏）降低泄露面 |

### 4.2 遮挡与临时显示

- 卡号默认渲染为 `•••• •••• •••• 1234`（`card_number_mask.dart` 提供格式化）。
- 长按/点击「显示」→ 短暂明文 + **N 秒自动隐藏**（时长可在设置调整，默认 5s）。
- 注册 `AppLifecycleListener`：App 进入后台 → 清掉所有敏感状态变量并强制重新遮挡。
- 从详情复制卡号：复制到剪贴板时弹提示，提示用户粘贴后注意；**建议剪贴板明文带过期提醒**（可在 60s 后尝试替换，API 能力允许时）。

### 4.3 关键告警（给开发者）

- ⚠️ **禁止** 把卡号/CVV 写入日志、Firebase Crashlytics、分析上报。
- ⚠️ **禁止** 把 Keychain 数据同步进 iCloud（KVO 默认关闭）。
- ⚠️ 卡面资源站 **只放图片与清单**，不放任何用户数据接口。

---

## 5. 卡面系统设计

### 5.1 三层卡面来源

```
自定义卡面(用户本地)  >  远程卡面(网络更新)  >  内置卡面(随包)  >  兜底渐变
```

- **内置**：`assets/card_faces/bundled_manifest.json` + 压缩 PNG/JPG，随包发布。
- **远程**：静态资源站上的 `manifest.json` + 图片，增量下载到 `ApplicationSupport/card_faces/`。
- **自定义**：用户相册图片 / 渐变配色 / 文字，存应用沙盒，`customFace` JSON 引用。

### 5.2 卡面清单协议（manifest.json）

```json
{
  "schemaVersion": 1,
  "manifestVersion": 8,
  "updatedAt": "2026-08-01T00:00:00Z",
  "baseUrl": "https://cardface.example.com/v1/",
  "faces": [
    {
      "faceId": "cmb-debit-classic",
      "bankCode": "CMB",
      "bankName": "招商银行",
      "cardTypes": ["debit"],
      "assetType": "remote",
      "imageUrl": "cmb-debit-classic.png",
      "fallback": {
        "colors": ["#C8102E", "#7A0C1D"],
        "logoText": "CMB"
      },
      "version": 3
    }
  ]
}
```

- 地址：`{baseUrl}manifest.json`，请求带 `If-None-Match` / `ETag` 走 304 缓存。
- **更新流程**：
  1. 启动时读内置清单（版本 V_bundle）与本地缓存清单（版本 V_local）；
  2. 异步请求远程清单，成功 → 取 V_remote = max；
  3. V_remote > V_local → 逐个下载新增/变更图片到本地缓存，更新本地清单；
  4. 任一步失败 → 静默回退到 max(V_local, V_bundle)，下次再试；
  5. 设置页提供「手动检查更新」。

### 5.3 自定义卡面编辑器

- 画布 = 卡片正面的实时预览。
- 可调项：
  - 背景：相册图 / 预设渐变 / 纯色；
  - 文字：银行名、昵称、卡号样式（位置、字号、颜色、字距）；
  - Logo/图标：内置图标集 或 相册贴图；
  - 透明度叠加、圆角。
- 产出：`customFace` JSON（布局参数 + 图片引用），由同一个 `CardFaceWidget` 渲染，保证「编辑器所见即所得」。

### 5.4 卡面渲染（CardFaceWidget）

- 单一渲染组件：输入 `CardFace + CardMeta + CardSecret(遮挡后)` 输出卡片视图。
- 远程/内置卡面 = `Image` 自适应铺满 + 必要时叠加品牌文字；`gradient` = `Container` 渐变 + 文字。
- 卡片尺寸统一按 `3.37 : 2.125`（ISO/标准银行卡比例）取整。

---

## 6. OCR 相机读卡实现

### 6.1 流程

```
打开相机(camera) → 实时帧送 ML Kit TextRecognizer
   → 解析文本块(TextBlock)：
       ① 数字串 13~19 位 且 Luhn 通过  → 卡号候选
       ② 正则 \b\d{2}/\d{2}\b          → 有效期候选
       ③ 邻近卡号上方的全大写字母行     → 姓名候选
   → 达到置信度 → 冻结取景框 + 高亮命中区域
   → 用户确认 → 回填表单（可手动修正）
```

### 6.2 关键实现要点

- **实时识别**：用 `camera` 的 `startImageStream`，每帧降采样到合理分辨率（如 1080p）再送 OCR，避免过热；识别到稳定卡号后自动暂停。
- **Luhn 校验**：`core/utils/luhn.dart`，对候选数字串做 `double-alternate-digit` 校验，过滤银行卡号；不通过则继续扫描。
- **多候选**：同时命中的多张卡号 → 列表让用户选择。
- **权限**：`camera` 插件请求相机权限；拒绝时引导手动输入并关闭扫描页。
- **识别质量**：`google_mlkit_text_recognition` 离线运行，无网络请求，隐私友好。

---

## 7. 卡片 UI 与动画

### 7.1 首页轮播

- 横向 `PageView`，前后卡片错落缩放（`Transform.scale + Transform.translate`），当前卡高亮，接近系统钱包手感。
- 卡片点击 → 翻转进入详情。

### 7.2 3D 翻转

- `AnimatedBuilder` + `Matrix4` 绕 Y 轴旋转：`rotateY(theta)`，配合 `setPerspective`（透视系数 0.002），`AnimationController` 400ms，`Curves.easeInOut`。
- 翻转 90° 处切换正面/反面 Widget，避免镜像文字。

### 7.3 深色模式 / 无障碍

- 主题 token 化（`core/theme`），跟随系统深色模式。
- 卡片文字对比度满足 WCAG AA；支持 VoiceOver 朗读卡片信息（敏感字段朗读为遮挡态）。

---

## 8. 后端（卡面资源站）

| 项 | 方案 |
|---|---|
| 托管 | GitHub Pages / Cloudflare Pages / 任意对象存储 + CDN |
| 内容 | `manifest.json` + 卡面图片（PNG/WebP） |
| 更新 | 提交仓库 → CI 发布；或 CDN 直接覆盖 |
| 成本 | 个人使用几乎为 0；图片体积小、请求低频 |
| 安全 | HTTPS；无鉴权接口；**不存储/不接收任何用户数据** |

> **卡面图片来源（重要）**：银行 Logo 与卡面美术有商标/版权。**本项目一律不采用未经授权的聚合卡面图库**——如 Cardentify（其 GitHub 仓库与镜像站已被 DMCA 下架，卡面为 Apple Pay 系统提取的银行资产），无论从其残留 git 分支还是其网站拉取，都不允许。
>
> 合规做法：内置/远程库使用**自制的通用化配色 + 银行中文名/简称文字**，不复刻银行美术设计（见 PRD F-30/F-31）。逼真卡面体验通过「自定义卡面 → 拍照导入自己手里的实体卡」实现（个人管理自己拥有的卡，合规）。

---

## 9. 云端构建与发布（无 Mac 方案）

### 9.1 前置条件

| 项 | 说明 |
|---|---|
| Apple Developer Program | 约 $99/年，**必需**。免费 Apple ID 无法脱离 Xcode 侧载到设备 |
| App Store Connect | 创建 App、上传密钥（API Key） |
| Git 仓库 | 托管代码（GitHub / Gitee / GitLab） |

### 9.2 主路径：Codemagic（推荐）

1. Flutter 项目推送到 Git 仓库；
2. [Codemagic](https://codemagic.io) 登录 → Connect 仓库 → Add application；
3. 配置 iOS Workflow：
   - `flutter build ipa --release`；
   - 签名：上传 `.p12` 证书 + `.mobileprovision`（或用 Codemagic 的 Apple Developer 账号集成自动签名）；
   - 发布：App Store Connect API Key → 自动上传 TestFlight；
4. 在 iPhone 上用 TestFlight 安装验证。

> 免费额度足够个人开发；构建是云端 macOS 环境，本地 **完全不需要 Mac**。

### 9.3 备选：GitHub Actions + fastlane

- 自建 `.github/workflows/ios.yml`，用 macOS runner（免费额度）执行 `fastlane match` + `gym` + `pilot` 上传 TestFlight。
- 证书/密钥存仓库 Secrets。

### 9.4 发布形态

| 形态 | 场景 | 说明 |
|---|---|---|
| TestFlight 内测 | 自用/小范围 | 免费，无需审核，最快的真机测试通道 |
| App Store 上架 | 公开分发 | 需要过审核；本应用为本地工具类，风险中等（见 §11） |

---

## 10. 测试策略

| 层 | 工具 | 覆盖点 |
|---|---|---|
| 单元 | `flutter_test` | Luhn 校验、卡号解析/遮挡格式化、manifest 合并逻辑、余额格式化 |
| Widget | `flutter_test` | 卡片渲染（三种 assetType）、轮播翻页、遮挡/显示交互 |
| 集成 | `integration_test` | 增删改查全流程（Mock Keychain）、自定义卡面保存/加载 |
| 真机 | TestFlight 内测 | OCR 识别准确率、3D 翻转帧率、后台遮挡、深色模式 |

目标：核心 util 覆盖率 ≥ 80%；Keychain 读写用 mock 保证测试可在 Windows 上跑。

---

## 11. 风险与对策

| 风险 | 等级 | 对策 |
|---|---|---|
| 无 Mac，iOS 真机调试受限 | 中 | 逻辑/UI 在 Windows 桌面 + Android 验证；iOS 靠 TestFlight 内测迭代，节奏拉长一点 |
| Apple 账号费用（$99/年） | 中 | 确认投入；若只想自用，TestFlight 仍是最低成本的验证通道 |
| App Store 审核：类钱包/金融敏感 | 中 | 明确定位为「本地卡包记录工具」；隐私标签如实声明；本地存储说明写进应用简介与隐私政策 |
| OCR 误识别 | 中 | Luhn 校验 + 高亮确认 + 可手动修正；识别置信度阈值可调 |
| 卡面版权/商标 | 中 | 内置库用通用化配色 + 银行名文字；逼真卡面仅个人自用不公开 |
| 低系统真机（如 iOS 15）出现 | 低 | Flutter 支持 iOS 11+，目标降到 15 即可，成本低 |
| 数据丢失（删除/卸载） | 低 | 卸载即清空属预期（隐私优先）；后续 v1.1 评估加密导出/导入（F-26） |

---

## 12. 第三方库风险自查

- `google_mlkit_text_recognition`：Google 维护，离线推理，遵守其许可；不传图像上云。
- `flutter_secure_storage`：成熟插件，内部走 Keychain；注意其 `accessibility` 参数按「首次解锁后可用」配置。
- 所有网络请求仅指向卡面资源站域名；**代码中不埋任何用户数据上报埋点**。
