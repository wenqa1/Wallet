# 打包与发布指南（无 Mac → 云端 IPA）

> 本机是 **Windows 无 Mac**，iOS 的 `.ipa` 无法本地生成（`flutter build ipa` 需要 macOS/Xcode）。
> 项目已配置 **Codemagic 云端构建**（[codemagic.yaml](../codemagic.yaml)），一键出包并上传 TestFlight。

## 0. 需要准备的东西

| 项 | 说明 | 花费 |
|---|---|---|
| Apple Developer Program | 开发者账号，签名与 TestFlight 必需 | 约 $99/年 |
| App Store Connect API Key | 供 Codemagic 自动签名 + 上传 | 免费 |
| Git 远端仓库 | GitHub / Gitee / GitLab | 免费 |
| Codemagic 账号 | 云端 macOS 构建 | 免费额度 |

> 免费 Apple ID 无法脱离 Xcode 侧载，本项目必须付费开发者账号。

## 1. 推送代码到远端

```bash
cd e:/lianxi/kabao
git remote add origin <你的仓库地址>
git push -u origin main
```

## 2. 配置 Codemagic

1. 打开 [codemagic.io](https://codemagic.io) → 登录 → **Add application** → 选择你的仓库。
2. 项目设置 → **Environment variables** 添加：
   - `APP_STORE_CONNECT_KEY_IDENTIFIER` — App Store Connect API Key 的 Key ID
   - `APP_STORE_CONNECT_ISSUER_ID` — Issuer ID
   - `APP_STORE_CONNECT_PRIVATE_KEY` — API Key 的 `.p8` 私钥内容
3. 把 [codemagic.yaml](../codemagic.yaml) 里的两个占位改成你的：
   - `APP_STORE_APP_ID` → App Store Connect 中 App 的 Apple ID（纯数字）
   - 邮箱收件人 → 你的邮箱
4. 在 App Store Connect 创建 App（Bundle ID 填 `com.kabao.kabao`），不填即可上 TestFlight。

### App Store Connect API Key 在哪生成
[App Store Connect](https://appstoreconnect.apple.com) → 用户与访问 → 密钥 → App Store Connect API → 生成密钥（勾选 **App Manager** 权限）→ 保存 `.p8` 文件。

## 3. 触发构建

- 推送到 `main` 分支自动触发；或 Codemagic 页面点 **Start new build**。
- 流水线会依次执行：`pub get` → `flutter analyze` → `flutter test` → `flutter build ipa --release` → 上传 TestFlight。

## 4. 安装到 iPhone

1. TestFlight 中邀请你的 Apple ID（或设备 UDID 注册）。
2. iPhone 安装 **TestFlight** App → 接受邀请 → 安装「卡包」。

## 5. 备选方案：GitHub Actions（自建）

若不用 Codemagic，可在仓库加 `.github/workflows/ios.yml`：

```yaml
name: iOS build
on: [push]
jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { channel: stable }
      - run: flutter pub get
      - run: flutter build ipa --release --no-codesign
      - uses: actions/upload-artifact@v4
        with: { name: ipa, path: build/ios/ipa/*.ipa }
```

> `--no-codesign` 只出无签名 IPA（真机装不上）；要装真机仍需要证书/密钥（fastlane match 或 `apple-actions/import-codesigning-certs`）。

## 6. 版本号约定

`codemagic.yaml` 已按 `git rev-list --count HEAD` 生成 build number，build name 固定 `1.0.0`（正式发布时改为从 tag 取）。

## 7. 常见问题

- **签名失败**：检查 API Key 权限是否为 App Manager；Bundle ID 与 App Store Connect 一致。
- **TestFlight 上传成功但设备装不上**：确认设备已在 TestFlight 邀请名单。
- **审核被拒**：本应用定位为「本地卡包记录工具」，隐私标签声明「未收集数据、敏感信息仅存本机」，一般可通过。

## 8. 相关文件

- [codemagic.yaml](../codemagic.yaml) — 云端构建流水线
- [README.md](../README.md) — 快速开始
- [docs/TECH.md](TECH.md) — 技术设计（含云端构建章节）
