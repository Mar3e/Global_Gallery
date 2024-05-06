import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_gallery/state/comments/models/comment_payload.dart';
import 'package:global_gallery/state/constants/firebase_collection_name.dart';
import 'package:global_gallery/state/image_upload/typedefs/is_loading.dart';
import 'package:global_gallery/state/posts/typedefs/post_id.dart';
import 'package:global_gallery/state/posts/typedefs/user_id.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SendCommentNotifier extends StateNotifier<IsLoading> {
  SendCommentNotifier() : super(false);

  set isLoading(bool value) => state = value;
  Future<bool> sendComment({
    required UserId fromUserId,
    required PostId onPostId,
    required String comment,
  }) async {
    isLoading = true;

    final commentPayload = CommentPayload(
      fromUserId: fromUserId,
      onPostId: onPostId,
      comment: comment,
    );

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .add(commentPayload);

      return true;
    } catch (e) {
      log("something went wrong with sending a comment reason: $e");
      return false;
    } finally {
      isLoading = false;
    }
  }
}
