import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_editor/widgets/alignment_button.dart';
import 'package:image_editor/widgets/alignment_dialog.dart';
import 'package:image_editor/widgets/background_button.dart';
import 'package:image_editor/widgets/background_dialog.dart';
import 'package:image_editor/widgets/color_button.dart';
import 'package:image_editor/widgets/delete_button.dart';
import 'package:image_editor/widgets/draggable_text.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';
import 'package:image_editor/widgets/edit_button.dart';
import 'package:image_editor/widgets/font_size_button.dart';
import 'package:image_editor/widgets/font_size_dialog.dart';
import 'package:image_editor/widgets/line_spacing_button.dart';
import 'package:image_editor/widgets/line_spacing_dialog.dart';
import 'package:image_editor/widgets/opacity_button.dart';
import 'package:image_editor/widgets/opacity_dialog.dart';
import 'package:image_editor/widgets/position_button.dart';
import 'package:image_editor/widgets/position_dialog.dart';
import 'package:image_editor/widgets/relative_position_button.dart';
import 'package:image_editor/widgets/relative_position_dialog.dart';
import 'package:image_editor/widgets/rotation_button.dart';
import 'package:image_editor/widgets/rotation_dialog.dart';
import 'package:image_editor/widgets/shadow_button.dart';
import 'package:image_editor/widgets/shadow_dialog.dart';
import 'package:image_editor/widgets/spacing_button.dart';
import 'package:image_editor/widgets/spacing_dialog.dart';
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
  String? _activeDialog;

  Future<void> _saveImageToGallery() async {
    ref.read(selectedTextIndexProvider.notifier).clearSelection();
    final image = await _screenshotController.capture();
    if (image != null) {
      if (Platform.isAndroid || Platform.isIOS) {
        await ImageGallerySaver.saveImage(image, quality: 100);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to gallery')),
        );
      } else if (Platform.isWindows) {
        // Get the default Pictures directory
        final directory = Directory(
            '${Platform.environment['USERPROFILE']}\\Pictures\\Image Editor');

        // Ensure the directory exists
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        // Create file path
        final filePath =
            '${directory.path}\\editing_${DateTime.now().millisecondsSinceEpoch}.png';

        // Write image to file
        File file = File(filePath);
        await file.writeAsBytes(image);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Image saved to: $filePath'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Saving not supported on this platform.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture image')),
      );
    }
  }

  void _showDialog(String dialogName) {
    setState(() {
      if (_activeDialog == dialogName) {
        _activeDialog = null;
      } else {
        _activeDialog = dialogName;
      }
    });
  }

  void _closeDialog() {
    setState(() {
      _activeDialog = null;
    });
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
                EditButton(isAnythingSelected),
                const Gap(10),
                ColorButton(isAnythingSelected),
                const Gap(10),
                FontSizeButton(isAnythingSelected, _showDialog),
                const Gap(10),
                // New buttons for added features
                OpacityButton(isAnythingSelected, _showDialog),
                const Gap(10),
                RotationButton(isAnythingSelected, _showDialog),
                const Gap(10),
                ShadowButton(isAnythingSelected, _showDialog),
                const Gap(10),
                AlignmentButton(isAnythingSelected, _showDialog),
                const Gap(10),
                SpacingButton(isAnythingSelected, _showDialog),
                const Gap(10),
                LineSpacingButton(isAnythingSelected, _showDialog),
                const Gap(10),
                PositionButton(isAnythingSelected, _showDialog),
                const Gap(10),
                RelativePositionButton(isAnythingSelected, _showDialog),
                const Gap(10),
                BackgroundButton(isAnythingSelected, _showDialog),
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
      body: Column(
        children: [
          if (_activeDialog != null) _buildDialogWidget(),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(selectedTextIndexProvider.notifier).clearSelection();
                _closeDialog();
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTextDialog(context, ref);
        },
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }

  Widget _buildDialogWidget() {
    switch (_activeDialog) {
      case 'fontSize':
        return FontSizeDialog(onClose: _closeDialog);
      case 'opacity':
        return OpacityDialog(onClose: _closeDialog);
      case 'rotation':
        return RotationDialog(onClose: _closeDialog);
      case 'shadow':
        return ShadowDialog(onClose: _closeDialog);
      case 'alignment':
        return AlignmentDialog(onClose: _closeDialog);
      case 'spacing':
        return SpacingDialog(onClose: _closeDialog);
      case 'lineSpacing':
        return LineSpacingDialog(onClose: _closeDialog);
      case 'position':
        return PositionDialog(onClose: _closeDialog);
      case 'relativePosition':
        return RelativePositionDialog(onClose: _closeDialog);
      case 'background':
        return BackgroundDialog(onClose: _closeDialog);
      default:
        return const SizedBox.shrink();
    }
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
