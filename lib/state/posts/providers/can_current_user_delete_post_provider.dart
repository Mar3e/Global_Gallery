import 'package:global_gallery/state/auth/providers/user_id_provider.dart';
import 'package:global_gallery/state/posts/models/post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final canCurrentUserDeletePostProvider =
    StreamProvider.family.autoDispose<bool, Post>(
  (ref, Post post) async* {
    final userId = ref.watch(userIdProvider);
    yield userId == post.userId;
  },
);
