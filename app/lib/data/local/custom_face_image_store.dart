import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// 把相册选中的卡面背景图复制进应用支持目录，
/// 避免 image_picker 临时文件被系统清理导致路径失效。
class CustomFaceImageStore {
  const CustomFaceImageStore();

  Future<String> importPicked(XFile picked) async {
    final dir = await getApplicationSupportDirectory();
    final facesDir = Directory('${dir.path}/custom_faces');
    await facesDir.create(recursive: true);
    final name = '${DateTime.now().microsecondsSinceEpoch}.jpg';
    final dest = '${facesDir.path}/$name';
    await picked.saveTo(dest);
    return dest;
  }
}
