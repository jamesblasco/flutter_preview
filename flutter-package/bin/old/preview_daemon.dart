import 'dart:convert';
import 'package:path/path.dart' as path;

import 'dart:io';

import 'package:async/async.dart';

import '../utils.dart';
import 'run.dart';

class PreviewDaemonService {
  Stream<PreviewRequest> _requests;
  HttpServer _server;

  Future<void> start() async {
    final stinStream = getStindRequests();
    final succedd = await runServer();
    Stream<PreviewRequest> requests;
    if (succedd) {
      requests = _server.map((event) => PreviewRequest(request: event));
    }

    _requests = StreamGroup.merge([
      stinStream,
      if (requests != null) requests,
    ]);
  }

  Stream<PreviewRequest> getStindRequests() {
    return stdin
        .transform(Utf8Decoder())
        .transform(LineSplitter())
        .map((event) => StdinRequest(event));
  }

  Future<bool> runServer() async {
    try {
      final address = InternetAddress('127.0.0.1');
      final port = await getUnusedPort(address);
      print('Preview running on http://127.0.0.1:$port');
      _server = await HttpServer.bind(address, port);
      return true;
    } catch (e) {
      stdout.write('error');
      stdout.write(e);
      return false;
    }
  }

  Future<void> listen() async {
    await for (final request in _requests) {
      final methods = request.parse();
      for (final method in methods) {
        try {
          switch (method.name) {
            case 'preview.changeActiveFile':
              handleOnActiveFileChanged(method, request);
              break;
            default:
              stdout.write(
                  '[{"event": "preview.error", "result": {"message": "Method $method not found"}}]\n');
          }
        } catch (e) {
          stdout.write(
              '[{"event": "preview.error", "result": {"message": "Invalid request: $e"}}]\n');
        }
      }

      request.when(
        stdin: (file) {
          try {
            if (File(file).existsSync()) {
              generatePreview(file);
              //request.response.write('Hello, world');
            }
          } catch (e) {
            stdout.write('error');
            stdout.write(e);
            print(e);
          }
        },
        request: (request) async {
          if (request.uri.path.startsWith('/asset/')) {
            final File file =
                new File(request.uri.path.replaceFirst('/asset/', ''));

            if (file.existsSync()) {
              final raw = await file.readAsBytes();

              request.response.headers
                  .set('Content-Type', 'image/${path.extension(file.path)}');
              request.response.headers.set('Content-Length', raw.length);
              request.response.add(raw);
              request.response.close();
            } else {
              request.response.statusCode = HttpStatus.notFound;
              request.response.write('Not found');
            }
            await request.response.close();
            return;
          }

          final hotRestart =
              request.uri.queryParameters['hotrestart'] == 'true';

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

  Future<void> close() async {
    await _server.close();
  }

  void handleOnActiveFileChanged(
    DaemonMethod method,
    PreviewRequest request,
  ) {
    final path = method.params['path'];
    try {
      if (File(path).existsSync()) {
        generatePreview(path);
        //request.response.write('Hello, world');
      } else {
        request.sendResponse(
          '[{"event": "preview.error", "result": {"message: "File not found for path $path"}}]',
        );
      }
    } catch (e) {
      request.sendResponse(
        '[{"event": "preview.error", "result": {"message: "Error while generating preview $e"}}]',
      );
    }
  }
  // [{"method": "preview.changeActiveFile", "params": { "path": "lib/preview.dart"}}]
}

class PreviewRequest {
  final String stdin;
  final HttpRequest request;

  PreviewRequest({
    this.stdin,
    this.request,
  });

  when({
    Function(String stdin) stdin,
    Function(HttpRequest request) request,
  }) {
    if (this.stdin != null) stdin?.call(this.stdin);
    if (this.request != null) request?.call(this.request);
  }

  String getRequest() {
    return '';
  }

  void sendResponse(String response) {}

  List<DaemonMethod> parse() {
    final request = getRequest();
    try {
      final json = jsonDecode(request);
      print(json);

      return List.from(json).map(
        (e) {
          try {
            return DaemonMethod.fromJson(
              Map<String, dynamic>.from(e),
            );
          } catch (e) {
            throw 'Invalid parsing';
          }
        },
      ).toList();
    } catch (e) {
      stdout
          .write('[{"event": "preview.error", "result": {"message: "$e"}}]\n');
    }

    return [];
  }
}

class StdinRequest extends PreviewRequest {
  final String _request;

  StdinRequest(this._request);

  String getRequest() => _request;

  void sendResponse(String response) {
    stdout.write(response);
  }
}

class DaemonMethod {
  final String id;
  final String name;
  final Map<String, dynamic> params;

  DaemonMethod({this.id, this.name, this.params});

  factory DaemonMethod.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final method = json['method'];
    final params =
        json['params'] != null ? Map<String, dynamic>.from(json['params']) : {};
    return DaemonMethod(id: id, name: method, params: params);
  }
}
/* 

class DaemonResponse {
  final String id;
  final List<Map<String, dynamic> response;
  final Map<String, dynamic> args;
}


class DaemonEvent {
  final String id;
  final String name;
  final Map<String, dynamic> args;
} */
