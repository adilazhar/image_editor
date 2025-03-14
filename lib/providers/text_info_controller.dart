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
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i != index) state[i]
      ];
      ref.read(selectedTextIndexProvider.notifier).clearSelection();
    }
  }

  void changeColor(Color color) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) state[i].changeColorTo(color) else state[i]
      ];
    }
  }

  void changeFont(double size) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) state[i].changeFontTo(size) else state[i]
      ];
    }
  }

  void changePosition(int index, Offset position) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) state[i].changePositionTo(position) else state[i]
    ];
  }

  // New methods for added features
  void changeOpacity(double opacity) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) state[i].changeOpacityTo(opacity / 100) else state[i]
      ];
    }
  }

  void changeRotation(double rotation) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) state[i].changeRotationTo(rotation) else state[i]
      ];
    }
  }

  void toggleShadow(bool value) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) state[i].toggleShadow(value) else state[i]
      ];
    }
  }

  void changeShadowProperties({
    Color? shadowColor,
    double? shadowOpacity,
    double? shadowBlurRadius,
    Offset? shadowOffset,
  }) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index)
            state[i].changeShadowProperties(
              shadowColor: shadowColor,
              shadowOpacity: shadowOpacity != null ? shadowOpacity / 100 : null,
              shadowBlurRadius: shadowBlurRadius,
              shadowOffset: shadowOffset,
            )
          else
            state[i]
      ];
    }
  }

  void changeTextAlignment(TextAlign align) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) state[i].changeTextAlignment(align) else state[i]
      ];
    }
  }

  void changeSpacing({
    double? letterSpacing,
    double? wordSpacing,
    double? lineSpacing,
  }) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index)
            state[i].changeSpacing(
              letterSpacing: letterSpacing,
              wordSpacing: wordSpacing,
              lineSpacing: lineSpacing,
            )
          else
            state[i]
      ];
    }
  }

  void toggleBackground(bool value) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) state[i].toggleBackground(value) else state[i]
      ];
    }
  }

  void changeBackgroundProperties({
    Color? backgroundColor,
    EdgeInsets? backgroundPadding,
    double? backgroundBorderRadius,
  }) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index)
            state[i].changeBackgroundProperties(
              backgroundColor: backgroundColor,
              backgroundPadding: backgroundPadding,
              backgroundBorderRadius: backgroundBorderRadius,
            )
          else
            state[i]
      ];
    }
  }

  void moveTextByAmount(double amount, String direction) {
    final index = ref.read(selectedTextIndexProvider);
    if (index != null) {
      final currentPosition = state[index].position;
      Offset newPosition;

      switch (direction) {
        case 'left':
          newPosition = Offset(currentPosition.dx - amount, currentPosition.dy);
          break;
        case 'right':
          newPosition = Offset(currentPosition.dx + amount, currentPosition.dy);
          break;
        case 'up':
          newPosition = Offset(currentPosition.dx, currentPosition.dy - amount);
          break;
        case 'down':
          newPosition = Offset(currentPosition.dx, currentPosition.dy + amount);
          break;
        default:
          newPosition = currentPosition;
      }

      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) state[i].changePositionTo(newPosition) else state[i]
      ];
    }
  }
}
