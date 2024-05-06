import 'package:global_gallery/enums/date_sorting_enum.dart';
import 'package:global_gallery/state/comments/models/comment.dart';
import 'package:global_gallery/state/comments/models/post_comment_request.dart';

extension Sorting on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(RequestForPostAndComments request) {
    if (request.sortByCreatedAt) {
      final sortedComments = toList()
        ..sort((a, b) {
          switch (request.dateSorting) {
            case DateSorting.newestOnTop:
              return b.createdAt.compareTo(a.createdAt);
            case DateSorting.oldestOnTop:
              return a.createdAt.compareTo(b.createdAt);
          }
        });

      return sortedComments;
    } else {
      return this;
    }
  }
}
