import 'package:flutter/material.dart';

class PositionButton extends StatelessWidget {
  final bool isEnabled;
  final Function(String) onShowDialog;

  const PositionButton(this.isEnabled, this.onShowDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled
          ? () {
              onShowDialog('position');
            }
          : null,
      child: const Icon(Icons.open_with),
    );
  }
}
