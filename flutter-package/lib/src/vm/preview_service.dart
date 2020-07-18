import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:preview/src/utils.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;

const kPreviewMode =
    bool.fromEnvironment('flutter.preview', defaultValue: false);

const kPreviewPort = int.fromEnvironment('preview.port');

String get previewAddress {
  if (defaultTargetPlatform == TargetPlatform.android) {
    // AVD uses '10.0.2.2' as an alias of '127.0.0.1'
    return '10.0.2.2';
  } else {
    return '127.0.0.1';
  }
}

class PreviewService {
  static final PreviewService _singleton = PreviewService._internal();

  factory PreviewService() {
    assert(debugAssertPreviewModeRequired());
    assert(debugPreviewPortRequired());
    return _singleton;
  }

  PreviewService._internal();

  StreamChannel<String> _socket;
  Peer _server;

  start() async {
    try {
      _socket = WebSocketChannel.connect(
              Uri.parse('ws://$previewAddress:$kPreviewPort/ws'))
          .cast<String>();

      _server = Peer(_socket.cast<String>(), strictProtocolChecks: false,
          onUnhandledError: (e, s) {
        print(e);
      });

      _server.listen();

      _server.sendNotification('preview.appAttached');

      final response = await _server.sendRequest('preview.getPort');

      print('port$response');
      print('Preview attached to deamon');
    } catch (e) {
      print(e);
    }
  }

  requestRestart() {
    _server.sendNotification('preview.restart');
  }

  String get _defaultFileName {
    final now = DateTime.now();
    return 'Preview ${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}.png';
  }

  saveScreenshot(Uint8List bytes, [String filename]) async {
    final uri = Uri.parse('http://$previewAddress:$kPreviewPort/screenshot');

    final request = new http.MultipartRequest("POST", uri);
    filename ??= _defaultFileName;
    var multipartFile = new http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: filename,
      contentType: http.MediaType('image', 'png'),
    );

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(Utf8Decoder()).listen((value) {
      print(value);
    });
    print('Saved $filename');
  }
}
