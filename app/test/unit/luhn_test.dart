import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/core/utils/luhn.dart';

void main() {
  group('isLuhnValid', () {
    test('accepts standard test card numbers', () {
      expect(isLuhnValid('4111111111111111'), isTrue); // Visa
      expect(isLuhnValid('5500005555555559'), isTrue); // Mastercard
      expect(isLuhnValid('6011111111111117'), isTrue); // Discover
      expect(isLuhnValid('5555555555554444'), isTrue); // Mastercard
    });

    test('rejects invalid check digit', () {
      expect(isLuhnValid('4111111111111112'), isFalse);
      expect(isLuhnValid('5500005555555550'), isFalse);
    });

    test('rejects too short or too long numbers', () {
      expect(isLuhnValid('1234'), isFalse);
      expect(isLuhnValid('123456789012345678901234567890'), isFalse);
    });

    test('tolerates spaces and dashes', () {
      expect(isLuhnValid('4111 1111 1111 1111'), isTrue);
      expect(isLuhnValid('4111-1111-1111-1111'), isTrue);
    });

    test('returns false for empty or non-numeric input', () {
      expect(isLuhnValid(''), isFalse);
      expect(isLuhnValid('abcdefghijklmno'), isFalse);
    });
  });
}
