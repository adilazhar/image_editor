import 'package:flutter/material.dart';

class ShadowButton extends StatelessWidget {
  final bool isEnabled;
  final Function(String) onShowDialog;

  const ShadowButton(this.isEnabled, this.onShowDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled
          ? () {
              onShowDialog('shadow');
            }
          : null,
      child: const Icon(Icons.blur_on),
    );
  }
}
