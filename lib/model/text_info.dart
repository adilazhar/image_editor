import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TextInfo extends Equatable {
  final String text;
  final double fontSize;
  final Color textColor;
  final Offset position;

  const TextInfo({
    required this.text,
    this.fontSize = 20,
    this.textColor = Colors.black,
    this.position = Offset.zero,
  });

  TextInfo changeFontTo(double size) {
    return copyWith(fontSize: size);
  }

  TextInfo changeColorTo(Color color) {
    return copyWith(textColor: color);
  }

  TextInfo changePositionTo(Offset newPosition) {
    return copyWith(position: newPosition);
  }

  TextInfo copyWith({
    String? text,
    double? fontSize,
    Color? textColor,
    Offset? position,
  }) {
    return TextInfo(
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      position: position ?? this.position,
    );
  }

  @override
  String toString() {
    return 'TextInfo(text: $text, fontSize: $fontSize, textColor: $textColor, position: $position)';
  }

  @override
  List<Object> get props => [text, fontSize, textColor, position];
}
