# Flutter Image Editor

## Overview

An image editor built with Flutter (without plugins) that allows users to add text to images with extensive customization options including color, size, rotation, shadows, alignment, spacing, and background styling.

## Demo

[Add your demo video here]

## Features

The Flutter Image Editor supports adding text on images with the following customization options:

- **Text Styling**
  - Change text color
  - Adjust text size
  - Control opacity
  - Rotate text
- **Shadow Effects**
  - Customize shadow color
  - Adjust shadow opacity
  - Set blur radius
  - Configure X and Y offsets
- **Text Layout**
  - Text alignment (left, center, right)
  - Word spacing adjustment
  - Letter spacing control
  - Line spacing customization
  - Precise text positioning with pixel movement
- **Text Background**
  - Background color options
  - Customizable border radius
  - LTRB (Left, Top, Right, Bottom) padding control

## Tech Stack

- Flutter (v3.4.0+)
- Dart
- State Management: Riverpod

## Challenges & Solutions

### Managing Complex State

With so many customizable options, state management became complex quickly.

**Solution:** I leveraged Riverpod to create a well-structured state management system with separate providers for different aspects of text styling. This made the codebase more maintainable and easier to extend with new features.
