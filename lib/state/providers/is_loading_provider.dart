import 'package:global_gallery/state/auth/providers/auth_state_provider.dart';
import 'package:global_gallery/state/image_upload/providers/image_uploader_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUploaderProvider);

  return authState.isLoading || isUploadingImage;
});
