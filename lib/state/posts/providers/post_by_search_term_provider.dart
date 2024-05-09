import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_gallery/state/constants/firebase_collection_name.dart';
import 'package:global_gallery/state/constants/firebase_field_name.dart';
import 'package:global_gallery/state/posts/models/post.dart';
import 'package:global_gallery/state/posts/typedefs/search_term.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postBySearchTermProvider =
    StreamProvider.family.autoDispose<Iterable<Post>, SearchTerm>(
  (ref, SearchTerm searchTerm) {
    final controller = StreamController<Iterable<Post>>();

    final sub = FirebaseFirestore.instance
        .collection(
          FirebaseCollectionName.posts,
        )
        .orderBy(FirebaseFieldName.createdAt, descending: true)
        .snapshots()
        .listen((snapshot) {
      final posts = snapshot.docs
          .map(
            (doc) => Post(
              postId: doc.id,
              json: doc.data(),
            ),
          )
          .where(
            (post) => post.message.toLowerCase().contains(
                  searchTerm.toLowerCase(),
                ),
          );

      controller.sink.add(posts);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);
