import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class FontSizeDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const FontSizeDialog({super.key, required this.onClose});

  @override
  ConsumerState<FontSizeDialog> createState() => _FontSizeDialogState();
}

class _FontSizeDialogState extends ConsumerState<FontSizeDialog> {
  double _fontSize = 20.0; // Default font size
  double _initialFontSize = 20.0; // Store initial value

  @override
  void initState() {
    super.initState();
    // Get the current font size from selected text if available
    final selectedIndex = ref.read(selectedTextIndexProvider);
    final texts = ref.read(textInfoControllerProvider);
    if (selectedIndex != null && selectedIndex < texts.length) {
      _fontSize = texts[selectedIndex].fontSize;
      _initialFontSize = _fontSize;
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
            // Text label with smaller font size
            const Text(
              'Size : ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Current size value
            Text(
              '${_fontSize.toInt()} px',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Slider takes remaining space
            Expanded(
              child: Slider(
                value: _fontSize,
                min: 2,
                max: 400,
                divisions: 398,
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                  // Apply font size change in real-time
                  final selectedIndex = ref.read(selectedTextIndexProvider);
                  if (selectedIndex != null) {
                    ref
                        .read(textInfoControllerProvider.notifier)
                        .changeFont(value);
                  }
                },
              ),
            ),

            // Buttons in column at the end
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green, size: 20),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints.tightFor(width: 24, height: 24),
                  onPressed: () {
                    // Changes already applied in real-time, just close
                    widget.onClose();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red, size: 20),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints.tightFor(width: 24, height: 24),
                  onPressed: () {
                    // Revert to initial value
                    final selectedIndex = ref.read(selectedTextIndexProvider);
                    if (selectedIndex != null) {
                      ref
                          .read(textInfoControllerProvider.notifier)
                          .changeFont(_initialFontSize);
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
