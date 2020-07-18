
import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';
import 'widgets/resizable.dart';  
void main() {
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      path: 'widgets/resizable.dart',
      providers: () => [
        WidgetPreview(), 
        
      ],
    );
  }
}
  