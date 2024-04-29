import 'package:careno/constant/colors.dart';
import 'package:careno/constant/firebase_utils.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/widgets/custom_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ScreenHostDocuments extends StatelessWidget {
  const ScreenHostDocuments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("My Documents"),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: getUser(FirebaseUtils.myId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.appPrimaryColor,),
            );


          }
          var user = snapshot!.data;
          return user == null?Center(child: Text("No User here"),): Column(children: [

            Container(
              width: Get.width,
              height: 35.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0)
              ),
              child: Text("Insurance Certificate",style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700
              ),),
            ),

            Container(
                height: 163.h,
                width: 228.w,
                decoration: BoxDecoration(
                    color:AppColors.appPrimaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                        image: NetworkImage (user.hostIdentity.insurancePath),
                        fit: BoxFit.fill
                    )
                )
            ).marginSymmetric(vertical: 20.h),
            Container(
              width: Get.width,
              height: 35.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0)
              ),
              child: Text("National ID (Front)",style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700
              ),),
            ),

            Container(
                height: 163.h,
                width: 228.w,
                decoration: BoxDecoration(
                    color:AppColors.appPrimaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                        image: NetworkImage (user.hostIdentity.idFrontPath),
                        fit: BoxFit.fill
                    )
                )
            ).marginSymmetric(vertical: 20.h),
            Container(
              width: Get.width,
              height: 35.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0)
              ),
              child: Text("National ID (Back)",style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700
              ),),
            ),

            Container(
                height: 163.h,
                width: 228.w,
              decoration: BoxDecoration(
                  color:AppColors.appPrimaryColor,
                borderRadius: BorderRadius.circular(10.r),
                image: DecorationImage(
                    image: NetworkImage (user.hostIdentity.idBackPath),
                  fit: BoxFit.fill
                )
              )
            ).marginSymmetric(vertical: 20.h),
          ],);
        },

      ),
    ));
  }
}
