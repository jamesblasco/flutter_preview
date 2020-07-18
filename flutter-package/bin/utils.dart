import 'dart:io';

Future<int> getUnusedPort(InternetAddress address) {
  return ServerSocket.bind(address ?? InternetAddress.anyIPv4, 0)
      .then((socket) {
    var port = socket.port;
    socket.close();
    return port;
  });
}
