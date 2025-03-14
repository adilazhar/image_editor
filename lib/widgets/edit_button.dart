import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class EditButton extends StatelessWidget {
  final bool isEnabled;

  const EditButton(this.isEnabled, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return OutlinedButton(
          onPressed: isEnabled
              ? () {
                  final selectedIndex = ref.read(selectedTextIndexProvider);
                  if (selectedIndex != null) {
                    final textList = ref.read(textInfoControllerProvider);
                    final textInfo = textList[selectedIndex];
                    final textController =
                        TextEditingController(text: textInfo.text);

                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Edit Text'),
                          content: TextField(
                            controller: textController,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Enter text',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Update'),
                              onPressed: () {
                                if (textController.text.isNotEmpty) {
                                  ref
                                      .read(textInfoControllerProvider.notifier)
                                      .updateText(selectedIndex,
                                          textController.text.trim());
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Text cannot be empty')),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              : null,
          child: const Icon(Icons.edit),
        );
      },
    );
  }
}
