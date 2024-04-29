import 'package:careno/constant/colors.dart';
import 'package:careno/controllers/chat_controller.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constant/database_utils.dart';
import '../../../constant/firebase_utils.dart';
import '../../../constant/helpers.dart';
import '../../../models/last_message.dart';
import '../../../models/user.dart';
import '../../../widgets/not_found.dart';
import 'item_user_list.dart';

class LayoutUserMessages extends StatelessWidget {
  RxBool filterValue = false.obs;
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatController>(builder: (chatController){
        return chatController.rooms.value.isEmpty
            ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/nothing.png",
                  color: AppColors.appPrimaryColor,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.1,
                  width: MediaQuery
                      .of(context)
                      .size
                      .height * 0.1,
                ),
                Text(
                  "No Messages",
                  style: TextStyle(
                      color: AppColors.appPrimaryColor,
                      fontFamily: "Urbanist",
                      fontWeight: FontWeight.w600),
                ),
              ],
            ))
            : Column(
          children: [
            Container(
              padding:
              EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
              decoration: BoxDecoration(color: AppColors.appPrimaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Messages",
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.r)),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search here...",
                              hintStyle: TextStyle(
                                  color: Color(0xff616161).withOpacity(.5),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Urbanist"),
                              prefixIcon: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: CustomSvg(
                                    name: "search",
                                  )),
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 10.h),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        return GestureDetector(
                          onTap: () {
                            filterValue.value = !filterValue.value;
                          },
                          child: (filterValue.value)
                              ? Container(
                            height: 35.h,
                            width: 35.w,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: CustomSvg(
                                name: "filter-chat",
                                color: AppColors.appPrimaryColor),
                          )
                              : CustomSvg(
                            name: "filter-chat",
                          ),
                        ).marginOnly(left: 15.r);
                      })
                    ],
                  ).marginSymmetric(vertical: 15.h)
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (filterValue.value == true)
                            ? Text(
                          "Filtered by Unread",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Color(0xFF484848),
                              fontWeight: FontWeight.w700),
                        ).marginSymmetric(vertical: 10.h, horizontal: 10.w)
                            : SizedBox(),
                        ListView.builder(
                          itemCount: chatController.rooms.value.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var lastMessageObj = chatController.rooms.value[index];
                            return FutureBuilder<User>(
                              future: getUser(
                                get2ndUserId(
                                  lastMessageObj.chatRoomId,
                                  FirebaseUtils.myId,
                                ),
                              ),
                              builder: (context, snapshot) {
                                User user = snapshot.connectionState == ConnectionState.waiting ? defaultUser : snapshot.data!;
                                return ItemUserList(
                                  user: user,
                                  roomId: lastMessageObj.chatRoomId,
                                  timestamp: lastMessageObj.timestamp,
                                  lastMessage: lastMessageObj.lastMessage,
                                  counter: lastMessageObj.counter,
                                  userBlock: lastMessageObj.isBlocked,
                                );
                              },
                            );
                          },
                        )
                      ],
                    );
                  }),
                ))
          ],
        );
      },
      ),
    );
  }
}
