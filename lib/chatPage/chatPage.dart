import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_dm_ui/chatPage/chatPageController.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildContent());
  }

  Widget buildContent() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 950) {
          return ChatMainScreen();
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

class ChatMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 102, 153),
        title: Text(
          'Linket!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textController = TextEditingController();
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];

  final controller = Get.put(ChatPageController());

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
              children: [
                _buildChatUserTile(
                    "Alex Linderson", "How are you today?", "2 min ago", 1),
                Divider(),
                _buildChatUserTile("Gagan Singh",
                    "Don't miss to attend the meeting.", "2 min ago", 3),
                _buildChatUserTile("Monica Roy",
                    "Don't miss to attend the meeting.", "2 min ago", 0),
                _buildChatUserTile("Jhon Abraham",
                    "Hey! Can you join the meeting?", "2 min ago", 2),
                _buildChatUserTile(
                    "Sabila Sayma", "How are you today?", "2 min ago", 1),
                _buildChatUserTile(
                    "John Borino", "Have a good day", "2 min ago", 3),
                _buildChatUserTile(
                    "Angel Dayna", "How are you today?", "2 min ago", 0),
              ],
            ),
          ),
        ),
        VerticalDivider(width: 1),
        Expanded(
          flex: 3,
          child: Column(
            children: <Widget>[
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20),
                      child: ListView.builder(
                        reverse: true,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return ChatMessage(
                            constraints: constraints,
                            text: message['text'],
                            sender: message['sender'],
                            timestamp: "08:25 AM", // Placeholder for timestamp
                          );
                        },
                        itemCount: messages.length,
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
          ),
        ),
      ],
    );
  }

  Widget _buildChatUserTile(
      String name, String lastMessage, String timestamp, int unreadCount) {
    return ListTile(
      leading: CircleAvatar(child: Text(name[0])),
      tileColor: Colors.white,
      hoverColor: Colors.white,
      title: Text(name),
      subtitle: Text(lastMessage),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(timestamp),
          if (unreadCount > 0)
            Container(
              margin: EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                unreadCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              ),
            ),
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
  required String sender,
  required String timestamp,
  bool isUser = false,
}) {
  return Container(
    width: 200,
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    padding: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 3,
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
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: isUser ? Colors.white : Colors.blueGrey),
                  ),
                ),
              ),
              SizedBox(width: 30),
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
        ),
      ],
    ),
  );
}
