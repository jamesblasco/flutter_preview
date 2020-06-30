import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'package:analyzer/dart/ast/visitor.dart';
import 'package:async/async.dart';

import 'hot_restart_server.dart';

final featureSet = FeatureSet.fromEnableFlags([
  'extension-methods',
  //'non-nullable',
]);

Future<void> main() async {
  Stream<StreamResponse> cmdLine = stdin
      .transform(Utf8Decoder())
      .transform(LineSplitter())
      .map((event) => StreamResponse(stdin: event));
  //final server = await HttpServer.bind('127.0.0.1', 8081);
  //Stream<StreamResponse> requests =
  //    server.map((event) => StreamResponse(request: event));

  //ProcessSignal.sigint.watch().listen((_) async => await server.close());

  final group = StreamGroup.merge([cmdLine]);

  await for (final response in group) {
    response.when(
      stdin: (file) {
        try {
          if (File(file).existsSync()) {
            generatePreview(file);
            // request.response.write('Hello, world');
          }
        } catch (e) {
          stdout.write(e);
          print(e);
        }
      },
      request: (request) async {
        final hotRestart = request.uri.queryParameters['hotrestart'] == 'true';

        if (hotRestart) {
          stdout.write('Needs restart\n');
          request.response.write('Needs restart\n');
        } else {
          request.response.write('No param found\n');
        }
        await request.response.close();
      },
    );
  }
}

class StreamResponse {
  final String stdin;
  final HttpRequest request;

  StreamResponse({
    this.stdin,
    this.request,
  });

  when({Function(String stdin) stdin, Function(HttpRequest request) request}) {
    if (this.stdin != null) stdin?.call(this.stdin);
    if (this.request != null) request?.call(this.request);
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
    final supportedExtended = 'PreviewProvider';
    final supportedMixin = 'Previewer';

    bool isExtended() {
      final extendedClass = node.extendsClause.superclass.toString();
      return supportedExtended == extendedClass;
    }

    bool isInMixin() {
      final item = node.withClause?.mixinTypes?.firstWhere(
        (c) {
          print(c.toString());
          return supportedMixin == c.toString();
        },
        orElse: () => null,
      );
      return item != null;
    }

    if (isExtended() || isInMixin()) {
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
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      path: '$import',
      providers: () => [
        ${providers.reversed.fold('', (p, e) => e + '(), \n        ' + p)}
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
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
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
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
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
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      child: Text('Select a file from /lib folder to see the preview 👀'),
    );
  }
}
  ''';
