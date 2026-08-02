# WEDO · 工作汇总

> 每次完成一个任务后，把结果汇总到这里。格式：`日期 · 任务` → 做了什么 / 验证结果 / 下一步。

---

## 2026-08-03 · M0 项目骨架初始化

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

## 2026-08-03 · M1 卡片增删改查

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
