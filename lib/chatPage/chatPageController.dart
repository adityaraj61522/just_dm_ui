import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_dm_ui/responses/chatListResponse.dart';
import 'package:just_dm_ui/responses/chatResponse.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:just_dm_ui/config.dart';

class ChatPageController extends GetxController {
  final apiResponse = "LOADING".obs;
  final apiScreenResponse = "".obs;
  final selectedChatRoom = ChatListUserData.fromJson({}).obs;

  final TextEditingController textController = TextEditingController();
  final imageUploadUrl = ''.obs;

  final loggedInUserId = 1;

  var chatList = <ChatListUserData>[].obs;
  var chatMessageList = <ChatMessage>[].obs;
  @override
  void onInit() async {
    super.onInit();
    await fetchChatList();
  }

  void onChatTileClicked({required ChatListUserData chatUser}) async {
    if (chatUser == selectedChatRoom.value) return; // Compare with .value
    selectedChatRoom.value = chatUser; // Assign with .value
    await connectToServer();
    await fetchChatByRoom(roomId: chatUser.roomId);
  }

  final IO.Socket socket = IO.io(
      'http://192.168.0.202:7000',
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .setExtraHeaders({'foo': 'bar'}) // optional
          .build()); // Replace with actual receiver's user ID

  connectToServer() {
    socket.on('connect', (_) {
      print('Connected to server');
      socket.emit('joinRoom', {
        'roomId': selectedChatRoom.value.roomId,
        'senderId': 1,
        'receiverId': selectedChatRoom.value.userId,
      });
    });

    socket.on('receiveMessage', (data) {
      chatMessageList.add(data);
    });

    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });
    socket.connect();
  }

  void sendMessage() {
    final message = {
      'roomId': selectedChatRoom.value.roomId,
      'senderId': loggedInUserId,
      'receiverId': selectedChatRoom.value.userId,
      'chatText': textController.text,
      'chatImg': imageUploadUrl.value,
    };
    socket.emit('sendMessage', message);
    final chatMessage = ChatMessage(
      senderId: loggedInUserId,
      receiverId: selectedChatRoom.value.userId,
      chatText: textController.text,
      chatImg: imageUploadUrl.value,
      chatDate: DateTime.now().toString(),
      sent: true,
    );

    chatMessageList.add(chatMessage);
    textController.clear();
  }

  fetchChatList() async {
    apiResponse.value = "LOADING";
    try {
      final Map<String, String> headers = {
        'token': 'BYPASS',
        'userid': '1',
      };
      final response = await http.get(
          Uri.parse(Config.apiBaseUrl + '/api/getChatList'),
          headers: headers);
      if (response.statusCode == 200) {
        print(response.statusCode);
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var chatListResponse = ChatListResponse.fromJson(responseData);
          if (chatListResponse.code == 200 &&
              chatListResponse.status == "SUCCESS") {
            chatList.value = chatListResponse.data;
          } else {
            apiResponse.value = "FAILED";
          }
        } else {
          apiResponse.value = "FAILED";
        }
      } else {
        apiResponse.value = "FAILED";
      }
    } catch (error) {
      apiResponse.value = "FAILED";
    }
  }

  fetchChatByRoom({required int roomId}) async {
    apiScreenResponse.value = "LOADING";
    try {
      final Map<String, String> headers = {
        'token': 'BYPASS',
        'roomid': selectedChatRoom.value.roomId.toString(),
        'userid': 1.toString()
      };
      final response = await http.get(
          Uri.parse(Config.apiBaseUrl + '/api/getChatsByUserId'),
          headers: headers);
      if (response.statusCode == 200) {
        print(response.statusCode);
        apiScreenResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var chatListResponse = ChatResponse.fromJson(responseData);
          if (chatListResponse.code == 200 &&
              chatListResponse.status == "SUCCESS") {
            chatMessageList.value = chatListResponse.data;
          } else {
            apiScreenResponse.value = "FAILED";
          }
        } else {
          apiScreenResponse.value = "FAILED";
        }
      } else {
        apiScreenResponse.value = "FAILED";
      }
    } catch (error) {
      apiScreenResponse.value = "FAILED";
    }
  }
}
