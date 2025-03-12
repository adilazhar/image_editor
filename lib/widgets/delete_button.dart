import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class DeleteButton extends ConsumerWidget {
  const DeleteButton(
    this.isAnythingSelected, {
    super.key,
  });

  final bool isAnythingSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: isAnythingSelected
          ? () => ref.read(textInfoControllerProvider.notifier).deleteText()
          : null,
      child: const Icon(
        Icons.delete_rounded,
      ),
    );
  }
}
