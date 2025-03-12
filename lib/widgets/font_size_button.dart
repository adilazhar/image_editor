import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_font_size.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class FontSizeButton extends ConsumerStatefulWidget {
  const FontSizeButton(
    this.isAnythingSelected, {
    super.key,
  });

  final bool isAnythingSelected;

  @override
  ConsumerState<FontSizeButton> createState() => _FontSizeButtonState();
}

class _FontSizeButtonState extends ConsumerState<FontSizeButton> {
  @override
  Widget build(BuildContext context) {
    final size = ref.watch(selectedTextFontSizeProvider);

    // Use a TextEditingController to handle the font size input
    final controller = TextEditingController(text: size.toInt().toString());

    return SizedBox(
      width: 70,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        enabled: widget.isAnythingSelected,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        onSubmitted: (val) {
          final newSize = int.tryParse(val) ?? size;
          ref
              .read(textInfoControllerProvider.notifier)
              .changeFont(newSize.toDouble());
        },
      ),
    );
  }
}
