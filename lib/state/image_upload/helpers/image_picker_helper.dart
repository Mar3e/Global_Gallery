import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:global_gallery/state/image_upload/extension/to_file.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class ImagePickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> pickImageFromGallery() => _imagePicker
      .pickImage(
        source: ImageSource.gallery,
      )
      .toFile();
  static Future<File?> pickVideoFromGallery() => _imagePicker
      .pickVideo(
        source: ImageSource.gallery,
      )
      .toFile();
}
