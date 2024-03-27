import 'package:global_gallery/state/auth/models/auth_results.dart';
import 'package:global_gallery/state/auth/providers/auth_state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isLoggedInProvider = Provider<bool>(
  (ref) {
    final authProvider = ref.watch(authStateProvider);
    return authProvider.result == AuthResults.success;
  },
);
