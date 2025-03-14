import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class RelativePositionDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const RelativePositionDialog({super.key, required this.onClose});

  @override
  ConsumerState<RelativePositionDialog> createState() =>
      _RelativePositionDialogState();
}

class _RelativePositionDialogState
    extends ConsumerState<RelativePositionDialog> {
  String _horizontalAlignment = 'left';
  String _verticalAlignment = 'top';
  String _initialHorizontalAlignment = 'left';
  String _initialVerticalAlignment = 'top';

  @override
  void initState() {
    super.initState();
    // Get the current alignment from selected text if available
    final selectedIndex = ref.read(selectedTextIndexProvider);
    final texts = ref.read(textInfoControllerProvider);
    if (selectedIndex != null && selectedIndex < texts.length) {
      final alignment = texts[selectedIndex].alignment;

      // Extract horizontal and vertical alignment from the combined alignment string
      if (alignment.contains('top')) {
        _verticalAlignment = 'top';
      } else if (alignment.contains('bottom')) {
        _verticalAlignment = 'bottom';
      } else {
        _verticalAlignment = 'center';
      }

      if (alignment.contains('Left')) {
        _horizontalAlignment = 'left';
      } else if (alignment.contains('Right')) {
        _horizontalAlignment = 'right';
      } else {
        _horizontalAlignment = 'center';
      }

      _initialHorizontalAlignment = _horizontalAlignment;
      _initialVerticalAlignment = _verticalAlignment;
    }
  }

  String _getCombinedAlignment() {
    if (_verticalAlignment == 'top') {
      if (_horizontalAlignment == 'left') return 'topLeft';
      if (_horizontalAlignment == 'right') return 'topRight';
      return 'topCenter';
    } else if (_verticalAlignment == 'bottom') {
      if (_horizontalAlignment == 'left') return 'bottomLeft';
      if (_horizontalAlignment == 'right') return 'bottomRight';
      return 'bottomCenter';
    } else {
      if (_horizontalAlignment == 'left') return 'centerLeft';
      if (_horizontalAlignment == 'right') return 'centerRight';
      return 'center';
    }
  }

  void _applyAlignment() {
    final selectedIndex = ref.read(selectedTextIndexProvider);
    if (selectedIndex != null) {
      ref
          .read(textInfoControllerProvider.notifier)
          .changeRelativeAlignment(_getCombinedAlignment());
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
              children: [
                const Expanded(
                  child: Text(
                    'Relative Position',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check,
                          color: Colors.green, size: 20),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints.tightFor(width: 24, height: 24),
                      onPressed: () {
                        _applyAlignment();
                        widget.onClose();
                      },
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.close, color: Colors.red, size: 20),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints.tightFor(width: 24, height: 24),
                      onPressed: () {
                        // Revert to initial value
                        setState(() {
                          _horizontalAlignment = _initialHorizontalAlignment;
                          _verticalAlignment = _initialVerticalAlignment;
                        });
                        _applyAlignment();
                        widget.onClose();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Horizontal: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAlignmentButton(
                        'Left',
                        Icons.format_align_left,
                        _horizontalAlignment == 'left',
                        () => setState(() {
                          _horizontalAlignment = 'left';
                          _applyAlignment();
                        }),
                      ),
                      _buildAlignmentButton(
                        'Center',
                        Icons.format_align_center,
                        _horizontalAlignment == 'center',
                        () => setState(() {
                          _horizontalAlignment = 'center';
                          _applyAlignment();
                        }),
                      ),
                      _buildAlignmentButton(
                        'Right',
                        Icons.format_align_right,
                        _horizontalAlignment == 'right',
                        () => setState(() {
                          _horizontalAlignment = 'right';
                          _applyAlignment();
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Vertical:     ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAlignmentButton(
                        'Top',
                        Icons.vertical_align_top,
                        _verticalAlignment == 'top',
                        () => setState(() {
                          _verticalAlignment = 'top';
                          _applyAlignment();
                        }),
                      ),
                      _buildAlignmentButton(
                        'Center',
                        Icons.vertical_align_center,
                        _verticalAlignment == 'center',
                        () => setState(() {
                          _verticalAlignment = 'center';
                          _applyAlignment();
                        }),
                      ),
                      _buildAlignmentButton(
                        'Bottom',
                        Icons.vertical_align_bottom,
                        _verticalAlignment == 'bottom',
                        () => setState(() {
                          _verticalAlignment = 'bottom';
                          _applyAlignment();
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlignmentButton(
      String label, IconData icon, bool isSelected, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.blue : Colors.grey),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
