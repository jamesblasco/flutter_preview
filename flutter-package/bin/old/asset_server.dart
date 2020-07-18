import 'dart:io';
import 'package:path/path.dart' as path;

final localAddress = InternetAddress('127.0.0.1');

class AssetServer {
  HttpServer _server;

  Future<bool> runServer(int port) async {
    try {
      _server = await HttpServer.bind(localAddress, port);
      return true;
    } catch (e, s) {
      stderr.addError(e, s);
      return false;
    }
  }

  Future<void> listen() async {
    await for (final request in _server) {
      try {
        if (request.uri.path.startsWith('/asset/')) {
          final File file =
              new File(request.uri.path.replaceFirst('/asset/', ''));

          if (file.existsSync()) {
            final raw = await file.readAsBytes();

            request.response.headers
                .set('Content-Type', 'image/${path.extension(file.path)}');
            request.response.headers.set('Content-Length', raw.length);
            request.response.add(raw);
            await request.response.close();
          } else {
            request.response.statusCode = HttpStatus.notFound;
            request.response.write('Not found');
            await request.response.close();
          }
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write('Not found');
          await request.response.close();
        }
      } catch (e, s) {
        stderr.addError(e, s);
        request.response.statusCode = HttpStatus.internalServerError;
        request.response.write('Internal Error');
        await request.response.close();
      }
    }
  }

  Future<void> close() async {
    await _server.close();
  }
}
