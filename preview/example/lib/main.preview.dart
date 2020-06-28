
import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';
import 'main.dart';  
void main() {
  runApp(PreviewApp());
}

class PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      path: 'lib/main.dart',
      providers: [
        WidgetPreview(),
      ],
    );
  }
}
  