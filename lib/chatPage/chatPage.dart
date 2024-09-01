import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Linket/chatPage/chatPageController.dart';
import 'package:Linket/common_widgets/commonWidgets.dart';
import 'package:Linket/responses/chatListResponse.dart';
import 'package:Linket/responses/chatResponse.dart';

class ChatPage extends StatelessWidget {
  final controller = Get.put(ChatPageController());

  ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linket.chat!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 128, 128),
          toolbarHeight: 60,
          centerTitle: true,
          leadingWidth: 150,
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: InkWell(
              onTap: () => controller.copyLink(context),
              child: Row(
                children: [
                  10.horizontalSpace,
                  const Icon(Icons.share, color: Colors.white),
                  10.horizontalSpace,
                  const Text(
                    "Share Link",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          title: Row(
            children: [
              const Spacer(),
              const Text(
                'Linket.chat!',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              const Spacer(),
              InkWell(
                onTap: () => controller.logout(context),
                child: Row(
                  children: [
                    const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    10.horizontalSpace,
                    const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    10.horizontalSpace,
                  ],
                ),
              )
            ],
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
          return Container(
              color: const Color.fromARGB(255, 0, 128, 128),
              child: chatScreen(constraints: constraints));
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

  Widget chatScreen({required BoxConstraints constraints}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Stack(
            children: [
              Obx(
                () {
                  if (controller.selectedLeftPage.value == "CHAT") {
                    return buildChatList(constraints: constraints);
                  }
                  if (controller.selectedLeftPage.value == "WALLET") {
                    return buildWalletPage(constraints: constraints);
                  }
                  if (controller.selectedLeftPage.value == "PROFILE") {
                    return buildProfilePage(constraints: constraints);
                  }
                  return (const SizedBox.shrink());
                },
              ),
              Positioned(
                top: constraints.maxHeight - 70,
                left: 70,
                right: 70,
                bottom: 30,
                child: Obx(
                  () {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50))),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () =>
                                  controller.onLeftPageChange(page: "CHAT"),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                    color: controller.selectedLeftPage.value ==
                                            "CHAT"
                                        ? const Color.fromARGB(255, 0, 128, 128)
                                        : Colors.white),
                                child: Center(
                                    child: Icon(
                                  Icons.chat,
                                  color: controller.selectedLeftPage.value ==
                                          "CHAT"
                                      ? Colors.white
                                      : Colors.black,
                                )),
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: InkWell(
                          //     onTap: () =>
                          //         controller.onLeftPageChange(page: "WALLET"),
                          //     child: Center(child: Text("Wallet")),
                          //   ),
                          // ),
                          Expanded(
                            child: InkWell(
                              onTap: () =>
                                  controller.onLeftPageChange(page: "PROFILE"),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                    color: controller.selectedLeftPage.value ==
                                            "PROFILE"
                                        ? const Color.fromARGB(255, 0, 128, 128)
                                        : Colors.white),
                                child: Center(
                                    child: Icon(
                                  Icons.person_outlined,
                                  color: controller.selectedLeftPage.value ==
                                          "PROFILE"
                                      ? Colors.white
                                      : Colors.black,
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
              return Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                    ),
                    color: Colors.white),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (!controller.selectedChatRoom.value.isPaid &&
                controller.apiScreenResponse.value == "PASS") {
              return buildOverLay();
            } else if (controller.selectedChatRoom.value.isPaid &&
                controller.apiScreenResponse.value == "PASS") {
              return buildChatScreen(constraints: constraints);
            } else {
              return Container(
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(50)),
                    color: Colors.white),
              );
            }
          }),
        ),
      ],
    );
  }

  Widget buildOverLay() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          color: Colors.black.withOpacity(0.7),
          width: constraints.maxWidth,
          height: constraints.maxWidth,
          child: Center(
            child: AlertDialog(
              title: Text(
                  'This chat  Requires ₹${controller.selectedChatRoom.value.rate}'),
              content: Text(
                  'Your current balance is ₹ ${controller.userData.value.balance}'),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () => controller.payToUnlockChat(),
                    child: const Text('Pay Now'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildChatList({required BoxConstraints constraints}) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
        ),
        color: Colors.white,
      ),
      height: constraints.maxHeight,
      padding: const EdgeInsets.only(top: 15),
      child: ListView(
        children: controller.chatList.map((chatUser) {
          return Column(
            children: [
              _buildChatUserTile(chatUser: chatUser),
              // const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildWalletPage({required BoxConstraints constraints}) {
    return Container(
      height: constraints.maxHeight,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Text(
                  "Your Current Balance : ₹ ${controller.userData.value.balance}");
            }),
            20.verticalSpace,
            buildWalletFields(
              constraints: constraints,
              inputLabel: "Enter amount you want to add to wallet",
              textController: controller.addAmountController,
              buttonLabel: 'Load Wallet',
              onSubmit: () => controller.onLoadWalletButtonClicked(),
            ),
            20.verticalSpace,
            buildWalletFields(
              constraints: constraints,
              inputLabel: "Enter amount you want to withdraw from wallet",
              textController: controller.withdrawAmountController,
              buttonLabel: 'Withdraw',
              onSubmit: () => controller.onWithdrawWalletButtonClicked(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWalletFields({
    required BoxConstraints constraints,
    required String inputLabel,
    required TextEditingController textController,
    required String buttonLabel,
    required Function() onSubmit,
  }) {
    return SizedBox(
      width: constraints.maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(inputLabel),
          10.verticalSpace,
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '₹ 500',
            ),
            keyboardType: TextInputType.number,
          ),
          10.verticalSpace,
          ElevatedButton(
            onPressed: () => onSubmit.call(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: const Color.fromARGB(255, 0, 128, 128),
            ),
            child: Text(
              buttonLabel,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfilePage({required BoxConstraints constraints}) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
        ),
        color: Colors.white,
      ),
      height: constraints.maxHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            20.verticalSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: 50, child: Text(controller.userData.value.name[0])),
                10.verticalSpace,
                Text(
                  controller.userData.value.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            20.verticalSpace,
            const Divider(),
            // Container(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            //     child: const Text("About")),
            // const Divider(),
            InkWell(
              onTap: () =>
                  controller.launchURL("https://linket.chat/terms.html"),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: const Text("Terms And Condition")),
            ),
            const Divider(),
            InkWell(
              onTap: () =>
                  controller.launchURL("https://linket.chat/privacy.html"),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: const Text("Privacy Policy")),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }

  Widget buildChatScreen({required BoxConstraints constraints}) {
    return Stack(
      children: <Widget>[
        Obx(() {
          // Access the observable list directly
          final messages = controller.chatMessageList;

          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
              color: Colors.white,
            ),
            padding:
                const EdgeInsets.only(top: 20, bottom: 60, left: 20, right: 20),
            child: ListView.builder(
              controller: controller.scrollController,
              shrinkWrap: true,
              itemCount: messages.length, // Use length of observable list
              itemBuilder: (context, index) {
                return chatMessageTile(chat: messages[index], context: context);
              },
            ),
          );
        }),
        buildChatingWithTile(),
        buildInputBox(),
      ],
    );
  }

  Widget buildChatingWithTile() {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.5)),
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        height: 50,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
                child: Text(controller.selectedChatRoom.value.name[0])),
            10.horizontalSpace,
            Text(
              controller.selectedChatRoom.value.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChatUserTile({required ChatListUserData chatUser}) {
    final isHovered = false.obs;

    void onHover(bool isHover) {
      isHovered.value = isHover;
    }

    return Obx(
      () {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => onHover(true),
          onExit: (_) => onHover(false),
          child: GestureDetector(
            onTap: () => controller.onChatTileClicked(chatUser: chatUser),
            child: Container(
              color: isHovered.value
                  ? const Color.fromARGB(255, 0, 128, 128).withOpacity(.10)
                  : Colors.transparent,
              child: ListTile(
                onTap: () => controller.onChatTileClicked(chatUser: chatUser),
                leading: CircleAvatar(child: Text(chatUser.name[0])),
                title: Text(chatUser.name),
                subtitle: Text(
                  chatUser.chatText,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
                enabled: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (chatUser.unreadCount > 0)
                      // Container(
                      //   margin: const EdgeInsets.only(top: 5.0),
                      //   padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 13),
                      //   width: 80,
                      //   height: 22,
                      //   decoration: BoxDecoration(
                      //     color: Color.fromARGB(255, 0, 128, 128),
                      //     borderRadius: BorderRadius.circular(20),
                      //   ),
                      //   child: Text(
                      //     "Your Turn",
                      //     style: const TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.normal),
                      //   ),
                      // ),
                      5.verticalSpace,
                    Text(chatUser.chatDate),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget chatMessageTile(
      {required BuildContext context, required ChatMessage chat}) {
    return Row(
      children: [
        if (chat.sent) const Spacer(),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: chat.sent
                ? const Color.fromARGB(255, 0, 128, 128)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: chat.sent
                  ? Colors.transparent
                  : const Color.fromARGB(255, 216, 213, 213), // Border color
              width: 1.0, // Border width
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (chat.chatImg.isNotEmpty) ...[
                10.verticalSpace,
                ImageTextCell(
                  img: chat.chatImg,
                  height: 200,
                  width: 200,
                ),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width *
                          0.5, // Limit width to 50% of the screen
                    ),
                    child: Text(
                      chat.chatText,
                      style: TextStyle(
                          color: chat.sent ? Colors.white : Colors.blueGrey,
                          overflow: TextOverflow.visible),
                      maxLines: null,
                    ),
                  ),
                  20.horizontalSpace,
                  Text(
                    chat.chatDate,
                    style: TextStyle(
                        fontSize: 10,
                        color: chat.sent
                            ? const Color.fromARGB(255, 219, 213, 213)
                            : const Color.fromARGB(255, 100, 100, 100)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildInputBox() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
              color: const Color.fromARGB(255, 216, 213, 213), // Border color
              width: 1.0, // Border width
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Obx(
                () {
                  return Container(
                    decoration: BoxDecoration(
                      color: controller.imageUploadUrl.value.isNotEmpty
                          ? const Color.fromARGB(255, 0, 128, 128)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () => controller.uploadImageWeb(),
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          constraints: BoxConstraints.tight(const Size(30, 30)),
                          color: controller.imageUploadUrl.value.isNotEmpty
                              ? Colors.white
                              : Colors.grey,
                        ),
                        if (controller.imageUploadUrl.value.isNotEmpty)
                          const Text(
                            "1",
                            style: TextStyle(color: Colors.white),
                          ),
                      ],
                    ),
                  );
                },
              ),
              10.horizontalSpace,
              Expanded(
                child: TextField(
                  controller: controller.textController,
                  maxLines: 4,
                  minLines: 1,
                  onSubmitted: (text) => controller.sendMessage(),
                  decoration: const InputDecoration.collapsed(
                      hintText: "Send a message"),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => controller.sendMessage(),
                padding: const EdgeInsets.all(0),
                iconSize: 20,
                constraints: BoxConstraints.tight(const Size(30, 30)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
