import 'package:flutter/material.dart';
import 'package:preview/preview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Overflow Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Demo(),
      ),
    );
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return ResizableWidget(
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white10,
        child: Text(
          '''I've just did simple prototype to show main idea.
  1. Draw size handlers with container;
  2. Use GestureDetector to get new variables of sizes
  3. Refresh the main container size.''',
          overflow: TextOverflow.fade,
      
          softWrap: true,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class WidgetPreview extends PreviewProvider {
  @override
  List<Preview> get previews => [
        Preview(
          height: 600,
          width: 700,
          frame: Frames.iphoneXR,
          child: MyApp(),
        )
      ];
}
