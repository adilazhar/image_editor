import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class DeleteButton extends StatelessWidget {
  final bool isEnabled;

  const DeleteButton(this.isEnabled, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return OutlinedButton(
          onPressed: isEnabled
              ? () {
                  ref.read(textInfoControllerProvider.notifier).deleteText();
                }
              : null,
          child: const Icon(Icons.delete),
        );
      },
    );
  }
}
