import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_dm_ui/chatPage/chatPageController.dart';
import 'package:just_dm_ui/common_widgets/commonWidgets.dart';
import 'package:just_dm_ui/responses/chatListResponse.dart';
import 'package:just_dm_ui/responses/chatResponse.dart';

class ChatPage extends StatelessWidget {
  final controller = Get.put(ChatPageController());

  ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linket',
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
          return ChatScreen(constraints: constraints);
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

  Widget ChatScreen({required BoxConstraints constraints}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Obx(
                () {
                  if (controller.selectedLeftPage.value == "CHAT") {
                    return buildChatList(boxHeight: constraints.maxHeight - 50);
                  }
                  if (controller.selectedLeftPage.value == "WALLET") {
                    return buildWalletPage(
                        boxHeight: constraints.maxHeight - 50);
                  }
                  if (controller.selectedLeftPage.value == "PROFILE") {
                    return buildProfilePage(
                        boxHeight: constraints.maxHeight - 50);
                  }
                  return (SizedBox.shrink());
                },
              ),
              Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.onLeftPageChange(page: "CHAT"),
                        child: Center(child: Text("Chat")),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            controller.onLeftPageChange(page: "WALLET"),
                        child: Center(child: Text("Wallet")),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            controller.onLeftPageChange(page: "PROFILE"),
                        child: Center(child: Text("Profile")),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 3,
          child: Obx(() {
            if (controller.apiScreenResponse.value == "LOADING") {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.apiScreenResponse.value == "PASS") {
              return buildChatScreen();
            } else {
              return const SizedBox.shrink();
            }
          }),
        ),
      ],
    );
  }

  Widget buildChatList({required boxHeight}) {
    return Container(
      height: boxHeight,
      color: Colors.white,
      child: ListView(
        children: controller.chatList.map((chatUser) {
          return Column(
            children: [
              _buildChatUserTile(chatUser: chatUser),
              const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildWalletPage({required boxHeight}) {
    return Container(
      height: boxHeight,
      color: Colors.white,
      child: Row(
        children: [Text("Your Current Balance : ₹")],
      ),
    );
  }

  Widget buildProfilePage({required boxHeight}) {
    return Container(
      height: boxHeight,
      color: Colors.white,
      child: Text("PROFILE"),
    );
  }

  Widget buildChatScreen() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Obx(() {
            // Access the observable list directly
            final messages = controller.chatMessageList;

            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: messages.length, // Use length of observable list
                itemBuilder: (context, index) {
                  return ChatMessageTile(chat: messages[index]);
                },
              ),
            );
          }),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          color: Colors.white,
          child: ChatInputField(
            onSubmitted: (text) => controller.sendMessage(),
            controller: controller.textController,
          ),
        ),
        Container(
          height: 10,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildChatUserTile({required ChatListUserData chatUser}) {
    return ListTile(
      onTap: () => controller.onChatTileClicked(chatUser: chatUser),
      leading: CircleAvatar(child: Text(chatUser.name[0])),
      tileColor: Colors.white,
      hoverColor: Colors.white,
      title: Text(chatUser.name),
      subtitle: Text(chatUser.chatText),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (chatUser.unreadCount > 0)
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
                chatUser.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10.0),
              ),
            ),
          5.verticalSpace,
          Text(chatUser.chatDate),
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
            icon: Icon(Icons.attach_file),
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

Widget ChatMessageTile({required ChatMessage chat}) {
  return Row(
    children: [
      if (chat.sent) Expanded(child: SizedBox.shrink()),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color:
              chat.sent ? const Color.fromARGB(255, 0, 102, 153) : Colors.white,
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
                  chat.sent ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    child: Text(
                      chat.chatText,
                      style: TextStyle(
                          color: chat.sent ? Colors.white : Colors.blueGrey),
                    ),
                  ),
                ),
                30.horizontalSpace,
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    chat.chatDate,
                    style: TextStyle(
                        fontSize: 10,
                        color: chat.sent
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
