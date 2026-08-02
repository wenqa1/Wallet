import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/local/custom_face_image_store.dart';
import '../../data/models/card_face.dart';
import '../../data/models/custom_face.dart';
import '../../shared/widgets/card_face_widget.dart';

/// 自定义卡面编辑器：渐变配色 + 前景文字 + Logo/银行名 + 相册背景图，实时预览。
///
/// 保存时通过 `Navigator.pop(context, CustomFace)` 返回结果。
class CardCustomFaceEditor extends StatefulWidget {
  const CardCustomFaceEditor({super.key, this.initial, this.defaultBankName});

  final CustomFace? initial;
  final String? defaultBankName;

  @override
  State<CardCustomFaceEditor> createState() => _CardCustomFaceEditorState();
}

class _CardCustomFaceEditorState extends State<CardCustomFaceEditor> {
  static const _presets = <List<Color>>[
    [Color(0xFFC8102E), Color(0xFF8C0B20)],
    [Color(0xFF003C71), Color(0xFF00244A)],
    [Color(0xFF0066B3), Color(0xFF00447B)],
    [Color(0xFF0E4D92), Color(0xFF0A376B)],
    [Color(0xFFE64A19), Color(0xFFB0320F)],
    [Color(0xFF1E88E5), Color(0xFF1565C0)],
    [Color(0xFF2E7D32), Color(0xFF1B5E20)],
    [Color(0xFF5D4037), Color(0xFF3E2723)],
  ];

  late List<Color> _colors;
  bool _darkText = false;
  final _logoController = TextEditingController();
  final _bankNameController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _colors = (initial != null && initial.colors.isNotEmpty)
        ? List.of(initial.colors)
        : List.of(_presets.first);
    _darkText = initial?.foreground == Colors.black;
    _logoController.text = initial?.logoText ?? '';
    _bankNameController.text = initial?.bankNameText ?? '';
    _imagePath = initial?.imagePath;
  }

  @override
  void dispose() {
    _logoController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  CustomFace _current() {
    return CustomFace(
      colors: _colors,
      foreground: _darkText ? Colors.black : Colors.white,
      logoText: _logoController.text.isEmpty ? null : _logoController.text,
      bankNameText: _bankNameController.text.isEmpty
          ? null
          : _bankNameController.text,
      imagePath: _imagePath,
    );
  }

  Future<void> _pickBackgroundImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
    );
    if (picked == null) return;
    final path = await const CustomFaceImageStore().importPicked(picked);
    if (!mounted) return;
    setState(() => _imagePath = path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('自定义卡面')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 实时预览。
          CardFaceWidget(
            face: CardFace.gradientFor(
              bankCode: 'CUSTOM',
              bankName: _bankNameController.text.isEmpty
                  ? (widget.defaultBankName ?? '')
                  : _bankNameController.text,
              color: _colors.first,
            ),
            customFace: _current(),
            cardNumberMasked: '•••• •••• •••• 1234',
          ),
          const SizedBox(height: 20),
          Text('渐变配色', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final preset in _presets)
                GestureDetector(
                  key: Key('custom_preset_${preset.first.toARGB32()}'),
                  onTap: () => setState(() => _colors = List.of(preset)),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: preset,
                      ),
                      border: Border.all(
                        color: _colors.first == preset.first
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('前景文字', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('白色')),
              ButtonSegment(value: true, label: Text('黑色')),
            ],
            selected: {_darkText},
            onSelectionChanged: (selection) =>
                setState(() => _darkText = selection.first),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('custom_logo_text'),
            controller: _logoController,
            decoration: const InputDecoration(labelText: 'Logo 文字'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('custom_bank_name_text'),
            controller: _bankNameController,
            decoration: const InputDecoration(labelText: '银行名'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            key: const Key('custom_image_button'),
            icon: const Icon(Icons.photo_outlined),
            label: Text(_imagePath == null ? '相册背景图' : '更换背景图'),
            onPressed: _pickBackgroundImage,
          ),
          if (_imagePath != null)
            TextButton(
              onPressed: () => setState(() => _imagePath = null),
              child: const Text('移除背景图'),
            ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('custom_save_button'),
            onPressed: () => Navigator.pop(context, _current()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
