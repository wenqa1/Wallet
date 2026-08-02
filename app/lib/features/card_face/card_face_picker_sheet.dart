import 'package:flutter/material.dart';

import '../../data/models/card_face.dart';
import '../../shared/widgets/card_face_widget.dart';

/// 打开卡面选择器（底部弹层），返回选中的 faceId；取消返回 null。
Future<String?> showCardFacePicker(
  BuildContext context, {
  required List<CardFace> faces,
  String? selectedFaceId,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        _CardFacePickerSheet(faces: faces, selectedFaceId: selectedFaceId),
  );
}

class _CardFacePickerSheet extends StatelessWidget {
  const _CardFacePickerSheet({required this.faces, this.selectedFaceId});

  final List<CardFace> faces;
  final String? selectedFaceId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('选择卡面', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisExtent: 180,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: faces.length,
                itemBuilder: (context, index) {
                  final face = faces[index];
                  final selected = face.faceId == selectedFaceId;
                  return InkWell(
                    key: Key('picker_face_${face.faceId}'),
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.pop(context, face.faceId),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CardFaceWidget(face: face),
                        if (selected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
