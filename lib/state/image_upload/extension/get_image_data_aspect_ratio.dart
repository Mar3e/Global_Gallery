import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart' as material show Image;
import 'package:global_gallery/state/image_upload/extension/get_image_aspect_ratio.dart';

extension GetImageDataAspectRation on Uint8List {
  Future<double> getAspectRation() {
    final image = material.Image.memory(this);

    return image.getAspectRatio();
  }
}
