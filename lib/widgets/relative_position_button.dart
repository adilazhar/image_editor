import 'package:flutter/material.dart';

class RelativePositionButton extends StatelessWidget {
  final bool isEnabled;
  final Function(String) onShowDialog;

  const RelativePositionButton(this.isEnabled, this.onShowDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled
          ? () {
              onShowDialog('relativePosition');
            }
          : null,
      child: const Icon(Icons.aspect_ratio),
    );
  }
}
