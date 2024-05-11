import 'package:flutter/material.dart';
import 'package:global_gallery/state/posts/providers/post_by_search_term_provider.dart';
import 'package:global_gallery/views/components/animations/data_not_found_animation_view.dart';
import 'package:global_gallery/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:global_gallery/views/components/animations/error_animation_view.dart';
import 'package:global_gallery/views/components/animations/loading_animation_view.dart';
import 'package:global_gallery/views/components/post/posts_sliver_grid_view.dart';
import 'package:global_gallery/views/constants/strings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchGridView extends ConsumerWidget {
  final String searchTerm;
  const SearchGridView({
    super.key,
    required this.searchTerm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchTerm.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyContentsWithTextAnimationView(
          text: Strings.enterYourSearchTerm,
        ),
      );
    }

    final postBySearchTerm = ref.watch(
      postBySearchTermProvider(searchTerm),
    );

    return postBySearchTerm.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const SliverToBoxAdapter(
            child: DataNotFoundAnimationView(),
          );
        } else {
          return PostsSliverGridView(
            posts: posts,
          );
        }
      },
      error: (error, stackTrace) => const SliverToBoxAdapter(
        child: ErrorAnimationView(),
      ),
      loading: () => const SliverToBoxAdapter(
        child: LoadingAnimationView(),
      ),
    );
  }
}
