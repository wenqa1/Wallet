import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/features/scan/card_scan_parser.dart';

void main() {
  const parser = CardScanParser();

  group('CardScanParser.parse', () {
    test('从卡号行提取 Luhn 合法的 16 位卡号', () {
      final result = parser.parse(const ['6225 8820 0000 1234']);
      expect(result, isEmpty); // 该号码不符 Luhn，应被过滤
    });

    test('提取 Luhn 合法的卡号', () {
      final result = parser.parse(const ['4111 1111 1111 1111']);
      expect(result.length, 1);
      expect(result.first.cardNumber, '4111111111111111');
    });

    test('忽略不符合 Luhn 的干扰数字', () {
      final result = parser.parse(const ['Some text 1234 and more']);
      expect(result, isEmpty);
    });

    test('行首有干扰数字时仍找到卡号子串', () {
      final result = parser.parse(const ['No. 5500005555555559']);
      expect(result.length, 1);
      expect(result.first.cardNumber, '5500005555555559');
    });

    test('提取卡号上一行的持卡人姓名', () {
      final result = parser.parse(const ['ZHANG SAN', '4111 1111 1111 1111']);
      expect(result.length, 1);
      expect(result.first.holderName, 'ZHANG SAN');
    });

    test('卡号行没有上方姓名时 holderName 为 null', () {
      final result = parser.parse(const ['4111 1111 1111 1111']);
      expect(result.first.holderName, isNull);
    });

    test('提取卡号附近的有效期 MM/YY', () {
      final result = parser.parse(const [
        '4111 1111 1111 1111',
        '08/29',
      ]);
      expect(result.first.expiry, '08/29');
    });

    test('有效期在卡号同一行也能识别', () {
      final result = parser.parse(const ['4111 1111 1111 1111 08/29']);
      expect(result.first.expiry, '08/29');
    });

    test('多张卡号返回多个候选', () {
      final result = parser.parse(const [
        '4111 1111 1111 1111',
        '6011 1111 1111 1117',
      ]);
      expect(result.length, 2);
      expect(result[1].cardNumber, '6011111111111117');
    });

    test('少于 13 位的行不产生候选', () {
      final result = parser.parse(const ['1234']);
      expect(result, isEmpty);
    });
  });
}
