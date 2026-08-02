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

- [ ] 首页卡片轮播（PageView + 错落缩放）
- [ ] 3D 翻转详情页 + 敏感遮挡（`••••` 样式）
- [ ] 长按临时显示 + 自动隐藏 + 后台清屏（AppLifecycleListener）
- [ ] 余额录入/更新 + 卡片上展示
- [ ] `card_face_api.dart` + `card_face_downloader.dart`：manifest 拉取、ETag、增量下载、失败回退
- [ ] 设置页：遮挡时长、手动检查更新
- [ ] **里程碑验收**：轮播流畅（真机 60fps）；切后台回来卡号保持遮挡；远程卡面能更新

## M5 · 卡面资源站（0.5 周）

- [ ] 搭建静态资源站（GitHub Pages / Cloudflare Pages）
- [ ] 生成 manifest.json + 首批卡面图片（通用化配色 + 银行名文字）
- [ ] CI 发布脚本（推 manifest 即更新）
- [ ] **里程碑验收**：修改资源站 → App 手动检查更新拉取成功

## M6 · 测试打磨 + 上架（1 周）

- [ ] 单元测试补齐：Luhn、卡号解析/遮挡、manifest 合并、余额格式化（覆盖 ≥80%）
- [ ] Widget 测试：卡片渲染、轮播、遮挡交互
- [ ] 集成测试：增删改查全流程
- [ ] 隐私标签（App Privacy）填写 + 应用内隐私说明页
- [ ] 图标、启动图、App 名称、版本号
- [ ] TestFlight 内测（真机回归：OCR、动画、后台遮挡、深色模式）
- [ ] App Store 提交 + 审核材料（截图、描述、隐私政策 URL）
- [ ] **里程碑验收**：TestFlight 稳定运行 1 周无崩溃 → 提交上架

## 后续（v1.1+，可选）

- [ ] 加密导出/导入备份（F-26）
- [ ] 卡片分组/标签
- [ ] 余额变更记录
- [ ] Android 版本发布
