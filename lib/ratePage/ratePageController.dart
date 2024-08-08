import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_dm_ui/chatPage/chatPage.dart';
import 'package:just_dm_ui/config.dart';
import 'package:just_dm_ui/responses/loginResponse.dart';

class RatePageController extends GetxController {
  final String linketLogo = "https://imgur.com/a/tkIVVeF";

  final List<String> technologyNameList = [];
  final List<String> technologyLinkList = [];
  final apiResponse = "PASS".obs;
  @override
  void onInit() {
    super.onInit();
  }

  void onSetRateButtonClicked(BuildContext context) async {
    apiResponse.value = "LOADING";
    try {
      final response = await http
          .get(Uri.parse(Config.apiBaseUrl + '/api/setRate'), headers: {
        'token': 'BYPASS',
        'rate': '500',
        'userid': '1',
      });

      if (response.statusCode == 200) {
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var loginResponse = LoginResponse.fromJson(responseData);
          if (loginResponse.code == 200 && loginResponse.status == "SUCCESS") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage()),
            );
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
}
