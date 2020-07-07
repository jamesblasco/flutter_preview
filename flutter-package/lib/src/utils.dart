

const kPreviewMode = bool.fromEnvironment('flutter.preview', defaultValue: false);

bool debugAssertPreviewModeRequired([dynamic t]) {
  assert(() {
    if (!kPreviewMode) throw PreviewModeRequiredException(t);
    return true;
  }());
  return true;
}

class PreviewModeRequiredException implements Exception {
  final dynamic t;
  const PreviewModeRequiredException([this.t]);
  @override
  String toString() => 'Preview mode is required for using this widget ${t ??''}. \n'
      'You should not used it inside your app';
}

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
