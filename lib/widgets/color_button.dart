import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_color.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class ColorButton extends StatelessWidget {
  final bool isEnabled;

  const ColorButton(this.isEnabled, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return OutlinedButton(
          onPressed: isEnabled
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Select Color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: ref.read(selectedTextColorProvider),
                            onColorChanged: (color) {
                              ref
                                  .read(textInfoControllerProvider.notifier)
                                  .changeColor(color);
                            },
                            enableAlpha: true,
                            hexInputBar: true,
                            pickerAreaHeightPercent: 0.8,
                            displayThumbColor: true,
                            paletteType: PaletteType.hsv,
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Apply'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              : null,
          child: const Icon(Icons.color_lens),
        );
      },
    );
  }
}
