import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:Linket/chatPage/chatPage.dart';
import 'package:Linket/config.dart';
import 'package:Linket/responses/loginResponse.dart';
import 'dart:html' as html;

class RatePageController extends GetxController {
  final String linketLogo = "https://imgur.com/a/tkIVVeF";
  final apiResponse = "PASS".obs;
  final token = ''.obs;
  final TextEditingController textController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    token.value = getFromLocalStorage('auth_token') ?? 'NO_TOKEN';
  }

  String? getFromLocalStorage(String key) {
    return html.window.localStorage[key];
  }

  void onSetRateButtonClicked(BuildContext context) async {
    apiResponse.value = "LOADING";
    try {
      final response = await http
          .get(Uri.parse('${Config.apiBaseUrl}/api/setRate'), headers: {
        'token': token.value,
        'rate': textController.text,
      });

      if (response.statusCode == 200) {
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var loginResponse = LoginResponse.fromMap(responseData);
          if (loginResponse.code == 200 && loginResponse.status == "SUCCESS") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage()),
            );
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
}
