import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_dm_ui/common_widgets/commonWidgets.dart';
import 'package:just_dm_ui/landingPage/landingPageController.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 950) {
            return LinketScreen(constraints: constraints);
          } else {
            return buildMobileContent();
          }
        },
      ),
    );
  }

  Widget buildMobileContent() {
    return const SizedBox.shrink();
  }
}

class LinketScreen extends StatelessWidget {
  LinketScreen({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;
  final controller = Get.put(LandingPageController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildHeader(),
            const SizedBox(height: 10),
            buildTitle(),
            const SizedBox(height: 20),
            buildSubtitle(),
            const SizedBox(height: 20),
            buildDescription(),
            const SizedBox(height: 20),
            buildDetails(),
            const SizedBox(height: 40),
            buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        const Expanded(child: SizedBox.shrink()),
        ImageTextCell(
          img: Get.find<LandingPageController>().linketLogo,
          height: constraints.maxWidth / 10,
          width: constraints.maxWidth / 5,
        ),
      ],
    );
  }

  Widget buildTitle() {
    return const Text(
      'World’s First Premium Networking Platform',
      style: TextStyle(
        color: Color.fromARGB(255, 0, 102, 153),
        fontSize: 60,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget buildSubtitle() {
    return const Text(
      'Connect and Grow with Linket!',
      style: TextStyle(
        color: Color.fromARGB(255, 0, 102, 153),
        fontSize: 18,
      ),
    );
  }

  Widget buildDescription() {
    return const Text(
      'Discover a new way to expand your network and create valuable connections.',
      style: TextStyle(
        color: Color.fromARGB(255, 0, 102, 153),
        fontSize: 18,
      ),
    );
  }

  Widget buildDetails() {
    return const Text(
      'Linket is designed to help you connect new people, whether for personal or professional growth. Enjoy the added bonus of rewards with every new connection you make!',
      style: TextStyle(
        color: Color.fromARGB(255, 0, 102, 153),
        fontSize: 18,
      ),
    );
  }

  Widget buildLoginButton() {
    return ElevatedButton.icon(
      onPressed: () => Get.find<LandingPageController>().onLoginButtonClicked(),
      icon: const Icon(Icons.login),
      label: const Text(
        'Start with LinkedIn',
        style: TextStyle(
          fontFamily: 'Poppins',
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 0, 102, 153).withOpacity(0.5),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 18,
          fontFamily: 'Poppins',
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
