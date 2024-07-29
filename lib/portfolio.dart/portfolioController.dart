import 'package:get/get.dart';

class LandingPageController
    extends GetxController {
  final String name = "Aditya Raj";
  final String designation =
      "Software Development Engineer";
  final String basedIn =
      "Based In Gurugram, India";
  final String aboutText =
      "I am a B.Tech graduate from Birla Institute of Technology Mesra, I am an experienced software development engineer specializing in NodeJS, Flutter, and Angular. I have a strong foundation incomputer science concepts and software engineering best practices. With a collaborative mindset andproblem-solving skills, I am eager to bring my skills to a new opportunity.";
  final String profilePhoto =
      'https://i.imgur.com/U7fczdf.jpg';
  final String gmailLogo =
      "https://i.imgur.com/nRaBG1c.png";

  final List<String>
      technologyNameList = [];
  final List<String>
      technologyLinkList = [];

  @override
  void onInit() {
    super.onInit();

    convertTechnology();
  }

  final List<Map<String, String>>
      educationList = [
    {
      "degree":
          "Bachelors of Technology",
      "collage":
          "Birla Institute Of Technology",
      "course":
          "Electronics and Communication Engineering",
      "fromTo": "2018 - 2022"
    },
    {
      "degree":
          "Bachelors of Technology",
      "collage":
          "Birla Institute Of Technology",
      "course":
          "Electronics and Communication Engineering",
      "fromTo": "2018 - 2022"
    }
  ];

  final List<Map<String, String>>
      introductionList = [
    {
      "title":
          "I love Exploring Things",
      "point1":
          "I'm an India based software developer with a goal-driven creative mindset and passion for learning and innovating.",
      "point2":
          "Currently working as a Software Developer at Amdocs and as a Freelance Content Writer for Pepper Content.",
      "point3":
          "Outside work, I occasionally blog on Medium. Off-screen, I sketch my thoughts here!",
    }
  ];

  final List<Map<String, String>>
      experienceList = [
    {
      "profile":
          "Bachelors of Technology",
      "company":
          "Birla Institute Of Technology",
      "responsibility1":
          "Electronics and Communication Engineering",
      "responsibility2":
          "Electronics and Communication Engineering",
      "responsibility3":
          "Electronics and Communication Engineering",
      "fromTo": "2018 - 2022"
    },
    {
      "profile":
          "Bachelors of Technology",
      "company":
          "Birla Institute Of Technology",
      "responsibility1":
          "Electronics and Communication Engineering",
      "responsibility2":
          "Electronics and Communication Engineering",
      "responsibility3":
          "Electronics and Communication Engineering",
      "fromTo": "2018 - 2022"
    }
  ];

  final List<Map<String, String>>
      technologyList = [
    {
      "NodeJs":
          "https://i.imgur.com/TBBt3Mj.png",
      "Flutter":
          "https://i.imgur.com/dzQsdnU.png",
      "Angular":
          "https://i.imgur.com/XTRsVs5.png",
      "SQL":
          "https://i.imgur.com/BoKMxCe.png",
      "Figma":
          "https://i.imgur.com/kN6M4o7.png",
      "React":
          "https://i.imgur.com/MDbLVLL.png",
      "MongoDb":
          "https://i.imgur.com/CtYaFnj.png",
    },
  ];

  void convertTechnology() {
    technologyList[0]
        .forEach((key, value) {
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
