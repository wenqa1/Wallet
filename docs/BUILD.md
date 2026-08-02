# 打包与发布指南

> 本机是 **Windows 无 Mac**。无论是否越狱，iOS 的 `.ipa` **都必须**在 macOS 上编译（`flutter build` iOS 只支持 macOS/Xcode 宿主）。但「签名 + 上架」这一步可以绕开：**越狱 + 巨魔商店** 让你免去 $99/年 开发者账号。

## 方案对比

| | 🥇 巨魔商店（TrollStore） | App Store / TestFlight |
|---|---|---|
| 需要 Mac | ❌ 云端即可（Codemagic 免费） | ❌ 云端即可 |
| Apple Developer 账号 | ❌ **不需要** | ✅ 约 $99/年 |
| 签名 / 证书 / 密钥 | ❌ 不需要 | ✅ 需要 |
| 成本 | **0 元** | $99/年 |
| 安装方式 | 手机打开 IPA → 巨魔装 | TestFlight / App Store |
| 适用 | 越狱 + 巨魔支持的系统版本 | 普通设备 |

> 巨魔商店支持范围：iOS 14.0–16.6.1、17.0（CoreTrust 漏洞 / kfd）。你的 iOS 16~17 设备只要在支持列表内即可。

---

## 方案 A：巨魔商店（推荐，免费）

### 1. 推代码到远端

```bash
cd e:/lianxi/kabao
git remote add origin <免费仓库地址，如 GitHub/Gitee>
git push -u origin main
```

### 2. 绑定 Codemagic（免费）

1. 打开 [codemagic.io](https://codemagic.io) → 登录（免费）→ **Add application** → 选你的仓库。
2. 仓库根目录已有 [codemagic.yaml](../codemagic.yaml)，其中 `ios-trollstore` 工作流会：
   - `pub get` → `flutter analyze` → `flutter test` → `flutter build ipa --release --no-codesign`
   - 产出 **无签名 IPA**，不碰任何 Apple 凭据。
3. 推送 `main` 自动触发；也可在页面手动 **Start new build**（选 `ios-trollstore`）。

### 3. 拿到 IPA 并装到手机

1. 构建完成后，从 Codemagic **Artifacts** 下载 `*.ipa`（或 `Runner.ipa` 兜底产物）。
2. 把 IPA 传到你手机（AirDrop / 网盘 / 微信文件 / 数据线）。
3. 手机用 **文件 App** 打开 IPA → 分享到 **巨魔商店** → 点击安装。
4. 主屏幕出现「卡包」即可使用。

### 注意事项
- 巨魔商店要求 App 的 Bundle ID 不与已装 App 冲突（本项目 `com.kabao.kabao`）。
- 每次改代码重出包，直接覆盖安装即可，数据保留。
- 无签名 IPA 不能用于非越狱设备。

---

## 方案 B：App Store / TestFlight（普通设备）

> 仅当你需要在不越狱的 iPhone 上使用，或想公开分发时才需要。

### 需要准备
| 项 | 说明 |
|---|---|
| Apple Developer Program | 约 $99/年 |
| App Store Connect API Key | 供 Codemagic 自动签名 + 上传（用户与访问 → 密钥 → App Store Connect API，勾选 App Manager） |
| Git 远端仓库 | 同方案 A |

### 步骤
1. 同方案 A 推代码、绑定 Codemagic。
2. 在 Codemagic 设置 **Environment variables**：
   - `APP_STORE_CONNECT_KEY_IDENTIFIER` / `APP_STORE_CONNECT_ISSUER_ID` / `APP_STORE_CONNECT_PRIVATE_KEY`
3. 把 [codemagic.yaml](../codemagic.yaml) 中 `ios-release` 工作流的占位改成你的：`APP_STORE_APP_ID`、收件邮箱。
4. App Store Connect 创建 App（Bundle ID `com.kabao.kabao`）。
5. 推送到 `release/*` 分支触发 → 自动上传 TestFlight → iPhone 装 TestFlight 安装。

---

## 版本号

两个工作流都用 `git rev-list --count HEAD` 生成 build number，build name 固定 `1.0.0`（正式发布改为从 tag 取）。

## 常见问题

- **巨魔装了打不开/闪退**：确认系统版本在支持范围；重新出包覆盖安装。
- **TestFlight 上传成功但装不上**：设备需在 TestFlight 邀请名单。
- **App Store 审核**：定位「本地卡包记录工具」，隐私标签如实声明，一般可通过。
- **为什么 Windows 不能本地打 IPA**：iOS 编译需要 macOS + Xcode（clang 交叉编译链）。云端 macOS 是唯一路径，与是否签名/越狱无关。

## 相关文件

- [codemagic.yaml](../codemagic.yaml) — 云端构建流水线（巨魔 + TestFlight 双工作流）
- [README.md](../README.md) — 快速开始
- [docs/TECH.md](TECH.md) — 技术设计
