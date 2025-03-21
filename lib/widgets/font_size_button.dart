import 'package:flutter/material.dart';

class FontSizeButton extends StatelessWidget {
  final bool isEnabled;
  final Function(String) onShowDialog;

  const FontSizeButton(this.isEnabled, this.onShowDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled
          ? () {
              onShowDialog('fontSize');
            }
          : null,
      child: const Icon(Icons.format_size),
    );
  }
}
