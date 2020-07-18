import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:preview/src/persist.dart';
import 'package:preview/src/screenshot.dart';
import 'package:preview/src/utils.dart';
import 'package:preview/src/vm/preview_service.dart';

import 'preview_icons.dart';

class PreviewControls extends StatefulWidget {
  final PersistController controller;
  final ScreenshotController screenshotController;

  PreviewControls({Key key, this.controller, this.screenshotController})
      : assert(debugAssertPreviewModeRequired(runtimeType)),
        super(key: key);
  @override
  _PreviewControlsState createState() => _PreviewControlsState();
}

class _PreviewControlsState extends State<PreviewControls> {
  PersistController get controller => widget.controller;

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scene.toImage is not implemented for web
        // Screenshot is disable for web until this is implemented
        // https://github.com/flutter/flutter/issues/42767
        if (!kIsWeb)
          AnimatedContainer(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            duration: Duration(milliseconds: 200),
            child: IconButton(
                // splashRadius: 12,
                tooltip: 'Screenshot',
                iconSize: 10,
                padding: EdgeInsets.all(2),
                icon: Icon(
                  Icons.photo_camera,
                  color: Colors.white.withOpacity(0.8),
                ),
                onPressed: () async {
                  final controller = widget.screenshotController;
                  final image = await controller.takeScreenshot();
                  print('done');
                  try {
                    PreviewService()
                        .saveScreenshot(image, controller.settings.filename);
                  } catch (e, s) {
                    log('fail', error: e, stackTrace: s);
                  }
                }),
          ),
        SizedBox(height: 8),
        if (!controller.isHotRestart)
          AnimatedContainer(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            duration: Duration(milliseconds: 200),
            child: IconButton(
                // splashRadius: 12,
                tooltip: 'Hot restart',
                iconSize: 12,
                padding: EdgeInsets.all(2),
                icon: Icon(
                  PreviewIcons.lightning_bolt,
                  color: Colors.yellow[600],
                ),
                onPressed: () => controller.restart()),
          ),
        SizedBox(height: 8),
        AnimatedContainer(
          height: 20,
          decoration: BoxDecoration(
              color: controller.isHotRestart ? Colors.blue : Colors.grey,
              shape: BoxShape.circle),
          duration: Duration(milliseconds: 200),
          child: IconButton(
              // splashRadius: 12, Not on master yet
              tooltip: controller.isHotRestart
                  ? 'Disable Auto Hot Restart'
                  : 'Enable Auto Hot Restart',
              iconSize: 12,
              padding: EdgeInsets.all(2),
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                setState(
                    () => controller.isHotRestart = !controller.isHotRestart);
              }),
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.removeListener(update);
    super.dispose();
  }
}
