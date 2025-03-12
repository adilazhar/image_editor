import 'package:image_editor/providers/selected_text_index.dart';
import 'package:image_editor/providers/text_info_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_text_font_size.g.dart';

@riverpod
double selectedTextFontSize(SelectedTextFontSizeRef ref) {
  final selectedTextIndex = ref.watch(selectedTextIndexProvider);
  if (selectedTextIndex != null) {
    final text = ref.watch(textInfoControllerProvider.select(
      (value) => value[selectedTextIndex],
    ));
    return text.fontSize;
  } else {
    return 20;
  }
}
