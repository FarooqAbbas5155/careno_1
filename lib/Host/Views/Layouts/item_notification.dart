import 'package:careno/models/notification_model.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemNotification extends StatelessWidget {
NotificationModel notificationModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      margin: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(1, 1), // changes position of shadow
          )
        ]
      ),
      child: ListTile(
        title: Text(notificationModel.type,style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14.sp
        ),),
        subtitle: Column(
          children: [
            Text(notificationModel.title,style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500
            ),),
            Text(notificationModel.subtitle,style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500
            ),),
          ],
        ),
        trailing: CustomSvg(name: "noti",),
      ),
    );
  }

ItemNotification({
    required this.notificationModel,
  });
}
