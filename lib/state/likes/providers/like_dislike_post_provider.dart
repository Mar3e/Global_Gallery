import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_gallery/state/constants/firebase_field_name.dart';
import 'package:global_gallery/state/likes/models/like.dart';
import 'package:global_gallery/state/likes/models/like_dislike_request.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final likeDislikePostProvider =
    FutureProvider.family.autoDispose<bool, LikeDislikeRequest>(
  (ref, LikeDislikeRequest request) async {
    final query = FirebaseFirestore.instance
        .collection(FirebaseFieldName.like)
        .where(FirebaseFieldName.postId, isEqualTo: request.postId)
        .where(FirebaseFieldName.userId, isEqualTo: request.likedBy)
        .get();

    // check if there is a like by the user
    final hasLiked = await query.then(
      (snapshot) => snapshot.docs.isNotEmpty,
    );

    if (hasLiked) {
      // delete the like
      try {
        await query.then((snapshot) async {
          for (final doc in snapshot.docs) {
            doc.reference.delete();
          }
        });
        return true;
      } catch (e) {
        log('something went wrong with the dislike reason: $e');

        return false;
      }
    } else {
      // add a like
      final like = Like(
        postId: request.postId,
        likedBy: request.likedBy,
        date: DateTime.now(),
      );

      try {
        await FirebaseFirestore.instance
            .collection(FirebaseFieldName.like)
            .add(like);

        return true;
      } catch (e) {
        log('something went wrong with the like reason: $e');
        return false;
      }
    }
  },
);
