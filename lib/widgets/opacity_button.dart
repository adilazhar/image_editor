import 'package:flutter/material.dart';

class OpacityButton extends StatelessWidget {
  final bool isEnabled;
  final Function(String) onShowDialog;

  const OpacityButton(this.isEnabled, this.onShowDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled
          ? () {
              onShowDialog('opacity');
            }
          : null,
      child: const Icon(Icons.opacity),
    );
  }
}
