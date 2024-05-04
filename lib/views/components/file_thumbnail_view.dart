import 'package:flutter/material.dart';
import 'package:global_gallery/state/image_upload/models/thumbnail_request.dart';
import 'package:global_gallery/state/image_upload/providers/thumbnail_provider.dart';
import 'package:global_gallery/views/components/animations/loading_animation_view.dart';
import 'package:global_gallery/views/components/animations/small_animation_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FileThumbnailView extends ConsumerWidget {
  final ThumbnailRequest thumbnailRequest;
  const FileThumbnailView({
    required this.thumbnailRequest,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnail = ref.watch(thumbnailProvider(thumbnailRequest));

    return thumbnail.when(
      data: (imageWithAspectRation) => AspectRatio(
        aspectRatio: imageWithAspectRation.aspectRation,
        child: imageWithAspectRation.image,
      ),
      error: (error, stackTrace) => const SmallErrorAnimationView(),
      loading: () => const LoadingAnimationView(),
    );
  }
}
