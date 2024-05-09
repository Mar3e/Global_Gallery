import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_gallery/state/auth/providers/auth_state_provider.dart';
import 'package:global_gallery/state/image_upload/helpers/image_picker_helper.dart';
import 'package:global_gallery/state/image_upload/models/file_type.dart';
import 'package:global_gallery/state/post_settings/providers/post_settings_provider.dart';
import 'package:global_gallery/views/components/dialogs/alert_dialog_model.dart';
import 'package:global_gallery/views/components/dialogs/logout_dialog.dart';
import 'package:global_gallery/views/constants/strings.dart';
import 'package:global_gallery/views/create_new_posts/create_new_post_view.dart';
import 'package:global_gallery/views/tabs/search/search_view.dart';
import 'package:global_gallery/views/tabs/user_posts/user_posts_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainVIewState();
}

class _MainVIewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
          actions: [
            IconButton(
              onPressed: () async {
                final videoFile =
                    await ImagePickerHelper.pickVideoFromGallery();
                if (videoFile == null) return;

                //Refresh the post setting provider to remove the old post settings
                ref.invalidate(postSettingsProvider);

                if (!context.mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewPostView(
                      fileToPost: videoFile,
                      fileType: FileType.video,
                    ),
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.film),
            ),
            IconButton(
              onPressed: () async {
                final imageFile =
                    await ImagePickerHelper.pickImageFromGallery();
                if (imageFile == null) return;

                //Refresh the post setting provider to remove the old post settings
                ref.invalidate(postSettingsProvider);

                if (!context.mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewPostView(
                      fileToPost: imageFile,
                      fileType: FileType.image,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_photo_alternate_outlined),
            ),
            IconButton(
              onPressed: () async {
                final shouldLogout = await LogoutDialog()
                    .present(context)
                    .then((value) => value ?? false);
                if (shouldLogout) {
                  ref.read(authStateProvider.notifier).logOut();
                }
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.person,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.search,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.home,
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserPostsView(),
            SearchView(),
            UserPostsView(),
          ],
        ),
      ),
    );
  }
}
