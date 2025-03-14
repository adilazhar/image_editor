import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TextInfo extends Equatable {
  final String text;
  final double fontSize;
  final Color textColor;
  final Offset position;
  final double opacity;
  final double rotation;
  final bool hasShadow;
  final Color shadowColor;
  final double shadowOpacity;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final TextAlign textAlign;
  final double letterSpacing;
  final double wordSpacing;
  final double lineSpacing;
  final bool hasBackground;
  final Color backgroundColor;
  final EdgeInsets backgroundPadding;
  final double backgroundBorderRadius;
  final String alignment; // For relative positioning: "topLeft", "center", etc.

  const TextInfo({
    required this.text,
    this.fontSize = 20,
    this.textColor = Colors.black,
    this.position = Offset.zero,
    this.opacity = 1.0,
    this.rotation = 0.0,
    this.hasShadow = false,
    this.shadowColor = Colors.black,
    this.shadowOpacity = 0.5,
    this.shadowBlurRadius = 5.0,
    this.shadowOffset = const Offset(2, 2),
    this.textAlign = TextAlign.left,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
    this.lineSpacing = 0.0,
    this.hasBackground = false,
    this.backgroundColor = Colors.white,
    this.backgroundPadding = const EdgeInsets.all(8.0),
    this.backgroundBorderRadius = 8.0,
    this.alignment = 'topLeft',
  });

  TextInfo changeFontTo(double size) {
    return copyWith(fontSize: size);
  }

  TextInfo changeColorTo(Color color) {
    return copyWith(textColor: color);
  }

  TextInfo changeOpacityTo(double opacity) {
    return copyWith(opacity: opacity);
  }

  TextInfo changeRotationTo(double rotation) {
    return copyWith(rotation: rotation);
  }

  TextInfo changePositionTo(Offset newPosition) {
    return copyWith(position: newPosition);
  }

  TextInfo toggleShadow(bool value) {
    return copyWith(hasShadow: value);
  }

  TextInfo changeShadowProperties({
    Color? shadowColor,
    double? shadowOpacity,
    double? shadowBlurRadius,
    Offset? shadowOffset,
  }) {
    return copyWith(
      shadowColor: shadowColor,
      shadowOpacity: shadowOpacity,
      shadowBlurRadius: shadowBlurRadius,
      shadowOffset: shadowOffset,
    );
  }

  TextInfo changeTextAlignment(TextAlign textAlign) {
    return copyWith(textAlign: textAlign);
  }

  TextInfo changeSpacing({
    double? letterSpacing,
    double? wordSpacing,
    double? lineSpacing,
  }) {
    return copyWith(
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      lineSpacing: lineSpacing,
    );
  }

  TextInfo toggleBackground(bool value) {
    return copyWith(hasBackground: value);
  }

  TextInfo changeBackgroundProperties({
    Color? backgroundColor,
    EdgeInsets? backgroundPadding,
    double? backgroundBorderRadius,
  }) {
    return copyWith(
      backgroundColor: backgroundColor,
      backgroundPadding: backgroundPadding,
      backgroundBorderRadius: backgroundBorderRadius,
    );
  }

  TextInfo changeRelativeAlignment(String alignment) {
    return copyWith(alignment: alignment);
  }

  TextInfo copyWith({
    String? text,
    double? fontSize,
    Color? textColor,
    Offset? position,
    double? opacity,
    double? rotation,
    bool? hasShadow,
    Color? shadowColor,
    double? shadowOpacity,
    double? shadowBlurRadius,
    Offset? shadowOffset,
    TextAlign? textAlign,
    double? letterSpacing,
    double? wordSpacing,
    double? lineSpacing,
    bool? hasBackground,
    Color? backgroundColor,
    EdgeInsets? backgroundPadding,
    double? backgroundBorderRadius,
    String? alignment,
  }) {
    return TextInfo(
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      position: position ?? this.position,
      opacity: opacity ?? this.opacity,
      rotation: rotation ?? this.rotation,
      hasShadow: hasShadow ?? this.hasShadow,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      textAlign: textAlign ?? this.textAlign,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordSpacing: wordSpacing ?? this.wordSpacing,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      hasBackground: hasBackground ?? this.hasBackground,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundPadding: backgroundPadding ?? this.backgroundPadding,
      backgroundBorderRadius:
          backgroundBorderRadius ?? this.backgroundBorderRadius,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  String toString() {
    return 'TextInfo(text: $text, fontSize: $fontSize, textColor: $textColor, position: $position, '
        'opacity: $opacity, rotation: $rotation, hasShadow: $hasShadow, ...)';
  }

  @override
  List<Object> get props => [
        text,
        fontSize,
        textColor,
        position,
        opacity,
        rotation,
        hasShadow,
        shadowColor,
        shadowOpacity,
        shadowBlurRadius,
        shadowOffset,
        textAlign,
        letterSpacing,
        wordSpacing,
        lineSpacing,
        hasBackground,
        backgroundColor,
        backgroundPadding,
        backgroundBorderRadius,
        alignment,
      ];
}
