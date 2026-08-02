/// 银行卡号 Luhn 校验。
///
/// 银行卡号通常为 13~19 位数字，通过 Luhn（模 10）算法校验。
/// 用于 OCR 识别结果的过滤与手动录入的即时校验。
bool isLuhnValid(String input) {
  final digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 13 || digits.length > 19) return false;

  var sum = 0;
  var doubleDigit = false;
  for (var i = digits.length - 1; i >= 0; i--) {
    var value = digits.codeUnitAt(i) - 0x30;
    if (doubleDigit) {
      value *= 2;
      if (value > 9) value -= 9;
    }
    sum += value;
    doubleDigit = !doubleDigit;
  }
  return sum % 10 == 0;
}
