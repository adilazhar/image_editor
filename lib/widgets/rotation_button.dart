import 'package:flutter/material.dart';

class RotationButton extends StatelessWidget {
  final bool isEnabled;
  final Function(String) onShowDialog;

  const RotationButton(this.isEnabled, this.onShowDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled
          ? () {
              onShowDialog('rotation');
            }
          : null,
      child: const Icon(Icons.rotate_right),
    );
  }
}
