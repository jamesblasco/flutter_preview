import 'package:flutter/rendering.dart';
import 'package:preview/src/utils.dart';

const PreviewPort = 8084;

extension PreviewImage on NetworkImage {
  static NetworkImage asset(String asset, {double scale}) {
    assert(debugAssertPreviewModeRequired('PreviewImage'));
    return NetworkImage('http://127.0.0.1:$PreviewPort/asset/$asset');
  }
}
