import 'package:careno/controllers/chat_controller.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_time_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/helpers.dart';
import '../../../models/user.dart';
import '../screens/screen_user_chat.dart';

class ItemUserList extends StatelessWidget {
  User user;
  String lastMessage;
  int timestamp,counter;
  String roomId;
  bool userBlock;

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.put(ChatController());
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDateTime = DateFormat('hh:mm a').format(dateTime);

    return GestureDetector(
      onTap: (){
        Get.to(ScreenUserChat(user: user,counter: counter,chatRoomId: roomId,timeStamp: timestamp,));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  showPopupImage(context, user.imageUrl);
                },
                child: Container(
                  height: 48.h,
                  width: 48.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:  NetworkImage(user.imageUrl.isEmpty
                            ? image_url
                            : user.imageUrl),
                    fit: BoxFit.fill)
                  ),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: CustomSvg(name: "circle",color: user.status == "Online"?Colors.green:Colors.grey.withOpacity(.3),)),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(user.name.isEmpty ?"No Name":user.name,style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp
                  ),),
                  Text(user.status,style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp
                  ),),
                  Text(lastMessage,style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    color: Color(0xFF373132),
                    overflow: TextOverflow.ellipsis
                  ),),
                ],).marginSymmetric(horizontal: 8.h),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(formattedDateTime,style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500),),
              counter == 0?SizedBox(): Container(
                  padding: EdgeInsets.all(5.sp),
                  decoration: BoxDecoration(
                  color: Color(0xFFFF2021),
                  shape: BoxShape.circle,

                ),
                child: Text(counter.toString(),style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 14.sp
                ),),
                )
              ],),

            ],
          ).marginSymmetric(horizontal: 25.w
          ,vertical: 5.h),
          SizedBox(
              width: 291.w,
              child: Divider(color: Color(0xFF787878).withOpacity(.35),))
        ],
      ).marginSymmetric(vertical: 5.h),
    );
  }
  ItemUserList({
    required this.user,
    required this.lastMessage,
    required this.timestamp,
    required this.counter,
    required this.roomId,
    required this.userBlock,
  });
}
