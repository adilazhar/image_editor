import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_editor/widgets/color_button.dart';
import 'package:image_editor/widgets/delete_button.dart';
import 'package:image_editor/widgets/draggable_text.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';
import 'package:image_editor/widgets/font_size_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class EditScreen extends ConsumerStatefulWidget {
  const EditScreen({
    super.key,
    required this.image,
  });

  final File image;

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _saveImageToGallery() async {
    ref.read(selectedTextIndexProvider.notifier).clearSelection();
    final image = await _screenshotController.capture();
    if (image != null) {
      await ImageGallerySaver.saveImage(image);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved to gallery')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textList = ref.watch(textInfoControllerProvider);
    final isAnythingSelected = ref.watch(selectedTextIndexProvider.select(
      (value) => value != null,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                DeleteButton(isAnythingSelected),
                const Gap(10),
                ColorButton(isAnythingSelected),
                const Gap(10),
                FontSizeButton(isAnythingSelected),
                const Gap(10),
                OutlinedButton(
                  onPressed: _saveImageToGallery,
                  child: const Icon(Icons.save),
                ),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          ref.read(selectedTextIndexProvider.notifier).clearSelection();
        },
        child: Center(
          child: Screenshot(
            controller: _screenshotController,
            child: Stack(
              children: [
                Image.file(widget.image),
                for (int i = 0; i < textList.length; i++)
                  Positioned(
                    left: textList[i].position.dx,
                    top: textList[i].position.dy,
                    child: DraggableText(
                      textInfo: textList[i],
                      index: i,
                      ref: ref,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTextDialog(context, ref);
        },
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }

  Future<void> _showAddTextDialog(BuildContext context, WidgetRef ref) async {
    final TextEditingController textController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Text'),
          content: TextField(
            controller: textController,
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
              child: const Text('Add'),
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  ref
                      .read(textInfoControllerProvider.notifier)
                      .addText(textController.text);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Text cannot be empty')),
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
