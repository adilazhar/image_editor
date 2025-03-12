import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_text_index.g.dart';

@Riverpod(keepAlive: true)
class SelectedTextIndex extends _$SelectedTextIndex {
  @override
  int? build() {
    return null;
  }

  void selectText(int i) {
    state = i;
  }

  void clearSelection() {
    state = null;
  }
}
