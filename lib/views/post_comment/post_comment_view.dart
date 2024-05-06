import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:global_gallery/state/auth/providers/user_id_provider.dart';
import 'package:global_gallery/state/comments/models/post_comment_request.dart';
import 'package:global_gallery/state/comments/providers/post_comment_provider.dart';
import 'package:global_gallery/state/comments/providers/send_comment_provider.dart';
import 'package:global_gallery/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:global_gallery/views/components/animations/error_animation_view.dart';
import 'package:global_gallery/views/components/animations/loading_animation_view.dart';
import 'package:global_gallery/views/components/comment/comment_tile.dart';
import 'package:global_gallery/views/constants/strings.dart';
import 'package:global_gallery/views/extensions/dismiss_keyboard.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:global_gallery/state/posts/typedefs/post_id.dart';

class PostCommentView extends HookConsumerWidget {
  final PostId postId;
  const PostCommentView({
    required this.postId,
    super.key,
  });

  Future<void> _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) return;

    final isSent = await ref.read(sendCommentProvider.notifier).sendComment(
          fromUserId: userId,
          onPostId: postId,
          comment: controller.text,
        );

    if (isSent) {
      controller.clear();
      dismissKeyboard();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();
    final hasText = useState(false);
    final request = useState(
      //* You can later make this editable form outside so user can modify his comments view
      RequestForPostAndComments(
        postId: postId,
      ),
    );

    final comments = ref.watch(
      postCommentProvider(request.value),
    );

    useEffect(() {
      commentController.addListener(() {
        hasText.value = commentController.text.isNotEmpty;
      });
      return () {};
    }, [commentController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.comments,
        ),
        actions: [
          IconButton(
            onPressed: hasText.value
                ? () => _submitCommentWithController(
                      commentController,
                      ref,
                    )
                : null,
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: comments.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return const SingleChildScrollView(
                      child: EmptyContentsWithTextAnimationView(
                        text: Strings.noCommentsYet,
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      ref.invalidate(
                        postCommentProvider(
                          request.value,
                        ),
                      );
                      return Future.delayed(
                        const Duration(
                          seconds: 1,
                        ),
                      );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments.elementAt(index);
                        return CommentTile(
                          comment: comment,
                        );
                      },
                    ),
                  );
                },
                error: (error, st) => const ErrorAnimationView(),
                loading: () => const LoadingAnimationView(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    controller: commentController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.writeYourCommentHere,
                    ),
                    onSubmitted: (comment) {
                      if (comment.isNotEmpty) {
                        _submitCommentWithController(
                          commentController,
                          ref,
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
