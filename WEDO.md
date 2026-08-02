# WEDO · 工作汇总

> 每次完成一个任务后，把结果汇总到这里。格式：`日期 时间 · 任务` → 做了什么 / 验证结果 / 下一步。

---

## 2026-08-03 00:15 · M0 项目骨架初始化

**做了什么**
- 安装了 Flutter SDK 3.44.8 到 `tools/`（中国镜像，未占用 C 盘）
- `flutter create app` 初始化工程（ios / android / windows 三平台，org `com.kabao`）
- 引入依赖：flutter_riverpod、go_router、drift(+drift_flutter)、flutter_secure_storage、dio、cached_network_image、image_picker、camera、google_mlkit_text_recognition、freezed
- 搭建 feature-first 三层结构；写好基础代码（主题/深色、路由、Drift 数据库、CardFace 模型与仓储、CardFaceWidget、首页）
- 生成内置通用卡面数据：`banks_cn.json`（19 银行）+ `bundled_manifest.json`（18 卡面）
- 卡面库决策：Cardentify 因 **DMCA 下架**不可用，改用自研「银行配色 + 行名文字」合规方案；逼真卡面由「拍照导入自己实体卡」实现

**验证结果**
- `flutter analyze`：零问题
- 测试 14 项全部通过（Luhn 校验、卡号遮挡、内置清单加载、首页卡面渲染）
- 已提交：`f736d3f chore: bootstrap kabao wallet app skeleton (M0)`

**环境注意事项**
- 测试需 Windows 开发者模式（插件符号链接）；sqlite3 DLL 走 GitHub 慢，已用 ghfast.top 镜像预置缓存
- iPhone 真机仍需 Apple Developer 账号 + Codemagic 云构建

**下一步** → M1：卡片增删改查（Keychain 敏感字段接入、添加/编辑表单、列表真实数据）

---

## 2026-08-03 00:50 · M1 卡片增删改查

**做了什么**（TDD：RED → GREEN 各一个检查点提交）
- **数据层**
  - `CardSecret` 模型（卡号/持卡人/有效期/CVV，JSON 编解码）
  - `SecretStore` 抽象接口 + `SecureStorageService`（Keychain）实现
  - `CardRepository` 接口 + `DriftCardRepository`：组合 Drift 元数据 + Keychain 敏感字段；增删时两处同步写入/清理
  - `CardMeta` 表新增 `last4` 列（列表展示后四位，无需读 Keychain）
- **UI 层**
  - `CardFormPage`：添加/编辑两用表单（银行/类型下拉、卡号 Luhn 校验、昵称/持卡人/有效期/CVV/余额、实时卡面预览）
  - `CardListPage`：真实卡片网格 + FAB 添加 + 点卡底部操作单（编辑/删除）+ 删除二次确认
  - `BankCatalog` 从 `banks_cn.json` 加载银行目录；`CardFace.gradientFor` 工厂按银行主题色合成渐变卡面
- **测试基建**：`FakeCardRepository`（纯内存）+ `TestHarness`

**验证结果**
- `flutter analyze`：零问题
- **24 个测试全部通过**（数据层 5 + Luhn/遮挡 12 + 表单 3 + 列表 4）

**踩坑记录（重要）**
1. **Drift 真库在 testWidgets 的 FakeAsync 下不完成**（流式 StreamProvider 永不发数据）→ Widget 测试改用 `FakeCardRepository` 注入，真库留给 `test()` 数据层测试
2. **测试卡号必须过 Luhn**：`6225882000001234` 校验和=48 不合法，被表单正确拦截（测试数据错误，改 `4111111111111111`）
3. **ListView 懒挂载**：编辑模式卡面预览高 ~450px 把输入框推出视口，字段不挂载 → 测试用加高视口（2400×4800@3x）
4. **后台任务残留进程锁文件**：TaskStop 后遗留 dart.exe 锁住 `build/native_assets/.../sqlite3.dll` → 需 taskkill 清理后再跑测试

**提交**：`6db9dd2`(RED) → `d62a1cd`(数据层 GREEN) → `3915188`(UI GREEN)

**下一步** → M2：卡面系统深化（内置库选择器 + 自定义卡面编辑器）或 M1 验收（真机/模拟器跑通全流程）

---

## 2026-08-03 01:48 · M2 卡面系统深化

**做了什么**（TDD，2A 数据层 + 2B UI 层各一组 RED→GREEN）
- **2A 数据层**
  - `CustomFace` 模型（渐变/前景色/Logo/银行名/背景图路径）+ JSON 序列化
  - `color_utils`：hex ⇄ Color 互转（CardFace 复用）
  - `CardFaceResolver`：解析优先级 **自定义 > faceId > 银行默认 > 渐变兜底**，损坏 JSON 容错
  - `CardFaceWidget` 升级：支持自定义卡面（背景图 / 渐变）与 bundled/remote 图片渲染
- **2B UI 层**
  - `showCardFacePicker`：底部弹层浏览内置卡面库，选中高亮，返回 faceId
  - `CardCustomFaceEditor`：渐变预设 + 前景色切换 + Logo/银行名文字 + **相册背景图**（`CustomFaceImageStore` 复制进应用支持目录防失效）+ 实时预览
  - 表单集成：卡面预览 + 「选择卡面」「自定义」按钮，保存写入 `faceId` + `customFace` JSON，编辑模式预填

**验证结果**
- `flutter analyze`：零问题
- **36 个测试全部通过**（新增：CustomFace 3 + Resolver 5 + 选择器 1 + 编辑器 1 + 表单卡面 2）

**提交**：`bec3f78`(2A RED) → `9c3b117`(2A GREEN) → `fefe423`(2B RED) → `86d2192`(2B GREEN)

**说明**：相册背景图路径已支持并持久化，但 widget 测试未覆盖（image_picker 插件在测试中无法交互），需真机验证。

**下一步** → M3：相机 OCR 读卡（实时识别 + Luhn + 人工确认）；或先真机验收 M1/M2

---

## 2026-08-03 01:52 · 验收 + iOS 打包准备

**验收结果**
- `flutter pub get`：正常
- `flutter analyze`：**零问题**
- 测试：**36 项全部通过**
- 功能核对（对照 PRD）：
  - M1 卡片增删改查（添加表单/编辑/删除确认/列表）✅
  - M2 卡面系统（解析器/选择器/自定义编辑器/持久化）✅
  - 敏感信息遮挡（卡号后四位展示）✅；Keychain 敏感字段存储 ✅

**iOS 打包（无 Mac → 云端）**
- **本机是 Windows，无法直接产出 .ipa**（需要 macOS/Xcode）——这与签名/越狱无关
- 已配置 **Codemagic 云端流水线** `codemagic.yaml`，含两个工作流：
  - `ios-trollstore`：**无签名 IPA**（用户越狱 + 巨魔商店，免费，无需 $99 开发者账号）→ 推荐
  - `ios-release`：有签名 IPA → TestFlight（需开发者账号，备选）
- iOS 配置补充：显示名「卡包」、`NSCameraUsageDescription`（OCR 用）、`NSPhotoLibraryUsageDescription`（自定义卡面相册背景）
- 打包发布完整指南见 **docs/BUILD.md**（巨魔方案优先）
- 待用户操作：推远端仓库 + Codemagic 免费绑定 → 云端出无签名 IPA → 巨魔商店直装

**其他**
- 保存记忆：项目约束 + 「每任务调用对应 skill」工作偏好

---

## 2026-08-03 01:58 · 推送到 GitHub

- 远端：`https://github.com/wenqa1/Wallet.git`（origin/main）
- 13 个提交全部推送成功，工作区干净，远端 HEAD = 本地 `4e04963`
- 下一步：用户到 Codemagic 免费绑定仓库 → 触发 `ios-trollstore` 构建 → 巨魔商店装无签名 IPA

---

## 2026-08-03 02:08 · 云端构建排障 + 主动修复

**用户反馈的 Codemagic 错误**
1. `codemagic.yaml` 校验失败（email recipients 非法）→ 移除占位邮箱块
2. "Expected to find project root in current working directory" → Flutter 工程在 `app/` 子目录，两个工作流加 `working_directory: app`

**主动排查并修复的隐患**
1. **`flutter build ipa --no-codesign` 会跳过 IPA 生成**（查 Flutter SDK 源码确认，只出归档）→ 改用 `flutter build ios --release --no-codesign` 产 `Runner.app`，再用 `ditto` 打包 `Runner.ipa`
2. **部署目标 13.0 不满足插件要求**：`google_mlkit_text_recognition` 要求 iOS 15.5+ → 把 `IPHONEOS_DEPLOYMENT_TARGET` 提到 **16.0**（符合 PRD 最低 iOS 16）
3. `flutter build ios` 不支持 `--build-name/--build-number`（源码确认）→ 去掉，版本走 pubspec
4. 相机/相册权限描述已加（Info.plist）

**待用户**：Codemagic 重新触发 `ios-trollstore` 构建

---

## 2026-08-03 02:30 · M3 相机 OCR 读卡

**做了什么**（TDD，3A 纯逻辑 → 3B 状态机 → 3C UI 三层，各 RED→GREEN）
- **3A** `CardScanParser`：从 OCR 文本行提取 Luhn 合法卡号（13~19 位、容行首干扰）、卡号上一行姓名、同/邻行有效期 MM/YY
- **3B** `CardScanController`：状态机 idle/scanning/found/error，同卡号连续 N 帧稳定进入 found、卡号变化重置；`OcrRecognizer` 抽象 + `MlKitOcrRecognizer`（端侧识别）
- **3C** `CardScanPage`：相机实时帧 OCR（CameraImage→InputImage→ML Kit→controller）、取景框、稳定命中弹 `ScanResultCard`（重新扫描/确认使用）；表单卡号框加相机扫描入口，回填卡号/持卡人/有效期

**验证结果**
- `flutter analyze`：零问题
- **56 个测试全部通过**（新增 20：解析器 10 + 控制器 7 + 结果卡 2 + 表单扫描入口 1）

**说明**：相机/ML Kit 无法在 widget 测试环境运行，`CardScanPage` 的实时帧识别需**真机验收**（iOS 相机格式为 BGRA8888，Android 为 NV21）。

**提交**：解析器 RED/GREEN → 控制器 RED/GREEN → 结果卡/扫描页/表单 GREEN

**下一步** → M4：钱包式轮播 UI + 卡面网络增量更新（manifest 协议 + 下载）

---

## 2026-08-03 03:20 · M4 钱包式 UI + 卡面网络更新

**做了什么**（4A 数据层 → 4B 设置页 → 4C UI，TDD 分步提交）
- **4A 卡面网络更新**
  - `RemoteFaceManifest` 解析（schema/manifestVersion/baseUrl/faces）
  - `CardFaceUpdateService`（接口）+ `NetworkCardFaceUpdateService`：版本比较、远程卡面图片增量下载、同版本跳过、失败静默回退；Dio 304/ETag
  - `DriftCardFaceStore`：清单/版本存 `CardFaceCache` 表，图片存应用支持目录；`allFacesProvider` = 内置 + 远程
- **4B 设置页**
  - `SettingsStore` + SharedPreferences：遮挡时长持久化（3/5/10/15s）
  - `SettingsPage`：遮挡时长切换、已缓存远程卡面数、手动检查更新（SnackBar 结果）
- **4C 钱包式 UI**
  - `CardCarousel`：PageView + 错落缩放轮播
  - `CardFlipView`：3D 翻转（Matrix4 rotateY + 透视），正面卡面 / 背面详情（持卡人/有效期/CVV/余额/编辑删除）
  - `RevealNotifier`：长按卡号临时显示 → 到时自动隐藏（定时器、可重置）；`KabaoApp` 后台清屏（inactive/paused 强制隐藏，防窥探）
  - 首页网格 → 轮播；删除改翻转到背面操作

**验证结果**
- `flutter analyze`：零问题
- **71 个测试全部通过**（新增 14：manifest 2 + 更新服务 4 + 设置 2 + reveal 3 + 卡背面 2 + 翻转 1 + 轮播 1）

**待办**
- 远程卡面图片的 `CardFaceWidget` 渲染（本地文件路径）留待 M5 资源站落地后接
- 里程碑验收需真机

**提交**：4A(2) + 4A接入(1) + 4B(1) + 4C(3)

**下一步** → M5：卡面静态资源站搭建（manifest + 图片 + CI 发布）或真机验收

---

## 2026-08-03 03:50 · M5 卡面资源站

**做了什么**
- **5A（App 端）**：远程卡面图片渲染 —— `CardFaceStore.imagePath`（本地缓存文件）、`remoteFacePathProvider`；`CardFaceWidget` 三级渲染：**本地图片 > 在线兜底(Image.network) > 渐变**；轮播远程卡面接本地图片
- **5B（资源站）**：`tools/generate_card_faces.py`（PIL）生成 **19 张通用渐变卡面 PNG**（银行主题色 + 行名文字）+ `site/manifest.json`（manifestVersion 2，baseUrl 指向 GitHub Pages）；`.github/workflows/pages.yml` push `site/` 自动部署 Pages
- **5C（接入）**：App 资源站地址默认 `https://wenqa1.github.io/Wallet/manifest.json`（可 --dart-define 覆盖）

**验证结果**
- `flutter analyze`：零问题
- **73 个测试全部通过**（新增：远程卡面图片渲染 1 + 生成的 manifest 可解析 1）
- 生成的 site/manifest.json 能被 `RemoteFaceManifest` 正确解析（测试覆盖）

**待用户操作**
1. 仓库 Settings → Pages → Source 选 **GitHub Actions**
2. 推送后 Pages 部署生效；Codemagic 出包装真机 → 设置页「检查卡面更新」→ 远程卡面下载并显示

**提交**：5A(2) + 5B/5C(1)

**下一步** → M6：图标/上架材料 + TestFlight/巨魔安装全流程验收

---

## 2026-08-03 04:10 · M6 上架准备

**做了什么**
- **6A 图标**：`tools/generate_app_icon.py`（PIL 银行卡主题图标）→ `flutter_launcher_icons` 生成 iOS/Android 全尺寸图标；App 名称「卡包」、版本 0.1.0+1
- **6B 隐私页**：`PrivacyPage`（数据本地存储/权限/联网/卡面资源声明）+ 路由 `/privacy` + 设置入口
- **6C 覆盖率**：`flutter test --coverage` 核查 + `tools/coverage_report.py` 报告工具

**覆盖率结论**
- 全局行覆盖率约 47%；**核心业务逻辑 100%**（luhn/遮挡/颜色/模型/更新服务/仓储/扫描解析器/控制器/RevealNotifier 等 15 个文件）
- 0% 的均为平台边界（Drift 真库/Keychain/相机/image_picker/SharedPreferences），需真机集成测试

**验证**：analyze 零问题；**77 个测试全通过**（新增 3：bank_catalog 2 + settings_store 1 + privacy 1）

**待用户（无法代劳）**
1. App Store Connect 隐私标签（App Privacy）填写
2. TestFlight / 巨魔内测真机回归（OCR、动画、后台遮挡、深色模式）
3. App Store 提交 + 审核材料

**下一步** → 真机验收全流程（M3 OCR / M4 轮播翻转 / M5 网络更新）

---
