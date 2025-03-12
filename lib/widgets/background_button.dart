import 'package:flutter/material.dart';

class BackgroundButton extends StatelessWidget {
  final bool isEnabled;
  final Function(String) onShowDialog;

  const BackgroundButton(this.isEnabled, this.onShowDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled
          ? () {
              onShowDialog('background');
            }
          : null,
      child: const Icon(Icons.format_color_fill),
    );
  }
}
