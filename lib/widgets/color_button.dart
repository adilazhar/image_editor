import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_color.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class ColorButton extends ConsumerWidget {
  const ColorButton(
    this.isAnythingSelected, {
    super.key,
  });

  final bool isAnythingSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTextColor = ref.watch(selectedTextColorProvider);
    return OutlinedButton(
      onPressed: isAnythingSelected
          ? () {
              _showColorPickerDialog(context, ref);
            }
          : null,
      child: Icon(
        Icons.color_lens_rounded,
        color: isAnythingSelected ? selectedTextColor : null,
      ),
    );
  }

  Future<void> _showColorPickerDialog(
      BuildContext context, WidgetRef ref) async {
    Color selectedColor = ref.read(selectedTextColorProvider);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: true,
              displayThumbColor: true,
              paletteType: PaletteType.hsv,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                ref
                    .read(textInfoControllerProvider.notifier)
                    .changeColor(selectedColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
