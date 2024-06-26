import 'package:global_gallery/state/auth/models/auth_state.dart';
import 'package:global_gallery/state/auth/notfires/auth_state_notifire.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
