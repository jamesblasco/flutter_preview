import 'package:flutter/rendering.dart';

const PreviewPort = 8084;

extension PreviewImage on NetworkImage {
  static NetworkImage asset(String asset, {double scale}) {
    return NetworkImage('http://127.0.0.1:$PreviewPort/asset/$asset');
  }
}
