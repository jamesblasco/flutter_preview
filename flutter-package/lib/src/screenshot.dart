import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Screenshottable extends StatefulWidget {
  final Widget child;
  final ScreenshotController controller;

  const Screenshottable({Key key, this.child, this.controller})
      : super(key: key);
  @override
  _ScreenshottableState createState() => _ScreenshottableState();
}

class _ScreenshottableState extends State<Screenshottable> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: widget.controller._key, child: widget.child);
  }
}

class ScreenshotController {
  final _key = GlobalKey();

  ScreenshotSettings settings = ScreenshotSettings();

  Future<Uint8List> takeScreenshot() async {
    RenderRepaintBoundary boundary = _key.currentContext.findRenderObject();
    final image = await boundary.toImage(pixelRatio: settings.pixelRatio);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }
}

class ScreenshotSettings {
  final double pixelRatio;
  final String filename;

  ScreenshotSettings({this.filename, double pixelRatio})
      : assert(filename == null || filename.endsWith('.png'),
            'Screenshot filename must have the extension .png'),
        this.pixelRatio = pixelRatio ?? window.devicePixelRatio;

  ScreenshotSettings copyWith({String filename, double pixelRatio}) {
    return ScreenshotSettings(
        filename: filename ?? this.filename,
        pixelRatio: pixelRatio ?? this.pixelRatio);
  }
}
