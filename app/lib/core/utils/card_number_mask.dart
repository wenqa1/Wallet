/// 卡号遮挡与格式化工具。
///
/// 卡号属于敏感信息，默认只显示后四位，其余用 • 遮挡。
library;

/// 卡号遮挡：`6225 8820 0000 1234` -> `•••• •••• •••• 1234`。
String maskCardNumber(String number) {
  final digits = number.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return '';

  final keep = digits.length <= 4 ? digits.length : 4;
  final last = digits.substring(digits.length - keep);
  final masked = '•' * (digits.length - keep);
  return _group4('$masked$last');
}

/// 按 4 位分组格式化纯数字卡号：`6225 8820 0000 1234`。
String formatCardNumber(String digits) =>
    _group4(digits.replaceAll(RegExp(r'\D'), ''));

String _group4(String value) {
  final parts = <String>[];
  for (var i = 0; i < value.length; i += 4) {
    final end = i + 4 > value.length ? value.length : i + 4;
    parts.add(value.substring(i, end));
  }
  return parts.join(' ');
}
