import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../preview.dart';

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

class MultipleSink<T> extends StreamSink<T> {
  final Iterable<StreamSink<T>> _sinks;

  MultipleSink([this._sinks = const []]);

  @override
  void add(T event) {
    _sinks.forEach((sink) => sink.add(event));
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    _sinks.forEach((sink) => sink.addError(error, stackTrace));
  }

  @override
  Future addStream(Stream<T> stream) async {
    for (final sink in _sinks) {
      await sink.addStream(stream);
    }
  }

  @override
  Future close() async {
    for (final sink in _sinks) {
      await sink.close();
    }
  }

  @override
  Future get done => Future.wait(_sinks.map((e) => e.done));
}

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

    final stream = StreamGroup.merge<String>([
      //   _socket.stream,
      stdin.transform(Utf8Decoder()).transform(LineSplitter())
    ]);

    final channel = StreamChannel<String>(
      stream,
      MultipleSink([
        //    _socket.sink,
        Stoutsink(),
      ]),
    );

    _server = Peer(channel, strictProtocolChecks: false,
        onUnhandledError: (error, stacktrace) {
      stdout.write('Error $error');
    });

    // Any string may be used as a method name. JSON-RPC 2.0 methods are
    // case-sensitive.
    var i = 0;
    _server.registerMethod('count', () {
      // Just return the value to be sent as a response to the client. This can
      // be anything JSON-serializable, or a Future that completes to something
      // JSON-serializable.
      return i++;
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
