# 卡包（Wallet 平替）

一款类 iOS 钱包的本地卡包管理应用。由于低版本 iOS 无法向系统钱包添加部分卡片，本应用作为"钱包平替"，帮你把所有卡（银行卡、会员卡、交通卡等）集中管理：卡面展示、相机读卡号、余额记录、敏感信息遮挡，全部数据**本地加密存储、不上传服务器**。

> 本质是一个"卡面 + 信息的本地展示与管理工具"，不涉及任何支付、扣款、交易能力。

---

## 功能亮点

- 💳 **钱包式卡包**：卡片轮播、3D 翻转、卡片详情
- 🏦 **卡面系统**：内置主流银行通用卡面（银行主题配色 + 行名，合规可上架）+ 网络增量更新 + 完全自定义卡面（可拍照导入实体卡）
- 📷 **相机读卡号**：对着卡片扫描，OCR 识别卡号（Luhn 校验）、姓名、有效期，自动填表
- ✍️ **手动录入**：卡号、持卡人、有效期、CVV、余额、备注全部可自定义
- 💰 **余额管理**：每张卡可记录余额，随时更新
- 🔒 **本地加密**：卡号/CVV 等敏感字段存 iOS Keychain，卡面以外的数据不离开设备
- 👁 **敏感信息遮挡**：卡号默认只显示后四位，长按临时显示并自动隐藏

## 技术栈

| 项 | 选型 |
|---|---|
| 框架 | Flutter (Dart) |
| 最低系统 | iOS 16+（Flutter 本身支持 iOS 11+，可下探） |
| 状态管理 | Riverpod |
| 导航 | go_router |
| 本地数据库 | Drift（SQLite，类型安全） |
| 安全存储 | flutter_secure_storage（iOS Keychain） |
| OCR | camera + google_mlkit_text_recognition |
| 网络 | dio + cached_network_image |
| iOS 构建 | Codemagic 云端 CI（本地无 Mac 也可出包） |

## 目录结构

```
kabao/
├── README.md
├── .gitignore
├── docs/
│   ├── PRD.md        # 产品需求文档（背景、功能需求、里程碑）
│   ├── TECH.md       # 技术设计文档（架构、数据模型、安全、OCR、构建）
│   └── TASKS.md      # 分阶段开发任务清单（M0 已基本完成）
├── data/
│   └── card_faces/   # 卡面数据源（banks_cn.json + bundled_manifest.json）
├── app/              # Flutter 工程（已初始化，analyze 零问题，14 测试通过）
└── tools/            # 本地 Flutter SDK（3.44.8，中国镜像，不入 git）
```

## 快速开始（无 Mac 环境）

1. **本地开发**：Flutter SDK 已装在 `tools/`。命令：
   ```bash
   export PATH="$PWD/tools/flutter/bin:$PATH"
   export PUB_HOSTED_URL="https://pub.flutter-io.cn"
   export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
   cd app && flutter test      # 跑测试
   flutter analyze             # 静态检查
   ```
2. **本地跑 App（可选）**：需先开启 Windows 开发者模式（`start ms-settings:developers`），并安装 Visual Studio 的"使用 C++ 的桌面开发"工作负载，然后 `flutter run -d windows`。不装也能开发——代码以 iOS 云端构建为准。
3. **iOS 出包**：本机无 Mac 无法本地打 `.ipa`，已配好 **Codemagic 云端流水线**（[codemagic.yaml](codemagic.yaml)）。步骤：推代码到 Git 仓库 → Codemagic 绑定 → 配置 Apple 签名 → 云端构建 → TestFlight 装到 iPhone。完整指南见 **[docs/BUILD.md](docs/BUILD.md)**。
4. **前置条件**：需要 Apple Developer Program 会员（约 $99/年）。免费 Apple ID 无法脱离 Xcode 侧载，云端构建必须付费账号。

详见 [docs/TECH.md](docs/TECH.md) 与 [docs/BUILD.md](docs/BUILD.md)。

## 文档索引

- [docs/PRD.md](docs/PRD.md) — 产品需求文档
- [docs/TECH.md](docs/TECH.md) — 技术设计文档
- [docs/TASKS.md](docs/TASKS.md) — 任务清单
