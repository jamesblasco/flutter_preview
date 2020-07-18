import 'dart:async';

import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'package:analyzer/dart/ast/visitor.dart';


import 'preview_daemon.dart';
import '../templates.dart';

final featureSet = FeatureSet.fromEnableFlags([
  'extension-methods',
  //'non-nullable',
]);

Future<void> main() async {
  final daemon = PreviewDaemonService();
  await daemon.start();
  ProcessSignal.sigint.watch().listen((_) async {
    print('onClose');
    await daemon.close();
    exit(0);
  });
  await daemon.listen();
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
      final extendedClass = node.extendsClause?.superclass?.toString();
      return supportedExtended == extendedClass;
    }

    bool isInMixin() {
      final item = node.withClause?.mixinTypes?.firstWhere(
        (c) {
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
