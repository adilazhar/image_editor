import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class BackgroundDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const BackgroundDialog({super.key, required this.onClose});

  @override
  ConsumerState<BackgroundDialog> createState() => _BackgroundDialogState();
}

class _BackgroundDialogState extends ConsumerState<BackgroundDialog> {
  bool _hasBackground = false;
  Color _backgroundColor = Colors.white;
  double _leftPadding = 0.0;
  double _topPadding = 0.0;
  double _rightPadding = 0.0;
  double _bottomPadding = 0.0;
  double _borderRadius = 0.0;

  // Store initial values
  bool _initialHasBackground = false;
  Color _initialBackgroundColor = Colors.white;
  double _initialLeftPadding = 0.0;
  double _initialTopPadding = 0.0;
  double _initialRightPadding = 0.0;
  double _initialBottomPadding = 0.0;
  double _initialBorderRadius = 0.0;

  @override
  void initState() {
    super.initState();
    // Get the current background properties from selected text if available
    final selectedIndex = ref.read(selectedTextIndexProvider);
    final texts = ref.read(textInfoControllerProvider);
    if (selectedIndex != null && selectedIndex < texts.length) {
      final textInfo = texts[selectedIndex];
      _hasBackground = textInfo.hasBackground;
      _backgroundColor = textInfo.backgroundColor;
      _leftPadding = textInfo.backgroundPadding.left;
      _topPadding = textInfo.backgroundPadding.top;
      _rightPadding = textInfo.backgroundPadding.right;
      _bottomPadding = textInfo.backgroundPadding.bottom;
      _borderRadius = textInfo.backgroundBorderRadius;

      // Store initial values
      _initialHasBackground = _hasBackground;
      _initialBackgroundColor = _backgroundColor;
      _initialLeftPadding = _leftPadding;
      _initialTopPadding = _topPadding;
      _initialRightPadding = _rightPadding;
      _initialBottomPadding = _bottomPadding;
      _initialBorderRadius = _borderRadius;
    }
  }

  void _applyBackgroundChanges() {
    final selectedIndex = ref.read(selectedTextIndexProvider);
    if (selectedIndex != null) {
      // Toggle background
      ref
          .read(textInfoControllerProvider.notifier)
          .toggleBackground(_hasBackground);

      // Apply background properties if background is enabled
      if (_hasBackground) {
        ref
            .read(textInfoControllerProvider.notifier)
            .changeBackgroundProperties(
              backgroundColor: _backgroundColor,
              backgroundPadding: EdgeInsets.fromLTRB(
                _leftPadding,
                _topPadding,
                _rightPadding,
                _bottomPadding,
              ),
              backgroundBorderRadius: _borderRadius,
            );
      }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Background',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _hasBackground,
                  onChanged: (value) {
                    setState(() {
                      _hasBackground = value;
                    });
                    _applyBackgroundChanges();
                  },
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
                        _applyBackgroundChanges();
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
                        // Revert to initial values
                        setState(() {
                          _hasBackground = _initialHasBackground;
                          _backgroundColor = _initialBackgroundColor;
                          _leftPadding = _initialLeftPadding;
                          _topPadding = _initialTopPadding;
                          _rightPadding = _initialRightPadding;
                          _bottomPadding = _initialBottomPadding;
                          _borderRadius = _initialBorderRadius;
                        });
                        _applyBackgroundChanges();
                        widget.onClose();
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (_hasBackground) ...[
              const SizedBox(height: 8),
              const Text(
                'Background Color:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ColorPicker(
                  pickerColor: _backgroundColor,
                  onColorChanged: (color) {
                    setState(() {
                      _backgroundColor = color;
                    });
                    _applyBackgroundChanges();
                  },
                  paletteType: PaletteType.hsl,
                  pickerAreaHeightPercent: 0.8,
                  displayThumbColor: true,
                  enableAlpha: true,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Padding:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              _buildPaddingSlider('Left', _leftPadding, (value) {
                setState(() {
                  _leftPadding = value;
                });
                _applyBackgroundChanges();
              }),
              _buildPaddingSlider('Top', _topPadding, (value) {
                setState(() {
                  _topPadding = value;
                });
                _applyBackgroundChanges();
              }),
              _buildPaddingSlider('Right', _rightPadding, (value) {
                setState(() {
                  _rightPadding = value;
                });
                _applyBackgroundChanges();
              }),
              _buildPaddingSlider('Bottom', _bottomPadding, (value) {
                setState(() {
                  _bottomPadding = value;
                });
                _applyBackgroundChanges();
              }),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Border Radius: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${_borderRadius.toInt()} px',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _borderRadius,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          _borderRadius = value;
                        });
                        _applyBackgroundChanges();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaddingSlider(
      String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            '$label: ${value.toInt()} px',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: -300,
            max: 300,
            divisions: 600,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
