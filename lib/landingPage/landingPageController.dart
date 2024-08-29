import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:Linket/chatPage/chatPage.dart';
import 'package:Linket/config.dart';
import 'package:Linket/responses/loginResponse.dart';
import 'package:Linket/responses/userResponse.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class LandingPageController extends GetxController {
  final String linketLogo = "https://i.imgur.com/yE3gdRw.jpg";
  final String linkdinLogo =
      "https://pub-27ef948460e04665a808b1803176deb9.r2.dev/linkedin.1024x1024.png";

  final List<String> technologyNameList = [];
  final List<String> technologyLinkList = [];
  final apiResponse = "PASS".obs;
  final token = ''.obs;
  // LoginResponseData loginRes = {} as LoginResponseData;
  @override
  void onInit() {
    super.onInit();
  }

  String? getFromLocalStorage(String key) {
    return html.window.localStorage[key];
  }

  void onLoginButtonClicked() async {
    apiResponse.value = "LOADING";
    try {
      final response =
          await http.get(Uri.parse('${Config.apiBaseUrl}/api/login'));

      if (response.statusCode == 200) {
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var loginResponse = LoginResponse.fromMap(responseData);
          if (loginResponse.code == 200 && loginResponse.status == "SUCCESS") {
            print(loginResponse.location);
            _launchURL(Uri.parse(loginResponse.location));
          } else {
            apiResponse.value = "FAILED";
            print("Something is wrong!!!!!!!");
            print(loginResponse);
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

  void _launchURL(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getUserData(String token, BuildContext context) async {
    apiResponse.value = "LOADING";
    try {
      final response = await http.get(
        Uri.parse('${Config.apiBaseUrl}/api/getUserDetails'),
        headers: {
          "token": token,
        },
      );

      if (response.statusCode == 200) {
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var userResponse = UserResponse.fromMap(responseData);
          if (userResponse.code == 200 && userResponse.status == "SUCCESS") {
            await saveToLocalStorage('user_data', response.body);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage()),
            );
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
}
