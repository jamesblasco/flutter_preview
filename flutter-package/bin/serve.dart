import 'dart:io';
import 'run.dart';



Future<void> main() async {
  final server = await HttpServer.bind('127.0.0.1', 8081);
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
