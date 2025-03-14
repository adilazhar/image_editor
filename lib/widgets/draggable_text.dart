import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/model/text_info.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class DraggableText extends ConsumerStatefulWidget {
  final TextInfo textInfo;
  final int index;
  final WidgetRef ref;

  const DraggableText({
    super.key,
    required this.textInfo,
    required this.index,
    required this.ref,
  });

  @override
  DraggableTextState createState() => DraggableTextState();
}

class DraggableTextState extends ConsumerState<DraggableText> {
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _offset = widget.textInfo.position;
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = ref.watch(selectedTextIndexProvider.select(
      (value) => value == widget.index,
    ));

    return GestureDetector(
      onTapDown: (details) {
        ref.read(selectedTextIndexProvider.notifier).selectText(widget.index);
      },
      onDoubleTap: () {
        ref.read(selectedTextIndexProvider.notifier).selectText(widget.index);
        _showUpdateTextDialog();
      },
      onPanStart: (details) {
        ref.read(selectedTextIndexProvider.notifier).selectText(widget.index);

        // Calculate the initial offset when the drag starts
        _offset = Offset(
          details.globalPosition.dx - widget.textInfo.position.dx,
          details.globalPosition.dy - widget.textInfo.position.dy,
        );
      },
      onPanUpdate: (details) {
        ref.read(selectedTextIndexProvider.notifier).selectText(widget.index);
        // Update the position based on the global position of the gesture
        final newPosition = Offset(
          details.globalPosition.dx - _offset.dx,
          details.globalPosition.dy - _offset.dy,
        );
        widget.ref.read(textInfoControllerProvider.notifier).changePosition(
              widget.index,
              newPosition,
            );
      },
      child: Transform.rotate(
        angle: widget.textInfo.rotation *
            (3.14159265359 / 180), // Convert degrees to radians
        child: Opacity(
          opacity: widget.textInfo.opacity,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 1.0,
                  ),
                ),
                child: Container(
                  decoration: widget.textInfo.hasBackground
                      ? BoxDecoration(
                          color: widget.textInfo.backgroundColor
                              .withOpacity(widget.textInfo.opacity),
                          borderRadius: BorderRadius.circular(
                              widget.textInfo.backgroundBorderRadius),
                        )
                      : null,
                  padding: widget.textInfo.hasBackground
                      ? widget.textInfo.backgroundPadding
                      : EdgeInsets.zero,
                  child: Text(
                    widget.textInfo.text,
                    style: TextStyle(
                      color: widget.textInfo.textColor,
                      fontSize: widget.textInfo.fontSize,
                      shadows: widget.textInfo.hasShadow
                          ? [
                              Shadow(
                                color: widget.textInfo.shadowColor
                                    .withOpacity(widget.textInfo.shadowOpacity),
                                blurRadius: widget.textInfo.shadowBlurRadius,
                                offset: widget.textInfo.shadowOffset,
                              )
                            ]
                          : null,
                      letterSpacing: widget.textInfo.letterSpacing,
                      wordSpacing: widget.textInfo.wordSpacing,
                      height: 1 + (widget.textInfo.lineSpacing / 100),
                    ),
                    textAlign: widget.textInfo.textAlign,
                    // textAlign: TextAlign.,
                  ),
                ),
              ),
              // Selection indicators
              if (isSelected) ...[
                const Positioned(
                  top: 0,
                  left: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.blue,
                  ),
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.blue,
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  left: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.blue,
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showUpdateTextDialog() async {
    final TextEditingController textController =
        TextEditingController(text: widget.textInfo.text);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Text'),
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
                  widget.ref
                      .read(textInfoControllerProvider.notifier)
                      .updateText(widget.index, textController.text.trim());
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
