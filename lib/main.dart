import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/my_app.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// TODO: Update the Textfield to support multiline text
// TODO: Fix the text overlay when exporting 
// TODO: When A New Text Is Added Make It Selected
// TODO: MOdify the bg dialog color picker to open the color picker dialog instead
// TODO: Add A back button for the home screen