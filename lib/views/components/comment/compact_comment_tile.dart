import 'package:flutter/material.dart';
import 'package:global_gallery/state/comments/models/comment.dart';
import 'package:global_gallery/state/user_info/providers/user_info_model_provider.dart';
import 'package:global_gallery/views/components/animations/small_animation_view.dart';
import 'package:global_gallery/views/components/rich_two_part_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompactCommentTile extends ConsumerWidget {
  final Comment comment;
  const CompactCommentTile(this.comment, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // fetch the user info
    final userInfo = ref.watch(
      userInfoModelProvider(comment.fromUserId),
    );

    return userInfo.when(
      data: (userInfo) {
        return RichTwoPartsText(
          leftPart: userInfo.displayName,
          rightPart: comment.comment,
        );
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
