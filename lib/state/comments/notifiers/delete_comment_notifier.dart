import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_gallery/state/comments/typedefs/comment_id.dart';
import 'package:global_gallery/state/constants/firebase_collection_name.dart';
import 'package:global_gallery/state/image_upload/typedefs/is_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeleteCommentNotifier extends StateNotifier<IsLoading> {
  DeleteCommentNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deleteComment({required CommentId commentId}) async {
    try {
      isLoading = true;

      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .where(
            FieldPath.documentId,
            isEqualTo: commentId,
          )
          .limit(1)
          .get();

      await query.then((queryData) async {
        for (final doc in queryData.docs) {
          await doc.reference.delete();
        }
      });

      return true;
    } catch (e) {
      log('some thing went wrong with deleting a comment reason :$e');
      return false;
    } finally {
      isLoading = false;
    }
  }
}
