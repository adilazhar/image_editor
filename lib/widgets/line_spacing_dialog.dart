import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class LineSpacingDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const LineSpacingDialog({super.key, required this.onClose});

  @override
  ConsumerState<LineSpacingDialog> createState() => _LineSpacingDialogState();
}

class _LineSpacingDialogState extends ConsumerState<LineSpacingDialog> {
  double _lineSpacing = 0.0;
  double _initialLineSpacing = 0.0;

  @override
  void initState() {
    super.initState();
    final selectedIndex = ref.read(selectedTextIndexProvider);
    final texts = ref.read(textInfoControllerProvider);
    if (selectedIndex != null && selectedIndex < texts.length) {
      _lineSpacing = texts[selectedIndex].lineSpacing;
      _initialLineSpacing = _lineSpacing;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            const Text(
              'Line Spacing : ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _lineSpacing.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Slider(
                value: _lineSpacing,
                min: -100,
                max: 100,
                divisions: 200,
                onChanged: (value) {
                  setState(() {
                    _lineSpacing = value;
                  });
                  final selectedIndex = ref.read(selectedTextIndexProvider);
                  if (selectedIndex != null) {
                    ref.read(textInfoControllerProvider.notifier).changeSpacing(
                          lineSpacing: value,
                        );
                  }
                },
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green, size: 20),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints.tightFor(width: 24, height: 24),
                  onPressed: widget.onClose,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red, size: 20),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints.tightFor(width: 24, height: 24),
                  onPressed: () {
                    final selectedIndex = ref.read(selectedTextIndexProvider);
                    if (selectedIndex != null) {
                      ref
                          .read(textInfoControllerProvider.notifier)
                          .changeSpacing(
                            lineSpacing: _initialLineSpacing,
                          );
                    }
                    widget.onClose();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
