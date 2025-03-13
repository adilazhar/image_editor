import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class AlignmentDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const AlignmentDialog({super.key, required this.onClose});

  @override
  ConsumerState<AlignmentDialog> createState() => _AlignmentDialogState();
}

class _AlignmentDialogState extends ConsumerState<AlignmentDialog> {
  TextAlign _textAlign = TextAlign.left;
  bool _justified = false;
  TextAlign _initialTextAlign = TextAlign.left;
  bool _initialJustified = false;

  @override
  void initState() {
    super.initState();
    final selectedIndex = ref.read(selectedTextIndexProvider);
    final texts = ref.read(textInfoControllerProvider);
    if (selectedIndex != null && selectedIndex < texts.length) {
      _textAlign = texts[selectedIndex].textAlign;
      _justified = texts[selectedIndex].justified;
      _initialTextAlign = _textAlign;
      _initialJustified = _justified;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Text Alignment',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check,
                          color: Colors.green, size: 20),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints.tightFor(width: 24, height: 24),
                      onPressed: widget.onClose,
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.close, color: Colors.red, size: 20),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints.tightFor(width: 24, height: 24),
                      onPressed: () {
                        final selectedIndex =
                            ref.read(selectedTextIndexProvider);
                        if (selectedIndex != null) {
                          ref
                              .read(textInfoControllerProvider.notifier)
                              .changeTextAlignment(_initialTextAlign);
                          ref
                              .read(textInfoControllerProvider.notifier)
                              .toggleJustified(_initialJustified);
                        }
                        widget.onClose();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            SegmentedButton<TextAlign>(
              segments: const [
                ButtonSegment<TextAlign>(
                  value: TextAlign.left,
                  icon: Icon(Icons.format_align_left),
                  label: Text('Left'),
                ),
                ButtonSegment<TextAlign>(
                  value: TextAlign.center,
                  icon: Icon(Icons.format_align_center),
                  label: Text('Center'),
                ),
                ButtonSegment<TextAlign>(
                  value: TextAlign.right,
                  icon: Icon(Icons.format_align_right),
                  label: Text('Right'),
                ),
              ],
              selected: {_textAlign},
              onSelectionChanged: (Set<TextAlign> selected) {
                if (selected.isNotEmpty) {
                  setState(() {
                    _textAlign = selected.first;
                  });
                  final selectedIndex = ref.read(selectedTextIndexProvider);
                  if (selectedIndex != null) {
                    ref
                        .read(textInfoControllerProvider.notifier)
                        .changeTextAlignment(selected.first);
                  }
                }
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Justified:',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _justified,
                  onChanged: (value) {
                    setState(() {
                      _justified = value;
                    });
                    final selectedIndex = ref.read(selectedTextIndexProvider);
                    if (selectedIndex != null) {
                      ref
                          .read(textInfoControllerProvider.notifier)
                          .toggleJustified(value);
                    }
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
