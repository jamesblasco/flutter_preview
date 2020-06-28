import 'dart:io';
import 'package:analyzer/src/dart/ast/utilities.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:_fe_analyzer_shared/src/scanner/token.dart';
import 'package:dart_style/dart_style.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'run_old.dart';

Future<void> main() async {
  final server = await HttpServer.bind('127.0.0.1', 8082);
  await for (HttpRequest request in server) {
    final file = request.uri.queryParameters['file'];
    if (file != null) {
      try {
        generatePreview(file);
   // request.response.write('Hello, world');
        await request.response.close();
      } catch (e) {
        print(e);
        request.response.statusCode = HttpStatus.internalServerError;
        await request.response.close();
      }
    }
  }
}

void generatePreview(String filePath) {
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
}

class ExtractPreviewsVisitor extends RecursiveAstVisitor {
  final List<String> providers;

  ExtractPreviewsVisitor(this.providers);

  @override
  visitClassDeclaration(ClassDeclaration node) {
    if (node.extendsClause.superclass.toString() == 'PreviewProvider') {
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
    return  PreviewPage(
      providers: [
        ${providers.fold('', (p, e) => e + '(),' + p)}
      ],
    );
  }
}
  ''';
}
