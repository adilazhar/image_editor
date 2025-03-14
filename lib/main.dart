import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/my_app.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// TODO: Update the Textfield to support multiline text
// TODO: Fix the text overlay when exporting 
// TODO: When A New Text Is Added Make It Selected
// TODO: Add if condition for saving to windows and take the logic from skribble clone app
// TODO: MOdify the bg dialog color picker to open the color picker dialog instead