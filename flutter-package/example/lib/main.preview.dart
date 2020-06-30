
import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';
import 'widgets/card.dart';  
void main() {
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      path: 'widgets/card.dart',
      providers: () => [
        WidgetPreview(), 
        Resizable(), 
        
      ],
    );
  }
}
  