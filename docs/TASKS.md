# 卡包（Wallet 平替）· 开发任务清单

> 对应 [PRD.md](PRD.md) 里程碑。勾选为完成。

## M0 · 项目骨架 + 云端 CI（1 周）

- [x] 安装 Flutter SDK 到 `tools/`（中国镜像，3.44.8 stable）
- [x] `flutter create app` 创建工程（org `com.kabao`，支持 ios/android/windows）
- [x] 搭建目录结构（见 TECH §2.1，feature-first 三层）
- [x] 引入依赖：riverpod、go_router、drift、drift_flutter、flutter_secure_storage、camera、mlkit、dio、cached_network_image、image_picker、freezed
- [x] 基础代码：主题 + 深色模式 + go_router + Drift 数据库（CardMeta/CardFaceCache 表）+ CardFace 模型/仓储 + CardFaceWidget（渐变卡面）+ 首页
- [x] 卡面数据：`app/assets/card_faces/`（banks_cn.json + bundled_manifest.json，19 银行 / 18 卡面）
- [x] 单元/Widget 测试 14 个全部通过；`flutter analyze` 零问题
- [ ] Git 仓库初始化 + 推送到远端
- [ ] Codemagic 接入 + iOS 构建 Workflow 配置
- [ ] Apple Developer 账号、App Store Connect API Key 配置
- [ ] **里程碑验收**：云端出包 → TestFlight → iPhone 真机安装成功

### 环境注意事项（Windows 本地）

- 本地跑 App/测试需先开启 **Windows 开发者模式**（插件符号链接）：`start ms-settings:developers`
- 本地构建 Windows 桌面版需安装 **Visual Studio + "使用 C++ 的桌面开发"工作负载**（可选，非 iOS 必需）
- 测试时 sqlite3 原生资产会从 GitHub 下载 DLL；国内网络需先经镜像预置（已放入 `.dart_tool/.../download-*/sqlite3.dll`）。清缓存后如需复现：`ghfast.top` 等镜像下载对应 DLL 放入同名目录

## M1 · 数据模型 + 安全存储 + 卡片 CRUD（1 周）

- [x] Drift 数据库初始化：`card_meta` 表 + DAO（含 `last4` 列）
- [x] Keychain 服务封装：`SecretStore` 抽象 + `CardSecret` 读写删
- [x] `CardRepository`（接口）+ `DriftCardRepository`：组合 DB + Keychain 增删改查
- [x] `luhn.dart` 单元测试（先 RED 后 GREEN）
- [x] 卡片添加表单（手动录入，Luhn 校验 + 卡面预览）+ 编辑 + 删除（二次确认）
- [x] 卡片列表（网格版，FAB 添加，点卡底部操作单）
- [ ] 搜索/排序（延后至 M1.5 或随卡片多时再补）
- [ ] **里程碑验收**：手动添加一张卡 → 杀进程重开数据还在 → Keychain 里有卡号（需真机/模拟器验证）

## M2 · 卡面系统（1.5 周）

- [x] `CardFace` 模型 + 内置清单 `bundled_manifest.json`（19 银行 / 18 卡面，通用配色 + 行名文字，不复刻银行美术）
- [x] `CardFaceWidget`：bundled / remote / gradient 三种渲染 + 自定义卡面（背景图/渐变）
- [x] `CardFaceResolver`：自定义 > faceId > 银行默认 > 渐变兜底，损坏 JSON 容错
- [x] 卡面选择器（内置库浏览，选中高亮）
- [x] 自定义卡面编辑器（渐变预设/前景色/Logo/银行名/相册背景图）+ 实时预览
- [x] `customFace` JSON 持久化与加载（存 `CardMeta.customFace`）
- [ ] **里程碑验收**：新卡自动带卡面；自定义卡面保存后重启仍在（需真机/模拟器验证）

## M3 · 相机 OCR 读卡（1 周）

- [x] 相机权限流程 + 扫描页 UI（取景框、提示文案，权限描述已加 Info.plist）
- [x] 实时帧 OCR（`google_mlkit_text_recognition`，`MlKitOcrRecognizer` 端侧识别）
- [x] 卡号提取 + Luhn 校验 + 多候选（`CardScanParser` + `CardScanController` 稳定帧确认）
- [x] 有效期 / 姓名辅助识别（同/邻行 MM/YY + 卡号上一行大写姓名）
- [x] 结果确认表单（`ScanResultCard`：可修正、可重扫）
- [ ] **里程碑验收**：真机对着储蓄卡/信用卡各扫一张，卡号准确回填（需真机，相机/ML Kit 无法在测试环境跑）

## M4 · 钱包式 UI + 卡面网络更新（1 周）

- [x] 首页卡片轮播（PageView + 错落缩放，`CardCarousel`）
- [x] 3D 翻转详情页 + 敏感遮挡（`CardFlipView` + 卡背面 `••••` 样式）
- [x] 长按临时显示 + 自动隐藏（`RevealNotifier` 定时器）+ 后台清屏（AppLifecycleListener）
- [x] 余额录入/更新 + 卡片上展示（M1 完成 + 卡面展示）
- [x] 卡面网络更新：manifest 拉取、增量下载、失败回退（`CardFaceUpdateService`，ETag 走 Dio 304）
- [x] 设置页：遮挡时长（SharedPreferences）、手动检查更新（结果 SnackBar）
- [ ] **里程碑验收**：轮播流畅（真机 60fps）；切后台回来卡号保持遮挡；远程卡面能更新（需真机 + M5 资源站）

## M5 · 卡面资源站（0.5 周）

- [x] 搭建静态资源站（GitHub Pages，`.github/workflows/pages.yml` 自动部署 `site/`）
- [x] 生成 manifest.json + 19 张卡面图片（`tools/generate_card_faces.py`，通用化配色 + 银行名文字）
- [x] CI 发布脚本（push `site/` 即触发 Pages 部署）
- [ ] **里程碑验收**：修改资源站 → App 手动检查更新拉取成功（需：仓库 Settings→Pages→Source 选 GitHub Actions；Codemagic 出包装真机后验证）

### 更新资源站步骤
1. `python tools/generate_card_faces.py`（重新生成 site/）
2. push 到 main → GitHub Actions 自动部署 Pages → App 设置页「检查卡面更新」拉取

## M6 · 测试打磨 + 上架（1 周）

- [x] 单元测试补齐：Luhn、卡号解析/遮挡、卡面解析/更新服务、manifest 解析（核心逻辑 100%）
- [x] Widget 测试：卡片渲染、轮播、翻转、遮挡交互、表单、设置、隐私页（77 项全过）
- [ ] 集成测试：增删改查全流程（Drift/Keychain 需真机；当前以数据层单测 + widget 测试覆盖）
- [x] 应用内隐私说明页（`PrivacyPage`，路由 + 设置入口）
- [x] 图标（`flutter_launcher_icons` 生成 iOS/Android 全尺寸）、App 名称「卡包」、版本号 0.1.0+1
- [ ] 隐私标签（App Privacy）在 App Store Connect 填写（需用户账号）
- [ ] TestFlight / 巨魔内测（真机回归：OCR、动画、后台遮挡、深色模式）——需用户
- [ ] App Store 提交 + 审核材料（截图、描述、隐私政策 URL）——需用户
- [ ] **里程碑验收**：真机稳定运行 → 提交上架

### 覆盖率（核心业务逻辑）
全局行覆盖率约 47%（大量平台边界 UI/原生无法单测）；纯逻辑文件全部 100%：
luhn / 卡号遮挡 / 颜色 / CardFace / CardSecret / CustomFace / 更新服务 / 仓储 / 扫描解析器 / 控制器 / RevealNotifier。
0% 的文件是 Drift 真库 / Keychain / 相机 / image_picker / SharedPreferences 等平台边界，需真机集成测试。
报告工具：`python app/tools/coverage_report.py`（先 `flutter test --coverage`）

## 后续（v1.1+，可选）

- [ ] 加密导出/导入备份（F-26）
- [ ] 卡片分组/标签
- [ ] 余额变更记录
- [ ] Android 版本发布
