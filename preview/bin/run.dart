import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'package:analyzer/dart/ast/visitor.dart';

import 'run_old.dart';



Future<void> main() async {
  Stream<String> cmdLine =
      stdin.transform(Utf8Decoder()).transform(LineSplitter());

  await for (String file in cmdLine) {
    try {
      if (File(file).existsSync()) {
        generatePreview(file);
        // request.response.write('Hello, world');
      }
    } catch (e) {
      print(e);
    }
  }
}

void generatePreview(String filePath) {
  if (filePath == 'lib/main.preview.dart') {
    File('lib/main.preview.dart').writeAsStringSync(notSeeTemplate);
    stdout.write('Needs reload\n');
    return;
  }
  if (!filePath.startsWith('lib/')) {
    File('lib/main.preview.dart').writeAsStringSync(notInLibFormatTemplate);
    stdout.write('Needs reload\n');
    return;
  }
  if (!filePath.endsWith('.dart')) {
    File('lib/main.preview.dart').writeAsStringSync(notValidFormatTemplate);
    stdout.write('Needs reload\n');
    return;
  }
  final fileContent = File(filePath).readAsStringSync();

  final parseResult = parseString(
    content: fileContent,
    featureSet: featureSet,
    path: filePath,
    throwIfDiagnostics: false,
  );
  final providers = <String>[];
  final unit = parseResult.unit;

  final v = ExtractPreviewsVisitor(providers);
  unit.visitChildren(v);
  File('lib/main.preview.dart')
      .writeAsStringSync(generateFile(filePath, providers));
  stdout.write('Needs reload\n');
}

class ExtractPreviewsVisitor extends RecursiveAstVisitor {
  final List<String> providers;

  ExtractPreviewsVisitor(this.providers);

  @override
  visitClassDeclaration(ClassDeclaration node) {
    final supportedProviders = ['ResizablePreviewProvider', 'PreviewProvider'];
    if (supportedProviders.contains(node.extendsClause.superclass.toString())) {
      providers.add(node.name.toString());
    }
    return super.visitClassDeclaration(node);
  }
}

String generateFile(String filePath, List<String> providers) {
  final import = filePath.replaceFirst('/lib/', '').replaceFirst('lib/', '');
  return '''

import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';
import '$import';  
void main() {
  runApp(PreviewApp());
}

class PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      path: '$filePath',
      providers: [
        ${providers.reversed.fold('', (p, e) => e + '(),' + p)}
      ],
    );
  }
}
  ''';
}

const String notSeeTemplate = '''

import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';

//
//  
//                            .............       
//                          ************          
//                       .************            
//                     ************               
//                  .************                 
//                ************                    
//             .************                      
//           ************                         
//         ************      ************         
//           *******      ,************           
//             .**      ////********              
//                   *////////****                
//                  ,//////////%%                 
//                     //////%%%%%%               
//                       ,%%%%%%%%%%%%            
//                          %%%%%%%%%%%%  
//
//
//
//

void main() {
  runApp(PreviewApp());
}

class PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      child: Text('You should not be editing this file 👀')
    );
  }
}
  ''';

const String notValidFormatTemplate = '''

import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';

void main() {
  runApp(PreviewApp());
}

class PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      child: Text('This format does not support preview 👀')
      );
  }
}
  ''';

const String notInLibFormatTemplate = '''

import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';

void main() {
  runApp(PreviewApp());
}

class PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      child: Text('Select a file from /lib folder to see the preview 👀'),
    );
  }
}
  ''';
