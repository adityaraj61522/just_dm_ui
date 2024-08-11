import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_dm_ui/getLinkdinUser/getLinkdinUserController.dart';

class GetLinkdinUser extends StatelessWidget {
  final String token;
  const GetLinkdinUser({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TokenHandler(
          token: token,
        ),
      ),
    );
  }
}

class TokenHandler extends StatefulWidget {
  TokenHandler({
    super.key,
    required this.token,
  });

  final String token;

  final GetLinkdinUserController controller =
      Get.put(GetLinkdinUserController());

  @override
  _TokenHandlerState createState() => _TokenHandlerState();
}

class _TokenHandlerState extends State<TokenHandler> {
  @override
  void initState() {
    super.initState();
    print(widget.token);
    if (widget.token.isNotEmpty) {
      widget.controller.saveToLocalStorage('auth_token', widget.token);
      widget.controller.getUserData(widget.token, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:just_dm_ui/getLinkdinUser/getLinkdinUserController.dart';

// class GetLinkdinUser extends StatelessWidget {
//   final String token;
//   final GetLinkdinUserController controller;
//   GetLinkdinUser({
//     super.key,
//     required this.token,
//   }) : controller = Get.put(GetLinkdinUserController(token: token));

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Scaffold(
// //       body: Center(
// //         child: CircularProgressIndicator(),
// //       ),
// //     );
// //   }
// // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: buildContent());
//   }

//   Widget buildContent() {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         return SizedBox(
//           child: Text(token),
//         );
//       },
//     );
//   }
// }
