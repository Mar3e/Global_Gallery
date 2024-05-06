import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:global_gallery/state/auth/providers/user_id_provider.dart';
import 'package:global_gallery/state/image_upload/models/file_type.dart';
import 'package:global_gallery/state/image_upload/models/thumbnail_request.dart';
import 'package:global_gallery/state/image_upload/providers/image_uploader_provider.dart';
import 'package:global_gallery/state/post_settings/models/post_settings.dart';
import 'package:global_gallery/state/post_settings/providers/post_settings_provider.dart';
import 'package:global_gallery/views/components/file_thumbnail_view.dart';
import 'package:global_gallery/views/constants/strings.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateNewPostView extends StatefulHookConsumerWidget {
  final File fileToPost;
  final FileType fileType;
  const CreateNewPostView({
    required this.fileToPost,
    required this.fileType,
    super.key,
  });

  @override
  ConsumerState<CreateNewPostView> createState() => _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest = ThumbnailRequest(
      file: widget.fileToPost,
      fileType: widget.fileType,
    );
    final postSettings = ref.watch(postSettingsProvider);
    final postController = useTextEditingController();
    final isPostButtonEnabled = useState(false);

    useEffect(() {
      void listener() {
        isPostButtonEnabled.value = postController.text.isNotEmpty;
      }

      postController.addListener(listener);

      return () {
        postController.removeListener(listener);
      };
    }, [postController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.createNewPost,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isPostButtonEnabled.value
                ? () async {
                    final userId = ref.read(userIdProvider);
                    //if there is no user then don't allow creating a post
                    if (userId == null) return;

                    final message = postController.text;
                    final isUploaded =
                        await ref.read(imageUploaderProvider.notifier).upload(
                              file: widget.fileToPost,
                              fileType: widget.fileType,
                              message: message,
                              postSettings: postSettings,
                              userId: userId,
                            );

                    if (isUploaded && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FileThumbnailView(
              thumbnailRequest: thumbnailRequest,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: postController,
                autofocus: true,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: Strings.pleaseWriteYourMessageHere,
                ),
              ),
            ),
            // load the post settings
            ...PostSettings.values.map(
              (postSetting) => ListTile(
                title: Text(postSetting.title),
                subtitle: Text(postSetting.description),
                trailing: Switch(
                  value: postSettings[postSetting] ?? false,
                  onChanged: (value) {
                    ref
                        .read(postSettingsProvider.notifier)
                        .setSetting(postSetting, value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
