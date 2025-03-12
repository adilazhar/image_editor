import 'package:flutter/material.dart';
import 'package:image_editor/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Editor',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
