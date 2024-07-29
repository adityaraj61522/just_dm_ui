import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_dm_ui/responses/chatListResponse.dart';
import 'package:just_dm_ui/responses/chatResponse.dart';

class ChatPageController extends GetxController {
  final apiResponse = "LOADING".obs;
  final apiScreenResponse = "".obs;
  final selectedChatRoom = 0.obs;

  var chatList = <ChatListUserData>[].obs;
  var chatMessageList = <ChatMessage>[].obs;

  @override
  void onInit() async {
    super.onInit();

    await fetchChatList();
  }

  fetchChatList() async {
    apiResponse.value = "LOADING";
    try {
      final Map<String, String> headers = {
        'token': 'BYPASS',
        'userid': '1',
      };
      final response = await http.get(
          Uri.parse('http://localhost:7000/api/getChatList'),
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

  fetchChatByRoom(int roomId) async {
    if (selectedChatRoom.value == roomId) return;
    selectedChatRoom.value = roomId;
    apiScreenResponse.value = "LOADING";
    try {
      final Map<String, String> headers = {
        'token': 'BYPASS',
        'roomid': selectedChatRoom.value.toString(),
        'userid': 1.toString()
      };
      final response = await http.get(
          Uri.parse('http://localhost:7000/api/getChatsByUserId'),
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
