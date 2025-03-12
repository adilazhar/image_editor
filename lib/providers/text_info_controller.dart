import 'package:flutter/material.dart';
import 'package:image_editor/model/text_info.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_info_controller.g.dart';

@riverpod
class TextInfoController extends _$TextInfoController {
  @override
  List<TextInfo> build() {
    return [];
  }

  void addText(String text) {
    state = [...state, TextInfo(text: text)];
  }

  void updateText(int index, String newText) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) state[i].copyWith(text: newText) else state[i]
    ];
  }

  void deleteText() {
    final index = ref.read(selectedTextIndexProvider);
    state = [
      for (var i = 0; i < state.length; i++)
        if (i != index) state[i]
    ];
    ref.read(selectedTextIndexProvider.notifier).clearSelection();
  }

  void changeColor(Color color) {
    final index = ref.read(selectedTextIndexProvider);
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) state[i].changeColorTo(color) else state[i]
    ];
  }

  void changeFont(double size) {
    final index = ref.read(selectedTextIndexProvider);
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) state[i].changeFontTo(size) else state[i]
    ];
  }

  void changePosition(int index, Offset position) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) state[i].changePositionTo(position) else state[i]
    ];
  }
}
