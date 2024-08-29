import 'package:Linket/chatPage/chatPage.dart';
import 'package:Linket/getLinkdinUser/getLinkdinUser.dart';
import 'package:Linket/landingPage/landingPage.dart';
import 'package:Linket/ratePage/ratePage.dart';
import 'package:Linket/routes/routesUtils.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

saveToLocalStorage(String value) {
  html.window.localStorage["chatWith"] = value;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linket.chat',
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
            uri.pathSegments.first.contains("chatWith")) {
          saveToLocalStorage(uri.pathSegments.last);
          return MaterialPageRoute(
            builder: (context) => LandingPage(),
          );
        }
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
