import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:global_gallery/state/constants/firebase_collection_name.dart';
import 'package:global_gallery/state/constants/firebase_field_name.dart';
import 'package:global_gallery/state/image_upload/extension/get_collection_name_from_file_type.dart';
import 'package:global_gallery/state/image_upload/typedefs/is_loading.dart';
import 'package:global_gallery/state/posts/models/post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeletePostStateNotifier extends StateNotifier<IsLoading> {
  DeletePostStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deletePost({
    required Post post,
  }) async {
    try {
      isLoading = true;
      // delete the thumbnails
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectionName.thumbnails)
          .child(post.thumbnailStorageId)
          .delete();

      // delete the original file (video or image)

      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(post.fileType.collectionName)
          .child(post.originalFileStorageId)
          .delete();

      // delete all the comments associated with the post
      await _deleteAllDocuments(
        postId: post.postId,
        inCollection: FirebaseCollectionName.comments,
      );

      // delete all the likes associated with the post
      await _deleteAllDocuments(
        postId: post.postId,
        inCollection: FirebaseCollectionName.likes,
      );

      // delete the post itself
      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .where(FieldPath.documentId, isEqualTo: post.postId)
          .limit(1)
          .get();

      for (final doc in postInCollection.docs) {
        await doc.reference.delete();
      }

      return true;
    } catch (e) {
      log('something went wrong with delete the post reason: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDocuments({
    required String postId,
    required String inCollection,
  }) {
    return FirebaseFirestore.instance.runTransaction(
      maxAttempts: 3,
      timeout: const Duration(seconds: 20),
      (transaction) async {
        final query = await FirebaseFirestore.instance
            .collection(inCollection)
            .where(FirebaseFieldName.postId, isEqualTo: postId)
            .get();

        for (final doc in query.docs) {
          transaction.delete(doc.reference);
        }
      },
    );
  }
}
