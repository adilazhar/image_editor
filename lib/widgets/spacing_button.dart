import 'package:flutter/material.dart';

class SpacingButton extends StatelessWidget {
  final bool isEnabled;
  final Function(String) onShowDialog;

  const SpacingButton(this.isEnabled, this.onShowDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled
          ? () {
              onShowDialog('spacing');
            }
          : null,
      child: const Icon(Icons.space_bar),
    );
  }
}
