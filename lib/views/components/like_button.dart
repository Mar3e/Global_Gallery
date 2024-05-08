import 'package:flutter/material.dart';
import 'package:global_gallery/state/auth/providers/user_id_provider.dart';
import 'package:global_gallery/state/likes/models/like_dislike_request.dart';
import 'package:global_gallery/state/likes/providers/has_liked_post_provider.dart';
import 'package:global_gallery/state/likes/providers/like_dislike_post_provider.dart';
import 'package:global_gallery/state/posts/typedefs/post_id.dart';
import 'package:global_gallery/views/components/animations/small_animation_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LikeButton extends ConsumerWidget {
  final PostId postId;
  const LikeButton(this.postId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLiked = ref.watch(
      hasLikedPostProvider(postId),
    );
    return hasLiked.when(
      data: (hasLiked) {
        return IconButton(
          onPressed: () {
            final userId = ref.read(userIdProvider);
            if (userId == null) return;
            final likeRequest = LikeDislikeRequest(
              postId: postId,
              likedBy: userId,
            );
            ref.read(
              likeDislikePostProvider(
                likeRequest,
              ),
            );
          },
          icon: hasLiked
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
        );
      },
      error: (error, stackTrace) => const SmallErrorAnimationView(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
