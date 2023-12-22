extension IterableExtension<T> on Iterable<T> {
  Iterable<T> joinWithSeparator(T Function() buildSeparator) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return [];

    final list = [iterator.current];
    while (iterator.moveNext()) {
      list
        ..add(buildSeparator())
        ..add(iterator.current);
    }
    return list;
  }
}
