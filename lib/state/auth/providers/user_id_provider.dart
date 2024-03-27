import 'package:global_gallery/state/auth/providers/auth_state_provider.dart';
import 'package:global_gallery/state/posts/typedefs/user_id.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userIdProvider = Provider<UserId?>(
  (ref) => ref.watch(authStateProvider).userId,
);
