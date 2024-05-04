import 'package:flutter/material.dart';

@immutable
class ImageWithAspectRation {
  final Image image;
  final double aspectRation;

  const ImageWithAspectRation({
    required this.image,
    required this.aspectRation,
  });
}
