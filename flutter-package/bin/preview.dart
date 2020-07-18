import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'daemon_service.dart';

import 'old/run.dart';
import 'templates.dart';
import 'utils.dart';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart' as route;
import 'package:shelf_web_socket/shelf_web_socket.dart' as ws;

import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';

class Server {
  HttpServer _server;

  Server(this.port);

  Future serve(Function(WebSocketChannel) websocketHandler) async {
    final router = route.Router()
      ..get('/ws', ws.webSocketHandler(websocketHandler))
      ..post('/screenshot', (shelf.Request request) async {
        final contentType = ContentType.parse(request.headers["content-type"]);
        final transformer =
            MimeMultipartTransformer(contentType.parameters['boundary']);

        final bodyStream = request.read();
        final parts = await transformer.bind(bodyStream).toList();
        var params;
        for (var part in parts) {
          HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);

          //final ContentType contentType = multipart.contentType;
          final contentDisposition = multipart.contentDisposition;
          final filename = contentDisposition.parameters['filename'];

          final content = multipart.cast<List<int>>();

          final filePath = "preview/screenshots/" + filename;

          if (!await Directory('preview').exists()) {
            await Directory('preview').create();
          }

          if (!await Directory('preview/screenshots').exists()) {
            await Directory('preview/screenshots').create();
          }

          IOSink sink = File(filePath).openWrite();
          await for (List<int> item in content) {
            sink.add(item);
          }
          await sink.flush();
          await sink.close();
        }

        return shelf.Response.ok(params.toString());
      });

    final shelf.Handler staticHandler = (shelf.Request request) {
      final urlPath = request.url.path;
      final isGet = request.method == 'GET';
      final isAsset = urlPath.startsWith('asset/');

      if (isGet && isAsset) {
        final path = urlPath.replaceFirst('asset/', '');
        return createFileHandler(path, url: urlPath)(request);
      } else {
        return shelf.Response.notFound('');
      }
    };

    shelf.Handler safeNotFoundHandler(shelf.Handler handler) {
      return (shelf.Request request) async {
        var resp = await handler(request);
        return Future.value(resp == null ? shelf.Response.notFound('') : resp);
      };
    }

    final cascade =
        shelf.Cascade().add(staticHandler).add(router.handler).handler;

    var handler = const shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addHandler(safeNotFoundHandler(cascade));

    _server = await io.serve(handler, '127.0.0.1', port);

    _server.defaultResponseHeaders.remove('x-frame-options', 'SAMEORIGIN');
  }

  final int port;
  InternetAddress get address => _server?.address;

  Future close() {
    return _server.close();
  }
}

void main() async {
  final localAddress = InternetAddress('127.0.0.1');
  final port = await getUnusedPort(localAddress);
  final daemonService = DaemonService(port);

  final server = Server(port);
  await server.serve((webSocket) {
    daemonService.addWebSocket(webSocket);
  });

  print('Preview running on http://${server.address.host}:${server.port}');

  await daemonService.run();

  ProcessSignal.sigint.watch().listen((_) async {
    print('onClose');
    await server.close();
    await daemonService.close();
    exit(0);
  });

  daemonService.listen();
  daemonService.sendNotification('preview.launch', {'port': port});
}

String activeFilePath;

void changeActiveFile(String _activeFilePath) {
  activeFilePath = _activeFilePath;
  generatePreview(activeFilePath);
}

void generatePreview(String filePath) {
  if (filePath == 'lib/main.preview.dart') {
    File('lib/main.preview.dart').writeAsStringSync(notSeeTemplate);
    return;
  }
  if (!filePath.startsWith('lib/')) {
    File('lib/main.preview.dart').writeAsStringSync(notInLibFormatTemplate);
    return;
  }
  if (!filePath.endsWith('.dart')) {
    File('lib/main.preview.dart').writeAsStringSync(notValidFormatTemplate);
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
}
