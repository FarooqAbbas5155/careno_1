import 'package:careno/Host/Views/Layouts/item_blocked_users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/chat_controller.dart';

class ScreenHostBlockedUser extends StatelessWidget {
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Blocked Users"),
      ),
      body: ListView.builder(
        itemCount: chatController.rooms.length,
        itemBuilder: (BuildContext context, int index) {
        return ItemBlockedUsers();
      },)
    ));
  }
}
