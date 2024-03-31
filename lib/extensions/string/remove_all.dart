extension RemoveAll on String {
  String removeAll(Iterable<String> strings) => strings.fold(
        this,
        (result, pattern) => result.replaceAll(pattern, ''),
      );
}
