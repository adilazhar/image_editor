import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class OpacityDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const OpacityDialog({super.key, required this.onClose});

  @override
  ConsumerState<OpacityDialog> createState() => _OpacityDialogState();
}

class _OpacityDialogState extends ConsumerState<OpacityDialog> {
  double _opacity = 100.0; // Default opacity (100%)
  double _initialOpacity = 100.0; // Store initial value

  @override
  void initState() {
    super.initState();
    // Get the current opacity from selected text if available
    final selectedIndex = ref.read(selectedTextIndexProvider);
    final texts = ref.read(textInfoControllerProvider);
    if (selectedIndex != null && selectedIndex < texts.length) {
      _opacity = texts[selectedIndex].opacity * 100;
      _initialOpacity = _opacity;
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
              'Opacity : ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_opacity.toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Slider(
                value: _opacity,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    _opacity = value;
                  });
                  // Apply opacity change in real-time
                  final selectedIndex = ref.read(selectedTextIndexProvider);
                  if (selectedIndex != null) {
                    ref
                        .read(textInfoControllerProvider.notifier)
                        .changeOpacity(value);
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
                          .changeOpacity(_initialOpacity);
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
