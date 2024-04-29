import 'package:careno/widgets/bubble_special_three.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/message.dart';

class ItemUserChat extends StatelessWidget {
  Message message;
  String displayDate;

  ItemUserChat({
    required this.message, required  this.displayDate,
  });

  var uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(message.timestamp);
    String formattedDateTime = DateFormat('hh:mm a').format(dateTime);
    return     BubbleSpecialThree(
      text: message.text,
      tail: false,//message.sender_id == uid ?true:false,
      sent: false,//message.sender_id == uid ?true:false,
      isSender: message.sender_id !=uid?false:true,
      seen: false,
      delivered: false,
      time: formattedDateTime,
    );
  }
}
