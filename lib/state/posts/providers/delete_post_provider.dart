import 'package:global_gallery/state/image_upload/typedefs/is_loading.dart';
import 'package:global_gallery/state/posts/notifier/delete_post_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostStateNotifier, IsLoading>(
  (ref) => DeletePostStateNotifier(),
);
