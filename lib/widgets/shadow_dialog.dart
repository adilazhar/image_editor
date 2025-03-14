import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class ShadowDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const ShadowDialog({super.key, required this.onClose});

  @override
  ConsumerState<ShadowDialog> createState() => _ShadowDialogState();
}

class _ShadowDialogState extends ConsumerState<ShadowDialog> {
  bool _hasShadow = false;
  Color _shadowColor = Colors.black;
  double _shadowOpacity = 50.0;
  double _shadowBlurRadius = 10.0;
  double _xOffset = 0.0;
  double _yOffset = 0.0;

  // Initial values for reverting
  bool _initialHasShadow = false;
  Color _initialShadowColor = Colors.black;
  double _initialShadowOpacity = 50.0;
  double _initialShadowBlurRadius = 10.0;
  double _initialXOffset = 0.0;
  double _initialYOffset = 0.0;

  @override
  void initState() {
    super.initState();
    final selectedIndex = ref.read(selectedTextIndexProvider);
    final texts = ref.read(textInfoControllerProvider);
    if (selectedIndex != null && selectedIndex < texts.length) {
      final textInfo = texts[selectedIndex];
      _hasShadow = textInfo.hasShadow;
      _shadowColor = textInfo.shadowColor;
      _shadowOpacity = textInfo.shadowOpacity * 100;
      _shadowBlurRadius = textInfo.shadowBlurRadius;
      _xOffset = textInfo.shadowOffset.dx;
      _yOffset = textInfo.shadowOffset.dy;

      // Store initial values
      _initialHasShadow = _hasShadow;
      _initialShadowColor = _shadowColor;
      _initialShadowOpacity = _shadowOpacity;
      _initialShadowBlurRadius = _shadowBlurRadius;
      _initialXOffset = _xOffset;
      _initialYOffset = _yOffset;
    }
  }

  void _applyShadowChanges() {
    final selectedIndex = ref.read(selectedTextIndexProvider);
    if (selectedIndex != null) {
      ref.read(textInfoControllerProvider.notifier).toggleShadow(_hasShadow);
      if (_hasShadow) {
        ref.read(textInfoControllerProvider.notifier).changeShadowProperties(
              shadowColor: _shadowColor,
              shadowOpacity: _shadowOpacity,
              shadowBlurRadius: _shadowBlurRadius,
              shadowOffset: Offset(_xOffset, _yOffset),
            );
      }
    }
  }

  void _revertChanges() {
    final selectedIndex = ref.read(selectedTextIndexProvider);
    if (selectedIndex != null) {
      ref
          .read(textInfoControllerProvider.notifier)
          .toggleShadow(_initialHasShadow);
      if (_initialHasShadow) {
        ref.read(textInfoControllerProvider.notifier).changeShadowProperties(
              shadowColor: _initialShadowColor,
              shadowOpacity: _initialShadowOpacity,
              shadowBlurRadius: _initialShadowBlurRadius,
              shadowOffset: Offset(_initialXOffset, _initialYOffset),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Shadow',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Switch(
                      value: _hasShadow,
                      onChanged: (value) {
                        setState(() {
                          _hasShadow = value;
                        });
                        ref
                            .read(textInfoControllerProvider.notifier)
                            .toggleShadow(value);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check,
                          color: Colors.green, size: 20),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints.tightFor(width: 24, height: 24),
                      onPressed: () {
                        _applyShadowChanges();
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
                        _revertChanges();
                        widget.onClose();
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (_hasShadow) ...[
              const SizedBox(height: 16),
              // Shadow Color
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a shadow color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: _shadowColor,
                            onColorChanged: (Color color) {
                              setState(() {
                                _shadowColor = color;
                              });
                              ref
                                  .read(textInfoControllerProvider.notifier)
                                  .changeShadowProperties(
                                    shadowColor: color,
                                  );
                            },
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Done'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    const Text(
                      'Color:',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _shadowColor,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Shadow Opacity
              Row(
                children: [
                  const Text(
                    'Opacity:',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_shadowOpacity.toInt()}%',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Expanded(
                    child: Slider(
                      value: _shadowOpacity,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          _shadowOpacity = value;
                        });
                        ref
                            .read(textInfoControllerProvider.notifier)
                            .changeShadowProperties(
                              shadowOpacity: value,
                            );
                      },
                    ),
                  ),
                ],
              ),

              // Shadow Blur Radius
              Row(
                children: [
                  const Text(
                    'Blur:',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _shadowBlurRadius.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Expanded(
                    child: Slider(
                      value: _shadowBlurRadius,
                      min: 0,
                      max: 50,
                      divisions: 50,
                      onChanged: (value) {
                        setState(() {
                          _shadowBlurRadius = value;
                        });
                        ref
                            .read(textInfoControllerProvider.notifier)
                            .changeShadowProperties(
                              shadowBlurRadius: value,
                            );
                      },
                    ),
                  ),
                ],
              ),

              // X Offset
              Row(
                children: [
                  const Text(
                    'X Offset:',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _xOffset.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Expanded(
                    child: Slider(
                      value: _xOffset,
                      min: -140,
                      max: 140,
                      divisions: 280,
                      onChanged: (value) {
                        setState(() {
                          _xOffset = value;
                        });
                        ref
                            .read(textInfoControllerProvider.notifier)
                            .changeShadowProperties(
                              shadowOffset: Offset(value, _yOffset),
                            );
                      },
                    ),
                  ),
                ],
              ),

              // Y Offset
              Row(
                children: [
                  const Text(
                    'Y Offset:',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _yOffset.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Expanded(
                    child: Slider(
                      value: _yOffset,
                      min: -140,
                      max: 140,
                      divisions: 280,
                      onChanged: (value) {
                        setState(() {
                          _yOffset = value;
                        });
                        ref
                            .read(textInfoControllerProvider.notifier)
                            .changeShadowProperties(
                              shadowOffset: Offset(_xOffset, value),
                            );
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
}
