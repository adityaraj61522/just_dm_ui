import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_dm_ui/responses/chatListResponse.dart';
import 'package:just_dm_ui/responses/chatResponse.dart';
import 'package:just_dm_ui/responses/loginResponse.dart';
import 'package:just_dm_ui/responses/userResponse.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:just_dm_ui/config.dart';
import 'dart:html' as html;

class ChatPageController extends GetxController {
  final apiResponse = "LOADING".obs;
  final apiScreenResponse = "".obs;
  final selectedChatRoom = ChatListUserData.fromMap({}).obs;

  final TextEditingController textController = TextEditingController();
  final imageUploadUrl = ''.obs;

  final token = ''.obs;
  final userData = UserData.fromMap({}).obs;

  final selectedLeftPage = "CHAT".obs;

  var chatList = <ChatListUserData>[].obs;
  var chatMessageList = <ChatMessage>[].obs;

  final TextEditingController addAmountController = TextEditingController();
  final TextEditingController withdrawAmountController =
      TextEditingController();

  final selectedChatWith = "".obs;
  @override
  void onInit() async {
    super.onInit();
    token.value = getFromLocalStorage('auth_token') ?? 'NO_TOKEN';
    final userdata = getFromLocalStorage('user_data')!;
    final user = json.decode(userdata);
    userData.value = UserResponse.fromMap(user).userData;
    final chatWith = getFromLocalStorage('chatWith');
    if (chatWith != null && chatWith.isNotEmpty) {
      selectedChatWith.value = chatWith;
    }
    await fetchChatList();
  }

  String? getFromLocalStorage(String key) {
    return html.window.localStorage[key];
  }

  void onChatTileClicked({required ChatListUserData chatUser}) async {
    if (chatUser == selectedChatRoom.value) return; // Compare with .value
    selectedChatRoom.value = chatUser; // Assign with .value
    await connectToServer();
    await fetchChatByRoom();
  }

  final IO.Socket socket = IO.io(
      Config.socketBaseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .setExtraHeaders({'foo': 'bar'}) // optional
          .build()); // Replace with actual receiver's user ID

  connectToServer() {
    socket.on('connect', (_) {
      print('Connected to server');
      socket.emit('joinRoom', {
        'token': token.value,
        'roomId': selectedChatRoom.value.roomId,
        'senderId': userData.value.id,
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
      'senderId': userData.value.id,
      'receiverId': selectedChatRoom.value.userId,
      'chatText': textController.text,
      'chatImg': imageUploadUrl.value,
    };
    socket.emit('sendMessage', message);
    final chatMessage = ChatMessage(
      senderId: userData.value.id,
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
        'Content-Type': 'application/json',
        'token': token.value,
        'chatWith': selectedChatWith.value,
      };
      final response = await http.get(
          Uri.parse('${Config.apiBaseUrl}/api/getChatList'),
          headers: headers);
      if (response.statusCode == 200) {
        print(response.statusCode);
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var chatListResponse = ChatListResponse.fromMap(responseData);
          if (chatListResponse.code == 200 &&
              chatListResponse.status == "SUCCESS") {
            chatList.value = chatListResponse.data;
            if (selectedChatWith.value.isNotEmpty) {
              final selectedChat =
                  chatList.where((e) => e.userName == selectedChatWith.value);
              if (selectedChat.isNotEmpty) {
                selectedChatRoom.value = selectedChat.first;
                await fetchChatByRoom();
              }
            }
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

  fetchChatByRoom() async {
    apiScreenResponse.value = "LOADING";
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': token.value,
        'roomid': selectedChatRoom.value.roomId
      };
      final response = await http.get(
          Uri.parse('${Config.apiBaseUrl}/api/getChatsByRoomId'),
          headers: headers);
      if (response.statusCode == 200) {
        print(response.statusCode);
        apiScreenResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var chatListResponse = ChatResponse.fromMap(responseData);
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

  void onLeftPageChange({required String page}) {
    if (page == selectedLeftPage.value) return;
    selectedLeftPage.value = page;
  }

  void onLoadWalletButtonClicked() async {
    apiResponse.value = "LOADING";
    try {
      final response = await http
          .get(Uri.parse('${Config.apiBaseUrl}/api/addBalance'), headers: {
        'token': token.value,
        'amount': addAmountController.text,
      });

      if (response.statusCode == 200) {
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var loginResponse = LoginResponse.fromMap(responseData);
          if (loginResponse.code == 200 && loginResponse.status == "SUCCESS") {
            getUserData();
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

  void onWithdrawWalletButtonClicked() async {
    apiResponse.value = "LOADING";
    try {
      final response = await http
          .get(Uri.parse('${Config.apiBaseUrl}/api/withdrawBalance'), headers: {
        'token': token.value,
        'amount': withdrawAmountController.text,
      });

      if (response.statusCode == 200) {
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var loginResponse = LoginResponse.fromMap(responseData);
          if (loginResponse.code == 200 && loginResponse.status == "SUCCESS") {
            getUserData();
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

  void getUserData() async {
    apiResponse.value = "LOADING";
    try {
      final response = await http.get(
        Uri.parse('${Config.apiBaseUrl}/api/getUserDetails'),
        headers: {
          "token": token.value,
        },
      );

      if (response.statusCode == 200) {
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var userResponse = UserResponse.fromMap(responseData);
          if (userResponse.code == 200 && userResponse.status == "SUCCESS") {
            await saveToLocalStorage('user_data', response.body);
            userData.value = userResponse.userData;
          } else {
            apiResponse.value = "FAILED";
            print("Something is wrong!!!!!!!");
            print(userResponse);
          }
        } else {
          apiResponse.value = "FAILED";
          print("response is blank");
        }
      } else {
        apiResponse.value = "FAILED";
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (error) {
      apiResponse.value = "FAILED";
      print("Error: $error");
    }
  }

  saveToLocalStorage(String key, String value) {
    html.window.localStorage[key] = value;
  }

  payToUnlockChat() async {
    apiScreenResponse.value = "LOADING";
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': token.value,
        'roomid': selectedChatRoom.value.roomId
      };
      final response = await http.get(
          Uri.parse('${Config.apiBaseUrl}/api/payToUnlockChat'),
          headers: headers);
      if (response.statusCode == 200) {
        print(response.statusCode);
        apiScreenResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var payChatResponse = LoginResponse.fromMap(responseData);
          if (payChatResponse.code == 200 &&
              payChatResponse.status == "SUCCESS") {
            fetchChatList();
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
