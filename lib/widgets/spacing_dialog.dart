import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';
import 'package:image_editor/screens/edit_screen.dart';

class SpacingDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const SpacingDialog({super.key, required this.onClose});

  @override
  ConsumerState<SpacingDialog> createState() => _SpacingDialogState();
}

class _SpacingDialogState extends ConsumerState<SpacingDialog> {
  String _activeSpacingType = 'letter'; // 'letter' or 'word'
  double _letterSpacing = 0.0;
  double _wordSpacing = 0.0;
  double _initialLetterSpacing = 0.0;
  double _initialWordSpacing = 0.0;

  @override
  void initState() {
    super.initState();
    final selectedIndex = ref.read(selectedTextIndexProvider);
    final texts = ref.read(textInfoControllerProvider);
    if (selectedIndex != null && selectedIndex < texts.length) {
      _letterSpacing = texts[selectedIndex].letterSpacing;
      _wordSpacing = texts[selectedIndex].wordSpacing;
      _initialLetterSpacing = _letterSpacing;
      _initialWordSpacing = _wordSpacing;
    }
  }

  double get _currentSpacing =>
      _activeSpacingType == 'letter' ? _letterSpacing : _wordSpacing;

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
                  'Spacing',
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
                              .changeSpacing(
                                letterSpacing: _initialLetterSpacing,
                                wordSpacing: _initialWordSpacing,
                              );
                        }
                        widget.onClose();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'letter',
                  icon: Icon(Icons.text_fields),
                  label: Text('Letter'),
                ),
                ButtonSegment<String>(
                  value: 'word',
                  icon: Icon(Icons.space_bar),
                  label: Text('Word'),
                ),
              ],
              selected: {_activeSpacingType},
              onSelectionChanged: (Set<String> selected) {
                if (selected.isNotEmpty) {
                  setState(() {
                    _activeSpacingType = selected.first;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${_activeSpacingType.capitalize()} Spacing: ',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _currentSpacing.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _currentSpacing,
                    min: -30,
                    max: 100,
                    divisions: 130,
                    onChanged: (value) {
                      final selectedIndex = ref.read(selectedTextIndexProvider);
                      if (selectedIndex != null) {
                        if (_activeSpacingType == 'letter') {
                          setState(() {
                            _letterSpacing = value;
                          });
                          ref
                              .read(textInfoControllerProvider.notifier)
                              .changeSpacing(
                                letterSpacing: value,
                              );
                        } else {
                          setState(() {
                            _wordSpacing = value;
                          });
                          ref
                              .read(textInfoControllerProvider.notifier)
                              .changeSpacing(
                                wordSpacing: value,
                              );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
