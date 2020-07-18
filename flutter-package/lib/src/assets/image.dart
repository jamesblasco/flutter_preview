import 'package:flutter/rendering.dart';
import 'package:preview/src/utils.dart';
import 'package:preview/src/vm/preview_service.dart';

extension PreviewImage on NetworkImage {
  static NetworkImage asset(String asset, {double scale}) {
    assert(debugAssertPreviewModeRequired('PreviewImage'));
    assert(debugPreviewPortRequired('PreviewImage'));
    return NetworkImage('http://$previewAddress:$kPreviewPort/asset/$asset');
  }
}
