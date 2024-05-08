import 'package:flutter/material.dart';
import 'package:global_gallery/enums/date_sorting_enum.dart';
import 'package:global_gallery/state/comments/models/post_comment_request.dart';
import 'package:global_gallery/state/posts/models/post.dart';
import 'package:global_gallery/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:global_gallery/state/posts/providers/delete_post_provider.dart';
import 'package:global_gallery/state/posts/providers/specific_post_with_comments_provider.dart';
import 'package:global_gallery/views/components/animations/error_animation_view.dart';
import 'package:global_gallery/views/components/animations/loading_animation_view.dart';
import 'package:global_gallery/views/components/animations/small_animation_view.dart';
import 'package:global_gallery/views/components/comment/compact_comment_column.dart';
import 'package:global_gallery/views/components/dialogs/alert_dialog_model.dart';
import 'package:global_gallery/views/components/dialogs/delete_dialog.dart';
import 'package:global_gallery/views/components/like_button.dart';
import 'package:global_gallery/views/components/post/post_date_view.dart';
import 'package:global_gallery/views/components/post/post_display_name_and_message_view.dart';
import 'package:global_gallery/views/components/post/post_image_or_video_view.dart';
import 'package:global_gallery/views/components/post/post_likes_count_view.dart';
import 'package:global_gallery/views/constants/strings.dart';
import 'package:global_gallery/views/post_comment/post_comment_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailsView({
    required this.post,
    super.key,
  });

  @override
  ConsumerState<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      dateSorting: DateSorting.oldestOnTop,
    );
// get the post with all it's associated comments
    final postWithComments = ref.watch(
      specificPostWithCommentsProvider(
        request,
      ),
    );

    // can post be deleted by current user ?
    final canDeletePost = ref.watch(
      canCurrentUserDeletePostProvider(
        widget.post,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.postDetails),
        actions: [
          // this is the sharing button
          postWithComments.when(
            data: (postWithComments) => IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                final fileUrl = postWithComments.post.fileUrl;
                Share.share(fileUrl, subject: Strings.checkOutThisPost);
              },
            ),
            error: (error, stackTrace) => const SmallErrorAnimationView(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // this is the delete button
          if (canDeletePost.value ?? false)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final shouldDeletePost = await const DeleteDialog(
                        titleOfObjectToDelete: Strings.post)
                    .present(context)
                    .then(
                      (shouldDeletePost) => shouldDeletePost ?? false,
                    );

                if (shouldDeletePost) {
                  await ref
                      .read(deletePostProvider.notifier)
                      .deletePost(post: widget.post);

                  if (context.mounted) Navigator.of(context).pop();
                }
              },
            ),
        ],
      ),
      body: postWithComments.when(
        data: (postWithComments) {
          final postId = postWithComments.post.postId;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVideoView(
                  post: postWithComments.post,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (postWithComments.post.allowLikes)
                      LikeButton(
                        postId,
                      ),
                    if (postWithComments.post.allowComments)
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostCommentView(postId: postId),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                PostDisplayNameAndMessageView(
                  postWithComments.post,
                ),
                PostDateView(
                  dateTime: postWithComments.post.createdAt,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.white70,
                  ),
                ),
                CompactCommentColumn(
                  comments: postWithComments.comments,
                ),
                if (postWithComments.post.allowLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        PostLikesCountView(
                          postId: postId,
                        ),
                      ],
                    ),
                  ),
                // add spacing to the bottom of the screen
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => const ErrorAnimationView(),
        loading: () => const LoadingAnimationView(),
      ),
    );
  }
}
