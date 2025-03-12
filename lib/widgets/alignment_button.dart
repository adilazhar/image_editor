import 'package:flutter/material.dart';

class AlignmentButton extends StatelessWidget {
  final bool isEnabled;
  final Function(String) onShowDialog;

  const AlignmentButton(this.isEnabled, this.onShowDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled
          ? () {
              onShowDialog('alignment');
            }
          : null,
      child: const Icon(Icons.format_align_center),
    );
  }
}
