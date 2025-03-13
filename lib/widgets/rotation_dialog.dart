import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class RotationDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const RotationDialog({super.key, required this.onClose});

  @override
  ConsumerState<RotationDialog> createState() => _RotationDialogState();
}

class _RotationDialogState extends ConsumerState<RotationDialog> {
  double _rotation = 0.0;
  double _initialRotation = 0.0;

  @override
  void initState() {
    super.initState();
    final selectedIndex = ref.read(selectedTextIndexProvider);
    final texts = ref.read(textInfoControllerProvider);
    if (selectedIndex != null && selectedIndex < texts.length) {
      _rotation = texts[selectedIndex].rotation;
      _initialRotation = _rotation;
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
              'Rotation : ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_rotation.toInt()}°',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Slider(
                value: _rotation,
                min: -180,
                max: 180,
                divisions: 360,
                onChanged: (value) {
                  setState(() {
                    _rotation = value;
                  });
                  final selectedIndex = ref.read(selectedTextIndexProvider);
                  if (selectedIndex != null) {
                    ref
                        .read(textInfoControllerProvider.notifier)
                        .changeRotation(value);
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
                          .changeRotation(_initialRotation);
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
