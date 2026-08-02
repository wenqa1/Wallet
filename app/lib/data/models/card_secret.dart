import 'dart:convert';

/// 卡片敏感字段。
///
/// 只存于 Keychain（经 SecretStore），绝不写入 SQLite 或日志。
class CardSecret {
  const CardSecret({
    required this.cardNumber,
    this.holderName,
    this.expiry,
    this.cvv,
  });

  final String cardNumber;
  final String? holderName;
  final String? expiry;
  final String? cvv;

  Map<String, dynamic> toJson() => {
    'cardNumber': cardNumber,
    if (holderName != null) 'holderName': holderName,
    if (expiry != null) 'expiry': expiry,
    if (cvv != null) 'cvv': cvv,
  };

  factory CardSecret.fromJson(Map<String, dynamic> json) => CardSecret(
    cardNumber: json['cardNumber'] as String,
    holderName: json['holderName'] as String?,
    expiry: json['expiry'] as String?,
    cvv: json['cvv'] as String?,
  );

  /// 编码为存储用 JSON 字符串。
  String encode() => jsonEncode(toJson());
}
