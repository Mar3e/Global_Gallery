import 'package:flutter/material.dart';
import 'package:global_gallery/state/posts/models/post.dart';
import 'package:global_gallery/state/user_info/providers/user_info_model_provider.dart';
import 'package:global_gallery/views/components/animations/small_animation_view.dart';
import 'package:global_gallery/views/components/rich_two_part_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostDisplayNameAndMessageView extends ConsumerWidget {
  final Post post;
  const PostDisplayNameAndMessageView(this.post, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoModel = ref.watch(
      userInfoModelProvider(post.userId),
    );
    return userInfoModel.when(
      data: (userInfo) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichTwoPartsText(
          leftPart: userInfo.displayName,
          rightPart: post.message,
        ),
      ),
      error: (error, stackTrace) => const SmallErrorAnimationView(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
