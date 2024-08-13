import 'package:just_dm_ui/chatPage/chatPage.dart';
import 'package:just_dm_ui/getLinkdinUser/getLinkdinUser.dart';
import 'package:just_dm_ui/landingPage/landingPage.dart';
import 'package:just_dm_ui/ratePage/ratePage.dart';
import 'package:just_dm_ui/routes/routesUtils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/landing",
      routes: {
        AppRoutes.landingRoute: (context) => LandingPage(),
        AppRoutes.getLinkdinUserRoute: (context) => GetLinkdinUser(token: ""),
        AppRoutes.ratePageRoute: (context) => RatePage(),
        AppRoutes.chatRoute: (context) => ChatPage(),
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'getLinkdinUser') {
          final token = uri.pathSegments[1];
          return MaterialPageRoute(
            builder: (context) => GetLinkdinUser(token: token),
          );
        }
        return MaterialPageRoute(
          builder: (context) => Text("error"),
        );
      },
    );
  }
}
