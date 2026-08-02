import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/constants/card_types.dart';
import '../../core/utils/card_number_mask.dart';
import '../../core/utils/luhn.dart';
import '../../data/local/app_database.dart';
import '../../data/models/card_face.dart';
import '../../data/models/card_secret.dart';
import '../../data/models/custom_face.dart';
import '../../shared/widgets/card_face_widget.dart';
import '../card_face/card_face_picker_sheet.dart';
import '../card_face/custom_face_editor_page.dart';

const _uuid = Uuid();

/// 添加 / 编辑卡片表单。
///
/// [cardId] 为 null 时是新增；否则是编辑，会预填元数据与敏感字段。
class CardFormPage extends ConsumerStatefulWidget {
  const CardFormPage({super.key, this.cardId});

  final String? cardId;

  @override
  ConsumerState<CardFormPage> createState() => _CardFormPageState();
}

class _CardFormPageState extends ConsumerState<CardFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _holderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _balanceController = TextEditingController();

  CardType _type = CardType.debit;
  String? _bankCode;
  String _bankName = '';
  Color _bankColor = const Color(0xFF607D8B);
  String? _cardId;
  bool _isEdit = false;
  String? _faceId;
  CustomFace? _customFace;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.cardId != null;
    if (_isEdit) _loadForEdit();
  }

  Future<void> _loadForEdit() async {
    final repo = ref.read(cardRepositoryProvider);
    final meta = await repo.getCardById(widget.cardId!);
    if (meta == null) return;
    final secret = await repo.readSecret(widget.cardId!);
    setState(() {
      _cardId = meta.id;
      _bankCode = meta.bankCode;
      _bankName = meta.bankName;
      _faceId = meta.faceId;
      _customFace = _parseCustomFace(meta.customFace);
      _nicknameController.text = meta.nickname ?? '';
      if (secret != null) {
        _numberController.text = formatCardNumber(secret.cardNumber);
        _holderController.text = secret.holderName ?? '';
        _expiryController.text = secret.expiry ?? '';
        _cvvController.text = secret.cvv ?? '';
      }
      if (meta.balance != null) {
        _balanceController.text = meta.balance!.toStringAsFixed(2);
      }
      _type = CardType.values.asNameMap()[meta.cardType] ?? CardType.other;
    });
  }

  static CustomFace? _parseCustomFace(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return CustomFace.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _nicknameController.dispose();
    _holderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(cardRepositoryProvider);
    final numberDigits = _numberController.text.replaceAll(RegExp(r'\D'), '');
    final now = DateTime.now();
    final id = _cardId ?? _uuid.v4();
    final balanceText = _balanceController.text.trim();
    final secret = CardSecret(
      cardNumber: numberDigits,
      holderName: _holderController.text.isEmpty
          ? null
          : _holderController.text.trim(),
      expiry: _expiryController.text.isEmpty
          ? null
          : _expiryController.text.trim(),
      cvv: _cvvController.text.isEmpty ? null : _cvvController.text.trim(),
    );
    final companion = CardMetaCompanion.insert(
      id: id,
      bankCode: _bankCode ?? 'OTHER',
      bankName: _bankName.isEmpty ? '其他银行' : _bankName,
      cardType: _type.name,
      faceId: Value<String?>(_faceId),
      customFace: _customFace == null
          ? const Value(null)
          : Value(jsonEncode(_customFace!.toJson())),
      nickname: _nicknameController.text.isEmpty
          ? const Value(null)
          : Value(_nicknameController.text.trim()),
      last4: Value(last4Of(numberDigits)),
      balance: balanceText.isEmpty
          ? const Value(null)
          : Value(double.tryParse(balanceText)),
      currency: const Value('¥'),
      createdAt: now,
      updatedAt: now,
    );

    if (_isEdit) {
      await repo.updateCard(companion, secret: secret);
    } else {
      await repo.insertCard(companion, secret: secret);
    }
    if (mounted) Navigator.of(context).pop();
  }

  CardFace _previewFace(List<CardFace>? faces) {
    if (faces != null && _faceId != null) {
      final hit = faces.firstWhereOrNull((f) => f.faceId == _faceId);
      if (hit != null) return hit;
    }
    return CardFace.gradientFor(
      bankCode: _bankCode ?? 'OTHER',
      bankName: _bankName.isEmpty ? '其他银行' : _bankName,
      color: _bankColor,
    );
  }

  Future<void> _pickFace() async {
    final faces = await ref.read(bundledFacesProvider.future);
    if (!mounted) return;
    final selected = await showCardFacePicker(
      context,
      faces: faces,
      selectedFaceId: _faceId,
    );
    if (selected != null) {
      setState(() {
        _faceId = selected;
        _customFace = null;
      });
    }
  }

  Future<void> _editCustomFace() async {
    final result = await Navigator.push<CustomFace>(
      context,
      MaterialPageRoute(
        builder: (_) => CardCustomFaceEditor(
          initial: _customFace,
          defaultBankName: _bankName,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _customFace = result;
        _faceId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final banksAsync = ref.watch(bankCatalogProvider);
    final facesAsync = ref.watch(bundledFacesProvider);
    final faces = facesAsync.valueOrNull;
    final numberText = _numberController.text;

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? '编辑卡片' : '添加卡片')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_bankCode != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CardFaceWidget(
                  face: _previewFace(faces),
                  customFace: _customFace,
                  nickname: _nicknameController.text.isEmpty
                      ? null
                      : _nicknameController.text,
                  cardNumberMasked: numberText.isEmpty
                      ? null
                      : maskCardNumber(numberText),
                ),
              ),
            banksAsync.when(
              data: (banks) => DropdownButtonFormField<String>(
                key: const Key('bank_dropdown'),
                initialValue: _bankCode,
                decoration: const InputDecoration(labelText: '银行'),
                items: [
                  for (final bank in banks)
                    DropdownMenuItem(
                      value: bank.bankCode,
                      child: Text(bank.bankName),
                    ),
                ],
                onChanged: (code) {
                  if (code == null) return;
                  final bank = banks.firstWhere((b) => b.bankCode == code);
                  setState(() {
                    _bankCode = code;
                    _bankName = bank.bankName;
                    _bankColor = bank.themeColor;
                  });
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('银行列表加载失败：$error'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<CardType>(
              key: const Key('type_dropdown'),
              initialValue: _type,
              decoration: const InputDecoration(labelText: '卡片类型'),
              items: [
                for (final type in CardType.values)
                  DropdownMenuItem(value: type, child: Text(type.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _type = value);
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('pick_face_button'),
                    icon: const Icon(Icons.credit_card_outlined),
                    label: const Text('选择卡面'),
                    onPressed: _pickFace,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('custom_face_button'),
                    icon: const Icon(Icons.palette_outlined),
                    label: const Text('自定义'),
                    onPressed: _editCustomFace,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('nickname'),
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: '昵称（可选）'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('card_number'),
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '卡号',
                hintText: '6225 8820 0000 1234',
              ),
              validator: (value) {
                final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                if (digits.isEmpty) return '请输入卡号';
                if (!isLuhnValid(digits)) return '卡号校验失败，请检查';
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('holder_name'),
              controller: _holderController,
              decoration: const InputDecoration(labelText: '持卡人（可选）'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: const Key('expiry'),
                    controller: _expiryController,
                    decoration: const InputDecoration(
                      labelText: '有效期（可选）',
                      hintText: 'MM/YY',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: const Key('cvv'),
                    controller: _cvvController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'CVV（可选）'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('balance'),
              controller: _balanceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: '余额（可选）',
                prefixText: '¥ ',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('save_button'),
              onPressed: _save,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
