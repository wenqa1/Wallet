import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/core/utils/card_number_mask.dart';

void main() {
  group('formatCardNumber', () {
    test('groups digits by 4', () {
      expect(formatCardNumber('6225882000001234'), '6225 8820 0000 1234');
    });

    test('strips non-digit separators', () {
      expect(formatCardNumber('6225 8820 0000 1234'), '6225 8820 0000 1234');
    });

    test('handles short numbers', () {
      expect(formatCardNumber('1234'), '1234');
      expect(formatCardNumber('1234567'), '1234 567');
    });
  });

  group('maskCardNumber', () {
    test('shows only last 4 digits', () {
      expect(maskCardNumber('6225882000001234'), '•••• •••• •••• 1234');
    });

    test('keeps whole number when 4 or fewer digits', () {
      expect(maskCardNumber('1234'), '1234');
    });

    test('strips separators before masking', () {
      expect(maskCardNumber('6225 8820 0000 1234'), '•••• •••• •••• 1234');
    });

    test('returns empty for empty input', () {
      expect(maskCardNumber(''), '');
    });
  });
}
