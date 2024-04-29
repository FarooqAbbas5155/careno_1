import 'package:careno/constant/firebase_utils.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Layouts/item_notification.dart';

class ScreenHostNotification extends StatelessWidget {
  const ScreenHostNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: notificationRef.where("receiverId",isEqualTo: FirebaseUtils.myId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            var notifications=snapshot.data!.docs.map((e) => NotificationModel.fromMap(e.data() as Map<String,dynamic>)).toList();
            return (notifications.isNotEmpty)? ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
              return ItemNotification(notificationModel: notifications[index]);
            },):Center(child: Text("No Notification Yet"));
          }
        ),
      ),
    );
  }
}
