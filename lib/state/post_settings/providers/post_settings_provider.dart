import 'package:global_gallery/state/post_settings/models/post_settings.dart';
import 'package:global_gallery/state/post_settings/notifire/post_settings_notifire.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postSettingsProvider =
    StateNotifierProvider<PostSettingsNotifier, Map<PostSettings, bool>>(
  (ref) => PostSettingsNotifier(),
);
