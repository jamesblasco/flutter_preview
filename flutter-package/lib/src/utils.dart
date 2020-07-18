import 'package:preview/src/vm/preview_service.dart';

bool debugAssertPreviewModeRequired([dynamic t]) {
  assert(() {
    if (!kPreviewMode) throw PreviewModeRequiredException(t);
    return true;
  }());
  return true;
}

bool debugPreviewPortRequired([dynamic t]) {
  assert(() {
    if (kPreviewPort == null) throw PreviewPortRequiredException(t);
    return true;
  }());
  return true;
}

class PreviewPortRequiredException implements Exception {
  final dynamic t;
  const PreviewPortRequiredException([this.t]);
  @override
  String toString() =>
      'Preview port is required for using this widget ${t ?? ''}. \n'
      'You should not used it inside your app';
}

class PreviewModeRequiredException implements Exception {
  final dynamic t;
  const PreviewModeRequiredException([this.t]);
  @override
  String toString() =>
      'Preview mode is required for using this widget ${t ?? ''}. \n'
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
