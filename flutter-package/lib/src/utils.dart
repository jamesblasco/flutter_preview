extension IterableExtension<T> on Iterable<T> {
  Iterable<T> addInBetween(T item) sync* {
    if (length <= 1) {
      yield* this;
      return;
    }
    for (final widget in take(length - 1)) {
      yield widget;
      yield item;
    }
    yield last;
  }
}
