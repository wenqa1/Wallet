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
