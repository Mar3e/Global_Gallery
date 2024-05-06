import 'package:flutter/material.dart';
import 'package:global_gallery/state/auth/providers/user_id_provider.dart';
import 'package:global_gallery/state/comments/models/comment.dart';
import 'package:global_gallery/state/comments/providers/delete_comment_provider.dart';
import 'package:global_gallery/state/user_info/providers/user_info_model_provider.dart';
import 'package:global_gallery/views/components/animations/loading_animation_view.dart';
import 'package:global_gallery/views/components/animations/small_animation_view.dart';
import 'package:global_gallery/views/components/constants/strings.dart';
import 'package:global_gallery/views/components/dialogs/alert_dialog_model.dart';
import 'package:global_gallery/views/components/dialogs/delete_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;
  const CommentTile({
    required this.comment,
    super.key,
  });

  Future<bool> displayDeleteDialog(BuildContext context) =>
      const DeleteDialog(titleOfObjectToDelete: Strings.comment)
          .present(context)
          .then((value) => value ?? false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(comment.fromUserId),
    );

    return userInfo.when(
        data: (userInfo) {
          final currentUser = ref.read(userIdProvider);
          return ListTile(
            trailing: currentUser == comment.fromUserId
                ? IconButton(
                    onPressed: () async {
                      final shouldDeleteComment =
                          await displayDeleteDialog(context);
                      if (shouldDeleteComment) {
                        await ref
                            .read(deleteCommentProvider.notifier)
                            .deleteComment(commentId: comment.id);
                      }
                    },
                    icon: const Icon(Icons.delete),
                  )
                : null,
            title: Text(userInfo.displayName),
            subtitle: Text(comment.comment),
          );
        },
        error: (error, st) => const SmallErrorAnimationView(),
        loading: () => const LoadingAnimationView());
  }
}
