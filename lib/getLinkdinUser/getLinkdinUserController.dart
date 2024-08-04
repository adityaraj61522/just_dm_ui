import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_dm_ui/config.dart';
import 'package:just_dm_ui/responses/loginResponse.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GetLinkdinUserController extends GetxController {
  GetLinkdinUserController({
    required this.token,
  });
  final String token;
  final apiResponse = "LOADING".obs;

  @override
  void onInit() async {
    super.onInit();
    saveToStorage("token", token);
    print("-------------------session token is--------------------");
    print(readFromStorage('token').toString());
  }

  Map<String, dynamic> decodeJwt(String token) {
    // Decode the token
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken;
  }

  final storage = FlutterSecureStorage();

  Future<void> saveToStorage(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> readFromStorage(String key) async {
    return await storage.read(key: key);
  }

  Future<void> deleteFromStorage(String key) async {
    await storage.delete(key: key);
  }

  void onLoginButtonClicked() async {
    apiResponse.value = "LOADING";
    try {
      final response =
          await http.get(Uri.parse(Config.apiBaseUrl + '/api/login'));

      if (response.statusCode == 200) {
        apiResponse.value = "PASS";
        if (response.body.isNotEmpty) {
          var responseData = json.decode(response.body);
          var loginResponse = LoginResponse.fromJson(responseData);
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
