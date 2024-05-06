import 'package:flutter/material.dart';
import 'package:global_gallery/state/likes/providers/post_likes_count_provider.dart';
import 'package:global_gallery/state/posts/typedefs/post_id.dart';
import 'package:global_gallery/views/components/animations/small_animation_view.dart';
import 'package:global_gallery/views/components/constants/strings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostLikesCountView extends ConsumerWidget {
  final PostId postId;
  const PostLikesCountView({required this.postId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(postLikesCountProvider(postId));

    return likesCount.when(
      data: (int likes) {
        final personOrPeople = likes == 1 ? Strings.person : Strings.people;
        final likesText = '$likes $personOrPeople ${Strings.likedThis}';

        return Text(likesText);
      },
      error: (error, stackTrace) => const SmallErrorAnimationView(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
