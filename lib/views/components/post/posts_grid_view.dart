import 'package:flutter/material.dart';
import 'package:global_gallery/state/posts/models/post.dart';
import 'package:global_gallery/views/components/post/post_thumbnail_view.dart';
import 'package:global_gallery/views/post_comment/post_comment_view.dart';

class PostsGridView extends StatelessWidget {
  final Iterable<Post> posts;
  const PostsGridView({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index);
        return PostThumbnailView(
          post: post,
          onTap: () {
            //TODO navigate to post details view
          },
        );
      },
    );
  }
}
