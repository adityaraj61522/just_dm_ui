import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_dm_ui/config.dart';
import 'package:just_dm_ui/responses/loginResponse.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPageController extends GetxController {
  final String linketLogo = "https://imgur.com/a/tkIVVeF";

  final List<String> technologyNameList = [];
  final List<String> technologyLinkList = [];
  final apiResponse = "PASS".obs;
  // LoginResponseData loginRes = {} as LoginResponseData;
  @override
  void onInit() {
    super.onInit();
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
}
