import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_dm_ui/chatPage/chatPageController.dart';
import 'package:just_dm_ui/common_widgets/commonWidgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatelessWidget {
  final controller = Get.put(ChatPageController());

  ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 102, 153),
          title: const Text(
            'Linket!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Obx(
          () {
            if (controller.apiResponse.value == "LOADING") {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.apiResponse.value == "PASS") {
              return buildContent();
            } else {
              return const Center(
                child: Text('Something went wrong. Please try again.'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildContent() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 950) {
          return ChatScreen(controller: controller);
        } else {
          return Container(
            child: buildMobileContent(),
          );
        }
      },
    );
  }

  Widget buildMobileContent() {
    return Container();
  }
}

class ChatScreen extends StatefulWidget {
  final ChatPageController controller;
  const ChatScreen({super.key, required this.controller});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textController = TextEditingController();
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io('http://localhost:7000',
        IO.OptionBuilder().setTransports(['websocket']).build());
    socket.on('connect', (_) {
      print('connected to server');
    });

    socket.on('receiveMessage', (data) {
      setState(() {
        messages.add(data);
      });
    });

    socket.on('disconnect', (_) {
      print('disconnected from server');
    });
  }

  void sendMessage(String text) {
    print("sending messages");
    final message = {'sender': 'user1', 'receiver': 'user2', 'text': text};
    socket.emit('sendMessage', message);
    setState(() {
      messages.add(message);
    });
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: ListView(
              children: widget.controller.chatList.map((chatUser) {
                return Column(
                  children: [
                    _buildChatUserTile(
                        roomId: chatUser.roomId,
                        name: chatUser.name,
                        lastMessage: chatUser.chatText,
                        timestamp: chatUser.chatDate,
                        unreadCount: 1
                        // chatUser.unreadCount,
                        ),
                    const Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 3,
          child: Obx(() {
            if (widget.controller.apiScreenResponse == "LOADING") {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (widget.controller.apiScreenResponse == "PASS") {
              return buildChatScreen();
            } else {
              return const SizedBox.shrink();
            }
          }),
        ),
      ],
    );
  }

  Widget buildChatScreen() {
    return Column(
      children: <Widget>[
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final message = widget.controller.chatMessageList[index];
                    return ChatMessage(
                        constraints: constraints,
                        text: message.chatText,
                        timestamp: message.chatDate,
                        isUser: message.sent // Placeholder for timestamp
                        );
                  },
                  itemCount: widget.controller.chatMessageList.length,
                ),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          color: Colors.white,
          child: ChatInputField(
            onSubmitted: (text) => sendMessage(text),
            controller: textController,
          ),
        ),
        Container(
          height: 10,
          color: Colors.white,
        )
      ],
    );
  }

  Widget _buildChatUserTile(
      {required int roomId,
      required String name,
      required String lastMessage,
      required String timestamp,
      required int unreadCount}) {
    return ListTile(
      onTap: () => widget.controller.fetchChatByRoom(roomId),
      leading: CircleAvatar(child: Text(name[0])),
      tileColor: Colors.white,
      hoverColor: Colors.white,
      title: Text(name),
      subtitle: Text(lastMessage),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 6),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10.0),
              ),
            ),
          5.verticalSpace,
          Text(timestamp),
        ],
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  ChatInputField({required this.onSubmitted, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(
          color: const Color.fromARGB(255, 216, 213, 213), // Border color
          width: 1.0, // Border width
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => onSubmitted(controller.text),
          ),
        ],
      ),
    );
  }
}

Widget ChatMessage({
  required BoxConstraints constraints,
  required String text,
  required String timestamp,
  required bool isUser,
}) {
  return Row(
    children: [
      if (isUser) Expanded(child: SizedBox.shrink()),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color.fromARGB(255, 0, 102, 153) : Colors.white,
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            color: const Color.fromARGB(255, 216, 213, 213), // Border color
            width: 1.0, // Border width
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    child: Text(
                      text,
                      style: TextStyle(
                          color: isUser ? Colors.white : Colors.blueGrey),
                    ),
                  ),
                ),
                30.horizontalSpace,
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    timestamp,
                    style: TextStyle(
                        fontSize: 10,
                        color: isUser
                            ? const Color.fromARGB(255, 219, 213, 213)
                            : const Color.fromARGB(255, 100, 100, 100)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
