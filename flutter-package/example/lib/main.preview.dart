
import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';
import 'main.dart';  
void main() {
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      path: 'main.dart',
      providers: () => [
        IPhoneX(), 
        IPad(), 
        AllPreview(), 
        
      ],
    );
  }
}
  