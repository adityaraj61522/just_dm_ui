import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Linket/common_widgets/commonWidgets.dart';
import 'package:Linket/ratePage/ratePageController.dart';

class RatePage extends StatelessWidget {
  final RatePageController controller = Get.put(RatePageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 950) {
            return buildScreen(context, constraints: constraints);
          } else {
            return Container(
              child: buildMobileContent(),
            );
          }
        },
      ),
    );
  }

  Widget buildMobileContent() {
    return Container();
  }

  Widget buildScreen(BuildContext context,
      {required BoxConstraints constraints}) {
    return Scaffold(
      body: Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: SizedBox.shrink(),
            ),
            buildGreeting(),
            20.verticalSpace,
            buildInputBar(constraints.maxWidth / 3),
            20.verticalSpace,
            buildSubmit(context, constraints.maxWidth / 3),
            const Expanded(
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGreeting() {
    return Text(
      'Hi ${controller.userData.value.name}, Let’s Linket!',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget buildInputBar(width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Set Network Rate',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: width,
          child: TextField(
            controller: controller.textController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '₹ 500',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Set price for every connect on the app',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget buildSubmit(BuildContext context, width) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () => controller.onSetRateButtonClicked(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: const Color.fromARGB(255, 0, 102, 153),
        ),
        child: const Text(
          'Network!',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
