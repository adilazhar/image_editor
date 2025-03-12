import 'package:flutter/material.dart';

class LineSpacingButton extends StatelessWidget {
  final bool isEnabled;
  final Function(String) onShowDialog;

  const LineSpacingButton(this.isEnabled, this.onShowDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled
          ? () {
              onShowDialog('lineSpacing');
            }
          : null,
      child: const Icon(Icons.format_line_spacing),
    );
  }
}
