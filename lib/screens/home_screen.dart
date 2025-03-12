import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editor/screens/edit_screen.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditScreen(image: image),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () => _pickImage(context),
          icon: const Icon(Icons.upload_file_rounded),
        ),
      ),
    );
  }
}
