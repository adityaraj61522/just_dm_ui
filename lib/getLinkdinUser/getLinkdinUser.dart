import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_dm_ui/getLinkdinUser/getLinkdinUserController.dart';

class GetLinkdinUser extends StatelessWidget {
  GetLinkdinUser({
    super.key,
    required this.token,
  }) : controller = Get.put(GetLinkdinUserController(token: token));
  final String token;
  final GetLinkdinUserController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildContent());
  }

  Widget buildContent() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          child: Text(token),
        );
      },
    );
  }
}
