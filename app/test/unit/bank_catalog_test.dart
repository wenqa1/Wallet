import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/core/constants/bank_catalog.dart';

void main() {
  test('Bank.fromJson 解析主题色', () {
    final bank = Bank.fromJson(const {
      'bankCode': 'CMB',
      'bankName': '招商银行',
      'themeColor': '#C8102E',
    });
    expect(bank.bankCode, 'CMB');
    expect(bank.bankName, '招商银行');
    expect(bank.themeColor, const Color(0xFFC8102E));
  });

  test('缺 themeColor 用兜底色', () {
    final bank = Bank.fromJson(const {'bankCode': 'X', 'bankName': 'X'});
    expect(bank.themeColor, const Color(0xFF607D8B));
  });
}
