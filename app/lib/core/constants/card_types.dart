/// 卡片类型枚举，影响默认卡面与可编辑字段。
enum CardType {
  debit('储蓄卡'),
  credit('信用卡'),
  membership('会员卡'),
  transport('交通卡'),
  other('其他');

  const CardType(this.label);

  final String label;
}
