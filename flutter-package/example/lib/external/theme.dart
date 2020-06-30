import 'package:flutter/material.dart';
import 'package:preview/preview.dart';
import 'package:flutter_material_showcase/flutter_material_showcase.dart';

class ThemePreview extends StatelessWidget with Previewer {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data:
          ThemeData(primarySwatch: Colors.green, primaryColor: Colors.green[900]
              // accentColor: Colors.greenAccent
              ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Material Design Showcase'),
        ),
        body: SingleChildScrollView(
          child: MaterialShowcase(),
        ),
      ),
    );
  }
}
