import 'package:flutter/material.dart';
import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_text_color.g.dart';

@riverpod
Color selectedTextColor(SelectedTextColorRef ref) {
  final selectedTextIndex = ref.watch(selectedTextIndexProvider);
  final textList = ref.watch(textInfoControllerProvider);
  if (selectedTextIndex != null) {
    return textList[selectedTextIndex].textColor;
  } else {
    return Colors.black;
  }
}
