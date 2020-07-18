import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'preview.dart';

class DaemonService extends MultiplePeer {
  final int port;
  DaemonService(this.port);

  @override
  registerMethods(Peer server) {
    server.registerMethod('preview.getPort', () {
      return port;
    });

    server.registerMethod('preview.setActiveFile', (Parameters params) {
      final path = params['path'].asString;
      changeActiveFile(path);
      return true;
    });

    server.registerMethod('preview.restart', (Parameters params) {
      _server.sendNotification('preview.restart');
      return true;
    });
  }
}

class Stoutsink extends StreamSink<String> {
  @override
  void add(String event) {
    stdout.writeln(event);
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    stdout.addError(error, stackTrace);
  }

  @override
  Future addStream(Stream<String> stream) {
    return stdout.addStream(stream.transform(Utf8Encoder()));
  }

  @override
  Future close() {
    return stdout.close();
  }

  @override
  Future get done => stdout.close();
}

abstract class MultiplePeer {
  Peer _server;
  Map<WebSocketChannel, Peer> sockets = {};

  //StreamChannel<String> _socket;

  bool isListening = false;

  addWebSocket(WebSocketChannel webSocket) {
    assert(sockets[webSocket] == null);
    final peer = Peer(webSocket.cast<String>(), strictProtocolChecks: false);
    sockets[webSocket] = peer;
    registerMethods(peer);
    if (isListening) {
      peer.listen();
    }
  }

  removeWebSocket(WebSocketChannel webSocket) {
    final peer = sockets[webSocket];
    peer.close();
    sockets[webSocket] = null;
  }

  Future run() async {
    //  assert(port != null && webSocket != null);
    try {
      /*   _socket = webSocket ??
          WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:$port/ws'))
              .cast<String>(); */
    } catch (e, s) {
      stderr.addError(e, s);
    }

    final channel = StreamChannel<String>(
      stdin.transform(Utf8Decoder()).transform(LineSplitter()),
      Stoutsink(),
    );

    _server = Peer(channel, strictProtocolChecks: false,
        onUnhandledError: (error, stacktrace) {
      stdout.write('Error $error');
    });

    registerMethods(_server);
  }

  Future listen() async {
    isListening = true;
    for (final socket in sockets.entries) {
      socket.value.listen().then(
        (value) {
          removeWebSocket(socket.key);
        },
      );
    }
    return await _server.listen();
  }

  Future close() async {
    for (final peer in sockets.values) {
      await peer.close();
    }
    return _server.close();
  }

  /*  void registerMethod(String name, Function callback) =>
      _server.registerMethod(name, callback); */

  void sendNotification(String method, [dynamic parameters]) {
    _server.sendNotification(method, parameters);
    sockets.values.forEach((e) {
      e.sendNotification(method, parameters);
    });
  }

  registerMethods(Peer server);
}
