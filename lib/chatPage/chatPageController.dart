import 'dart:async';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Linket/responses/chatListResponse.dart';
import 'package:Linket/responses/chatResponse.dart';
import 'package:Linket/responses/loginResponse.dart';
import 'package:Linket/responses/userResponse.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:Linket/config.dart';
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

class ChatPageController extends GetxController {
  final apiResponse = "LOADING".obs;
  final apiScreenResponse = "".obs;
  final selectedChatRoom = ChatListUserData.fromMap({}).obs;

  final TextEditingController textController = TextEditingController();

  final ScrollController scrollController = ScrollController();

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

  final selectedImage = "".obs;

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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
      print("message received---------------------------${data}");
      final chatMessage = ChatMessage.fromMap(data);

      chatMessageList.add(chatMessage);
      scrollToBottom();
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
      chatDate: DateFormat('dd MMM yy hh:mm a').format(DateTime.now()),
      sent: true,
    );

    chatMessageList.add(chatMessage);
    print('message  sent  -------${chatMessage}');
    textController.clear();
    imageUploadUrl.value = '';
    scrollToBottom();
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
            imageUploadUrl.value = '';
            chatList.addAll(chatListResponse.data);
            if (selectedChatWith.value.isNotEmpty) {
              final selectedChat =
                  chatList.where((e) => e.userName == selectedChatWith.value);
              if (selectedChat.isNotEmpty) {
                selectedChatRoom.value = selectedChat.first;
                await connectToServer();
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
    chatMessageList.value = <ChatMessage>[];
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
            imageUploadUrl.value = '';
            chatMessageList.addAll(chatListResponse.data);
            scrollToBottom();
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

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 9999,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void clearLocalStorage() {
    html.window.localStorage.clear();
  }

  void logout(BuildContext context) {
    clearLocalStorage();
    Navigator.pushNamed(context, '/landing');
  }

  copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(
            text:
                'Let\'s connect on Linket.Chat! It\'s a quick, easy, and secure platform for messaging. Join the conversation here: https://linket.chat/#/chatWith/${userData.value.userName}'))
        .then((_) {
      // Show a snackbar to inform the user that the text was copied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard!'),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  Future<void> uploadImageWeb() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement()
          ..accept = 'image/*'
          ..click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) {
        const SnackBar(
          content: Text("File Not Suported"),
        );
      }

      final file = files![0];
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((event) async {
        final bytes = reader.result as Uint8List;
        final now = DateTime.now().toUtc();
        final amzDate = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(now);
        final dateStamp = DateFormat("yyyyMMdd").format(now);
        final fileName =
            sanitizeFileName(file.name) + now.millisecondsSinceEpoch.toString();
        final url =
            'https://a6b745362f3f5270de18f317d2d63506.r2.cloudflarestorage.com/linket-files/$fileName';

        final canonicalHeaders =
            'host:${Uri.parse(url).host}\nx-amz-content-sha256:${sha256.convert(bytes).toString()}\nx-amz-date:$amzDate\n';
        const signedHeaders = 'host;x-amz-content-sha256;x-amz-date';
        final payloadHash = sha256.convert(bytes).toString();
        final canonicalRequest =
            'PUT\n${Uri.parse(url).path}\n\n$canonicalHeaders\n$signedHeaders\n$payloadHash';

        final credentialScope = '$dateStamp/auto/s3/aws4_request';
        final stringToSign =
            'AWS4-HMAC-SHA256\n$amzDate\n$credentialScope\n${sha256.convert(utf8.encode(canonicalRequest)).toString()}';

        final signature = Hmac(
                sha256,
                _getSignatureKey(
                    Config.bucketSecretKey, dateStamp, 'auto', 's3'))
            .convert(utf8.encode(stringToSign))
            .toString();
        final authorizationHeader =
            'AWS4-HMAC-SHA256 Credential=${Config.bucketAccessKey}/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature';

        // Debugging information
        print('Canonical Request: $canonicalRequest');
        print('String to Sign: $stringToSign');
        print('Signature: $signature');
        print('Authorization Header: $authorizationHeader');

        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Authorization': authorizationHeader,
            'x-amz-content-sha256': payloadHash,
            'x-amz-date': amzDate,
            'Content-Type': file.type,
          },
          body: bytes,
        );

        if (response.statusCode == 200) {
          imageUploadUrl.value =
              'https://pub-27ef948460e04665a808b1803176deb9.r2.dev/$fileName';
          const SnackBar(
            content: Text("Upload Success"),
          );
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          const SnackBar(
            content: Text("Upload Failed"),
          );
        }
      });
    });
  }

  List<int> _getSignatureKey(
      String key, String dateStamp, String regionName, String serviceName) {
    final kDate = Hmac(sha256, utf8.encode('AWS4$key'))
        .convert(utf8.encode(dateStamp))
        .bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(regionName)).bytes;
    final kService =
        Hmac(sha256, kRegion).convert(utf8.encode(serviceName)).bytes;
    return Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
  }

  String sanitizeFileName(String fileName) {
    // Replace all special characters and spaces with an underscore or any desired character.
    return fileName.replaceAll(RegExp(r'[^\w\s-]'), '_').replaceAll(' ', '_');
  }

  void launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
