import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Linket/common_widgets/commonWidgets.dart';
import 'package:Linket/landingPage/landingPageController.dart';
import 'dart:html' as html;

class LandingPage extends StatefulWidget {
  final LandingPageController controller = Get.put(LandingPageController());

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final token = ''.obs;

  String? getFromLocalStorage(String key) {
    return html.window.localStorage[key];
  }

  @override
  void initState() {
    super.initState();
    token.value = getFromLocalStorage('auth_token') ?? '';
    if (token.value.isNotEmpty) {
      navigateToChat();
    }
  }

  navigateToChat() async {
    await widget.controller.getUserData(token.value, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (widget.controller.apiResponse.value == "LOADING") {
          // Show loader while loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (widget.controller.apiResponse.value == 'PASS') {
          // Show main content if API response is success
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 950) {
                return LinketScreen(constraints: constraints);
              } else {
                return buildMobileContent(constraints);
              }
            },
          );
        } else {
          // Show error message or empty state if API response is not success
          return const Center(
            child: Text('Something went wrong. Please try again.'),
          );
        }
      }),
    );
  }

  Widget buildMobileContent(BoxConstraints constraints) {
    return LinketMobileScreen(constraints: constraints);
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
    final containerHeight = constraints.maxHeight / 2;
    return Container(
      width: constraints.maxWidth,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 128, 128).withOpacity(0.75)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  SizedBox(
                    height: containerHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitle(),
                        const Spacer(),
                        buildSubtitle(),
                        buildDescription(),
                        const Spacer(),
                        buildLoginButton(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  buildTermsAndCondition(),
                ],
              ),
            ),
            Expanded(
              child: buildHeader(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        const Expanded(child: SizedBox.shrink()),
        Text(
          "Linket.chat!",
          style: TextStyle(
              fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    );
  }

  Widget buildTitle() {
    return Text(
      'Why bother with contact info? Just share your Linket.chat link!',
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget buildSubtitle() {
    return Text(
      'Say goodbye to awkward number swaps and endless connection requests! ',
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 20,
      ),
    );
  }

  Widget buildDescription() {
    return Text(
      'Just drop your Linket.chat Messaging Link and boom—you\'re ready to network like a pro.',
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 20,
      ),
    );
  }

  Widget buildDetails() {
    return const Text(
      'Linket is designed to help you connect new people, whether for personal or professional growth. Enjoy the added bonus of rewards with every new connection you make!',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }

  Widget buildLoginButton() {
    return ElevatedButton.icon(
      onPressed: () => Get.find<LandingPageController>().onLoginButtonClicked(),
      icon: Row(
        children: [
          ImageTextCell(
            img: Get.find<LandingPageController>().linkdinLogo,
            height: 35,
            width: 35,
            showBorder: false,
          ),
          10.horizontalSpace,
        ],
      ),
      label: Text(
        'Continue with LinkedIn',
        style: TextStyle(
          fontFamily: 'Poppins',
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        fixedSize: Size(270, 50),
        backgroundColor: Color.fromARGB(255, 0, 128, 128).withOpacity(0.99),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 18,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget buildTermsAndCondition() {
    return Row(
      children: [
        InkWell(
          onTap: () =>
              controller.launchURL(Uri.parse("https://linket.chat/terms.html")),
          child: Text(
            "Terms And Condition",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        10.horizontalSpace,
        Text(
          "|",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
        10.horizontalSpace,
        InkWell(
          onTap: () => controller
              .launchURL(Uri.parse("https://linket.chat/privacy.html")),
          child: Text(
            "Privacy Policy",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}

class LinketMobileScreen extends StatelessWidget {
  LinketMobileScreen({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;
  final controller = Get.put(LandingPageController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 128, 128).withOpacity(0.75)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(),
                  const Spacer(),
                  IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitle(),
                        20.verticalSpace,
                        buildSubtitle(),
                        buildDescription(),
                        30.verticalSpace,
                        buildLoginButton(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  buildTermsAndCondition(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return const Row(
      children: [
        Expanded(child: SizedBox.shrink()),
        Text(
          "Linket.chat!",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    );
  }

  Widget buildTitle() {
    return Text(
      'Why bother with contact info? Just share your Linket.chat link!',
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget buildSubtitle() {
    return Text(
      'Say goodbye to awkward number swaps and endless connection requests! ',
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 15,
      ),
    );
  }

  Widget buildDescription() {
    return Text(
      'Just drop your Linket.chat Messaging Link and boom—you\'re ready to network like a pro.',
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 15,
      ),
    );
  }

  Widget buildDetails() {
    return const Text(
      'Linket is designed to help you connect new people, whether for personal or professional growth. Enjoy the added bonus of rewards with every new connection you make!',
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
    );
  }

  Widget buildLoginButton() {
    return ElevatedButton.icon(
      onPressed: () => Get.find<LandingPageController>().onLoginButtonClicked(),
      icon: Row(
        children: [
          ImageTextCell(
            img: Get.find<LandingPageController>().linkdinLogo,
            height: 20,
            width: 20,
            showBorder: false,
          ),
          10.horizontalSpace,
        ],
      ),
      label: Text(
        'Continue with LinkedIn',
        style: TextStyle(
          fontFamily: 'Poppins',
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        fixedSize: Size(230, 35),
        backgroundColor: Color.fromARGB(255, 0, 128, 128).withOpacity(0.99),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 15,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget buildTermsAndCondition() {
    return Row(
      children: [
        InkWell(
          onTap: () =>
              controller.launchURL(Uri.parse("https://linket.chat/terms.html")),
          child: Text(
            "Terms And Condition",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        10.horizontalSpace,
        Text(
          "|",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 13,
            fontFamily: 'Poppins',
          ),
        ),
        10.horizontalSpace,
        InkWell(
          onTap: () => controller
              .launchURL(Uri.parse("https://linket.chat/privacy.html")),
          child: Text(
            "Privacy Policy",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
