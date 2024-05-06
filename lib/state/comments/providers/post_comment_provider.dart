import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_gallery/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:global_gallery/state/comments/models/comment.dart';
import 'package:global_gallery/state/comments/models/post_comment_request.dart';
import 'package:global_gallery/state/constants/firebase_collection_name.dart';
import 'package:global_gallery/state/constants/firebase_field_name.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postCommentProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, RequestForPostAndComments>(
  (
    ref,
    RequestForPostAndComments request,
  ) {
    final controller = StreamController<Iterable<Comment>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.comments)
        .where(
          FirebaseFieldName.postId,
          isEqualTo: request.postId,
        )
        .snapshots()
        .listen(
      (snapShot) {
        final docs = snapShot.docs;
        final limitedDocs =
            request.limit != null ? docs.take(request.limit!) : docs;

        /// because we create a comment with a server timestamp
        /// it may be in a pending writes state
        /// so whe should not take those
        final comments =
            limitedDocs.where((doc) => !doc.metadata.hasPendingWrites).map(
                  (document) => Comment(
                    document.data(),
                    id: document.id,
                  ),
                );
        final result = comments.applySortingFrom(request);
        controller.sink.add(result);
      },
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
