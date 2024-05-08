import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_gallery/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:global_gallery/state/comments/models/comment.dart';
import 'package:global_gallery/state/comments/models/post_comment_request.dart';
import 'package:global_gallery/state/comments/models/post_with_comment.dart';
import 'package:global_gallery/state/constants/firebase_collection_name.dart';
import 'package:global_gallery/state/constants/firebase_field_name.dart';
import 'package:global_gallery/state/posts/models/post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final specificPostWithCommentsProvider = StreamProvider.family
    .autoDispose<PostWithComment, RequestForPostAndComments>(
  (ref, RequestForPostAndComments request) {
    final controller = StreamController<PostWithComment>();

    Post? post;
    Iterable<Comment>? comments;

    void notify() {
      final localPost = post;
      if (localPost == null) return;

      final outPutComments = (comments ?? []).applySortingFrom(
        request,
      );

      final result = PostWithComment(
        post: localPost,
        comments: outPutComments,
      );

      controller.sink.add(result);
    }

// watch changes to the post
    final postSub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .where(FieldPath.documentId, isEqualTo: request.postId)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        post = null;
        comments = null;
        notify();
        return;
      }

      final doc = snapshot.docs.first;
      if (doc.metadata.hasPendingWrites) return;

      post = Post(
        postId: doc.id,
        json: doc.data(),
      );
      notify();
    });
// watch changes to the comments
    final commentQuery = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.comments)
        .where(FirebaseFieldName.postId, isEqualTo: request.postId)
        .orderBy(FirebaseFieldName.createdAt, descending: true);

    final limitedCommentQuery = request.limit != null
        ? commentQuery.limit(request.limit!)
        : commentQuery;

    final commentSub = limitedCommentQuery.snapshots().listen((snapshot) {
      comments = snapshot.docs
          .where(
            (commentDoc) => !commentDoc.metadata.hasPendingWrites,
          )
          .map(
            (commentDoc) => Comment(
              id: commentDoc.id,
              json: commentDoc.data(),
            ),
          )
          .toList();

      notify();
    });

    ref.onDispose(() {
      commentSub.cancel();
      postSub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
