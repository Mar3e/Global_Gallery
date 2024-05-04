import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:global_gallery/state/constants/firebase_collection_name.dart';
import 'package:global_gallery/state/image_upload/extension/get_collection_name_from_file_type.dart';
import 'package:global_gallery/state/posts/models/post_payload.dart';

import 'package:image/image.dart' as img;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:uuid/uuid.dart';

import 'package:global_gallery/state/image_upload/constants/constants.dart';
import 'package:global_gallery/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:global_gallery/state/image_upload/extension/get_image_data_aspect_ratio.dart';
import 'package:global_gallery/state/image_upload/models/file_type.dart';
import 'package:global_gallery/state/image_upload/typedefs/is_loading.dart';
import 'package:global_gallery/state/post_settings/models/post_settings.dart';
import 'package:global_gallery/state/posts/typedefs/user_id.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostSettings, bool> postSettings,
    required UserId userId,
  }) async {
    isLoading = true;

    late Uint8List thumbnailUint8List;

    switch (fileType) {
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());

        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }

        final thumbnail = img.copyResize(
          fileAsImage,
          width: Constants.imageThumbnailWidth,
        );

        final thumbnailData = img.encodeJpg(thumbnail);

        thumbnailUint8List = Uint8List.fromList(thumbnailData);
      case FileType.video:
        final videoThumbnail = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: Constants.videoTHumbnailMaxHight,
          quality: Constants.videoThumbnailQuality,
        );

        if (videoThumbnail == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        } else {
          thumbnailUint8List = videoThumbnail;
        }
        break;
    }
    // calculate the aspect ratio
    final thumbnailAspectRatio = await thumbnailUint8List.getAspectRation();

    // calculate reference
    final fileName = const Uuid().v4();

    // create references to the thumbnail and image itself
    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);

    try {
      //Upload the thumbnail
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      //Upload the original file
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      //Upload the post itself
      final PostPayload postPayload = PostPayload(
        userId: userId,
        message: message,
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileType: fileType.name,
        fileName: fileName,
        aspectRatio: thumbnailAspectRatio,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalFileStorageId,
        postSettings: postSettings,
      );
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayload);

      return true;
    } catch (e) {
      log("failed to load data to database reason: $e");
      return false;
    } finally {
      isLoading = false;
    }
  }
}
