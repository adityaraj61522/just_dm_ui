import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatPageController
    extends GetxController {
 
  late IO.Socket socket;

  @override
  void onInit() {
    super.onInit();
    
connectToServer();
sendMessage("fhvhgvfhjjv");
  }

  void connectToServer() {
    socket = IO.io('http://localhost:7000', IO.OptionBuilder().setTransports(['websocket']).build());
    socket.on('connect', (_) {
      print('connected to server');
    });

socket.on('connect_error', (error) {
  print('Connection error: $error');
});


    socket.on('testEvent', (data) {
      print('Received from server: $data');
    });

    socket.on('receiveMessage', (data) {
      print(data);
    });
  }

  void sendMessage(String text) {
    final message = {'sender': 'user1', 'receiver': 'user2', 'text': text};
    socket.emit('sendMessage', message);
      print(message);
  }
}
