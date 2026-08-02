import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../models/card_face.dart';

/// 远端卡面清单。
class RemoteFaceManifest {
  const RemoteFaceManifest({
    required this.manifestVersion,
    this.baseUrl = '',
    this.faces = const [],
  });

  final int manifestVersion;
  final String baseUrl;
  final List<CardFace> faces;

  factory RemoteFaceManifest.fromJson(Map<String, dynamic> json) {
    final faces = (json['faces'] as List<dynamic>?) ?? const [];
    return RemoteFaceManifest(
      manifestVersion: json['manifestVersion'] as int? ?? 0,
      baseUrl: json['baseUrl'] as String? ?? '',
      faces: [
        for (final item in faces)
          CardFace.fromJson(item as Map<String, dynamic>),
      ],
    );
  }
}

/// 卡面资源远端接口，测试可注入 fake。
abstract interface class CardFaceRemoteApi {
  /// 拉取清单；远端未变化（304）返回 null。
  Future<RemoteFaceManifest?> fetchManifest();

  Future<Uint8List> downloadImage(String url);
}

/// Dio 实现，HTTPS + 超时 + 304 缓存。
class DioCardFaceRemoteApi implements CardFaceRemoteApi {
  DioCardFaceRemoteApi({required this.manifestUrl, Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 30),
              validateStatus: (status) => status != null && status < 500,
            ),
          );

  final String manifestUrl;
  final Dio _dio;

  @override
  Future<RemoteFaceManifest?> fetchManifest() async {
    final response = await _dio.get(manifestUrl);
    if (response.statusCode == 304) return null;
    return RemoteFaceManifest.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Uint8List> downloadImage(String url) async {
    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? const []);
  }
}
