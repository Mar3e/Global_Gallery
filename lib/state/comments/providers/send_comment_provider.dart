import 'package:global_gallery/state/comments/notifiers/send_comment_notifier.dart';
import 'package:global_gallery/state/image_upload/typedefs/is_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sendCommentProvider =
    StateNotifierProvider<SendCommentNotifier, IsLoading>(
  (ref) => SendCommentNotifier(),
);
