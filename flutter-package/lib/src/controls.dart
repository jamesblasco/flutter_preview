



import 'package:flutter/material.dart';
import 'package:preview/src/persist.dart';

import 'preview_icons.dart';

class PreviewControls extends StatefulWidget {
  final PersistController controller;

  const PreviewControls({Key key, this.controller}) : super(key: key);
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
        if (!controller.isHotRestart)
          AnimatedContainer(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            duration: Duration(milliseconds: 200),
            child: IconButton(
                splashRadius: 12,
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
            splashRadius: 12,
            tooltip: controller.isHotRestart
                ? 'Disable Auto Hot Restart'
                : 'Enable Auto Hot Restart',
            iconSize: 12,
            padding: EdgeInsets.all(2),
            icon: Icon(Icons.play_arrow),
            onPressed: () =>
                setState(() => controller.isHotRestart = !controller.isHotRestart),
          ),
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
