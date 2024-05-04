import 'dart:collection';

import 'package:global_gallery/state/post_settings/models/post_settings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostSettingsNotifier extends StateNotifier<Map<PostSettings, bool>> {
  PostSettingsNotifier()
      : super(
          UnmodifiableMapView(
            {
              for (final setting in PostSettings.values) setting: true,
            },
          ),
        );

  void setSetting(PostSettings setting, bool value) {
    final existingValue = state[setting];
    if (existingValue == null || existingValue == value) {
      return;
    }

    state = Map.unmodifiable(
      Map.from(state)..[setting] = value,
    );
  }
}
