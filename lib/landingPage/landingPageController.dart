import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_dm_ui/responses/loginResponse.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPageController extends GetxController {
  final String linketLogo = "https://imgur.com/a/tkIVVeF";

  final List<String> technologyNameList = [];
  final List<String> technologyLinkList = [];
  final apiResponse = "LOADING".obs;
  // LoginResponseData loginRes = {} as LoginResponseData;
  @override
  void onInit() {
    super.onInit();
    convertTechnology();
  }

  void onLoginButtonClicked() async {
    apiResponse.value = "LOADING";
    try {
      final response =
          await http.get(Uri.parse('http://localhost:7000/api/login'));

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
  final List<Map<String, String>> educationList = [
    {
      "degree": "Bachelors of Technology",
      "collage": "Birla Institute Of Technology",
      "course": "Electronics and Communication Engineering",
      "fromTo": "2018 - 2022"
    },
    {
      "degree": "Bachelors of Technology",
      "collage": "Birla Institute Of Technology",
      "course": "Electronics and Communication Engineering",
      "fromTo": "2018 - 2022"
    }
  ];

  final List<Map<String, String>> introductionList = [
    {
      "title": "I love Exploring Things",
      "point1":
          "I'm an India based software developer with a goal-driven creative mindset and passion for learning and innovating.",
      "point2":
          "Currently working as a Software Developer at Amdocs and as a Freelance Content Writer for Pepper Content.",
      "point3":
          "Outside work, I occasionally blog on Medium. Off-screen, I sketch my thoughts here!",
    }
  ];

  final List<Map<String, String>> experienceList = [
    {
      "profile": "Bachelors of Technology",
      "company": "Birla Institute Of Technology",
      "responsibility1": "Electronics and Communication Engineering",
      "responsibility2": "Electronics and Communication Engineering",
      "responsibility3": "Electronics and Communication Engineering",
      "fromTo": "2018 - 2022"
    },
    {
      "profile": "Bachelors of Technology",
      "company": "Birla Institute Of Technology",
      "responsibility1": "Electronics and Communication Engineering",
      "responsibility2": "Electronics and Communication Engineering",
      "responsibility3": "Electronics and Communication Engineering",
      "fromTo": "2018 - 2022"
    }
  ];

  final List<Map<String, String>> technologyList = [
    {
      "NodeJs": "https://i.imgur.com/TBBt3Mj.png",
      "Flutter": "https://i.imgur.com/dzQsdnU.png",
      "Angular": "https://i.imgur.com/XTRsVs5.png",
      "SQL": "https://i.imgur.com/BoKMxCe.png",
      "Figma": "https://i.imgur.com/kN6M4o7.png",
      "React": "https://i.imgur.com/MDbLVLL.png",
      "MongoDb": "https://i.imgur.com/CtYaFnj.png",
    },
  ];

  void convertTechnology() {
    technologyList[0].forEach((key, value) {
      technologyNameList.add(key);
      technologyLinkList.add(value);
    });
  }

  final List<String> socialMediaList = [
    'https://i.imgur.com/vbdv6Du.png',
    'https://i.imgur.com/uCy8BGO.png',
    'https://i.imgur.com/CrOipag.png',
  ];
}
