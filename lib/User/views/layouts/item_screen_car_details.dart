import 'package:careno/constant/colors.dart';
import 'package:careno/models/rating.dart';
import 'package:careno/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/helpers.dart';

class ItemVehicleReview extends StatelessWidget {
 Rating rating;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: getUser(rating.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState==ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        var user=snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 25.r,
                  child: Image.network(user!.imageUrl,fit: BoxFit.cover,)),
              title: Text(user!.name,style: TextStyle(fontSize: 15.sp,fontFamily: "Quicksand",fontWeight: FontWeight.w600 ),),
              subtitle: Text("${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(rating.timeStamp))}",style: TextStyle(color:Color(0xff999999),fontSize: 8.sp,fontFamily: "Quicksand",fontWeight: FontWeight.w500), ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star,color: AppColors.starColor,),
                  Text(rating.avgRating.toString(),style: TextStyle(color: Colors.black,fontSize: 13.sp,fontFamily: "Quicksand" ,fontWeight: FontWeight.w600),),

                ],

              )
            ),
            Text(rating.description,style: TextStyle(color: Color(0xff414141),fontWeight: FontWeight.w500,fontSize: 12.sp,fontFamily: "Quicksand"),).marginSymmetric(horizontal: 20.w),
            Divider(
              indent: 8.w,
              endIndent: 20.w,
              color: AppColors.dividerColor.withOpacity(.3),
            )
          ],
        );
      }
    );
  }

 ItemVehicleReview({
    required this.rating,
  });
}
