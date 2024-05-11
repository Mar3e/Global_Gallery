import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_gallery/state/constants/firebase_collection_name.dart';
import 'package:global_gallery/state/constants/firebase_field_name.dart';
import 'package:global_gallery/state/posts/models/post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final allPostsProvider = StreamProvider.autoDispose<Iterable<Post>>(
  (ref) {
    final controller = StreamController<Iterable<Post>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .orderBy(
          FirebaseFieldName.createdAt,
          descending: true,
        )
        .snapshots()
        .listen((snapshot) {
      final posts = snapshot.docs
          .where((doc) => !doc.metadata.hasPendingWrites)
          .map(
            (e) => Post(
              postId: e.id,
              json: e.data(),
            ),
          )
          .toList();

      controller.sink.add(posts);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);
