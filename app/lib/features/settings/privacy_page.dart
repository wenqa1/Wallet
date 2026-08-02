import 'package:flutter/material.dart';

/// 应用内隐私说明。
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('隐私说明')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _Section(
            title: '数据存储',
            body:
                '所有卡片数据（卡号、持卡人、有效期、CVV、余额）仅保存在本机。'
                '卡号等敏感字段存于 iOS 钥匙串（Keychain），元数据存于本机 SQLite，'
                '均不联网上传，开发者也无法读取。',
          ),
          _Section(
            title: '权限',
            body:
                '相机：用于扫描银行卡号自动录入。相册：用于自定义卡面背景图。'
                '仅在相应功能使用时申请并征得同意。',
          ),
          _Section(
            title: '联网',
            body:
                '仅在「检查卡面更新」时拉取卡面清单与图片资源。'
                '本应用不上传任何用户数据。',
          ),
          _Section(title: '卡面资源', body: '卡面资源仅用于个人本地展示，不包含可用于仿冒卡片的伪造元素。'),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
