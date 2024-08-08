import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_dm_ui/config.dart';
import 'package:just_dm_ui/ratePage/ratePage.dart';
import 'package:just_dm_ui/responses/userResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

class GetLinkdinUserController extends GetxController {
  final apiResponse = "LOADING".obs;
  saveToLocalStorage(String key, String value) {
    html.window.localStorage[key] = value;
  }

  String? getFromLocalStorage(String key) {
    return html.window.localStorage[key];
  }

  void getUserData(String token, BuildContext context) async {
    apiResponse.value = "LOADING";
    try {
      final response = await http.get(
        Uri.parse(Config.apiBaseUrl + '/api/getUserDetails'),
        headers: {
          "token": token,
        },
      );

      if (response.statusCode == 200) {
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var userResponse = UserResponse.fromJson(responseData);
          if (userResponse.code == 200 && userResponse.status == "SUCCESS") {
            await saveToLocalStorage(
                'user_data',
                {
                  'email': userResponse.userData.email,
                  'emailVerified': userResponse.userData.emailVerified,
                  'familyName': userResponse.userData.familyName,
                  'locale': {
                    'country': userResponse.userData.locale.country,
                    'language': userResponse.userData.locale.language,
                  },
                  'givenName': userResponse.userData.givenName,
                  'name': userResponse.userData.name,
                  'picture': userResponse.userData.picture,
                  'sub': userResponse.userData.sub
                }.toString());
            if (userResponse.isNew) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RatePage()),
              );
            }
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
}
