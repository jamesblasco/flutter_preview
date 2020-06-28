import 'dart:io';

import 'package:args/args.dart';

import 'package:analyzer/src/dart/ast/utilities.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:_fe_analyzer_shared/src/scanner/token.dart';
import 'package:dart_style/dart_style.dart';

import 'package:args/args.dart';
import 'dart:convert';

final featureSet = FeatureSet.fromEnableFlags([
  'extension-methods',
  //'non-nullable',
]);

void main(List<String> args) {
  final parser = ArgParser();

  parser.addOption('file', abbr: 'f', defaultsTo: '/lib/main.dart');
  final results = parser.parse(args);
  final file = results['file'];

  try {
    PreviewGenerator().generate(filePath: file);
  } catch (e) {
    stderr.writeln(
        'An error occurred while generating showcase widget inside ${file}\n');
    rethrow;
  }
}

class PreviewGenerator {
  PreviewGenerator();

  List<String> previewProviders = [];

  /// Add missing dependencies to pubspec.yaml
  ///
  void generate({String filePath = ''}) {
    final fileContent = File(filePath).readAsStringSync();

    final parseResult = parseString(
      content: fileContent,
      featureSet: featureSet,
      path: filePath,
      throwIfDiagnostics: false,
    );

    final unit = parseResult.unit;
    refactorImportDirectives('./../../lib/', unit);
    importPackageIfMissing('package:flutter/widgets.dart', unit);
    final v = ExtractPreviewsVisitor(this);
    unit.visitChildren(v);

    try {
      final formatter = new DartFormatter();
      final resut = formatter.format(unit.toSource());
      final fileContent = resut + '\n\n' + addPreviewCode(previewProviders);

      createFolderIfNeeded('.dart_tool');
      createFolderIfNeeded('.dart_tool/preview/');

      File('./.dart_tool/preview/main.preview.dart')
          .writeAsStringSync(fileContent);
    } catch (ex) {
      print('Error while formatting new file');
      rethrow;
    }
    print('Adding showcase to project succesfully');
  }
}

void createFolderIfNeeded(String folder) {
  if (!Directory(folder).existsSync()) Directory(folder).createSync();
}

class ExtractPreviewsVisitor extends RecursiveAstVisitor {
  final PreviewGenerator generator;

  ExtractPreviewsVisitor(this.generator);

  @override
  visitClassDeclaration(ClassDeclaration node) {
    if (node.extendsClause.superclass.toString() == 'PreviewProvider') {
      generator.previewProviders.add(node.name.toString());
    }
    return super.visitClassDeclaration(node);
  }
}

String addPreviewCode(List<String> providers) {
  return '''

  
void main() {
  runApp(_View());
}

class _View extends StatelessWidget {
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

///
///
void refactorImportDirectives(String path, CompilationUnit unit) {
  for (final directive in unit.directives) {
    if (directive is ImportDirective &&
        !directive.uri.toString().contains('package')) {
      final name = '\'$path${directive.uri.stringValue}\'';
      StringToken st = StringToken(
        TokenType.STRING,
        name,
        directive.offset,
      );
      final ssl = astFactory.simpleStringLiteral(st, name);
      directive.uri = ssl;
    }
  }
}

/// Add missing dependencies to pubspec.yaml
///
void importPackageIfMissing(String package, CompilationUnit unit) {
  final packageImport = 'import \'$package\';';
  if (!unit.toSource().contains(packageImport)) {
    // Offset of last import package
    final int offset = AstCloner().cloneNode(unit.directives.last).offset;

    final importToken = StringToken(
      TokenType.STRING,
      'import',
      offset,
    );
    final semiColonToken = StringToken(
      TokenType.STRING,
      ';',
      offset + packageImport.length - 1,
    );

    final packageString = '\'$package\'';
    StringToken st = StringToken(
      TokenType.STRING,
      packageString,
      offset + importToken.length,
    );
    final ssl = astFactory.simpleStringLiteral(st, packageString);
    final ImportDirective newDirectory = astFactory.importDirective(null, null,
        importToken, ssl, null, null, null, null, null, semiColonToken);

    unit.directives.add(newDirectory);
  }
}
