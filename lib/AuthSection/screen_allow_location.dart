import 'package:careno/AuthSection/screen_location.dart';
import 'package:careno/widgets/button.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:careno/constant/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScreenAllowLocation extends StatelessWidget {
  const ScreenAllowLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/current_location.png").marginSymmetric(vertical: 25.h),
              Center(
                child: RichText(text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Allow ",
                      style: TextStyle(fontFamily: "UrbanistBold ",fontSize: 22.sp,fontWeight: FontWeight.w600,color: Colors.black),
                    ),
                    TextSpan(
                      text: '"Careno App"',
                      style: TextStyle(fontFamily: "UrbanistBold",fontSize: 22.sp,fontWeight: FontWeight.w600,color: primaryColor),
                    ),
                    TextSpan(
                      text: " to use",
                      style: TextStyle(fontFamily: "UrbanistBold ",fontSize: 22.sp,fontWeight: FontWeight.w600,color: Colors.black),
                    ),
          
                  ]
                )),
              ),
              Center(child: Text("your Location", style: TextStyle(fontFamily: "UrbanistBold ",fontSize: 22.sp,fontWeight: FontWeight.w600,color: Colors.black),)),
              Text("Your precise location is used to show",style: TextStyle(color: Color(0xff393939),fontFamily: "Urbanist",fontSize: 18.sp),).marginSymmetric(horizontal: 10.w),
              Text("your position on the map, get",style: TextStyle(color: Color(0xff393939),fontFamily: "Urbanist",fontSize: 18.sp),).marginSymmetric(horizontal: 10.w),
              Text("  directions, estimate travel times, and ",style: TextStyle(color: Color(0xff393939),fontFamily: "Urbanist",fontSize: 18.sp),).marginSymmetric(horizontal: 10.w),
              Text("improve search results! ",style: TextStyle(color: Color(0xff393939),fontFamily: "Urbanist",fontSize: 18.sp),).marginSymmetric(horizontal: 10.w),
              CustomButton(
                height: 52.h,
                width: 271.w,
                title: "Allow", onPressed: (){
                Get.to(ScreenLocation());
              },color: primaryColor,).marginOnly(top: 40.h),
              Button(
                  height: 52.h,
                  width: 271.w,
                 title:  "Allow While Using App", onPressed: () {
                    Get.to(ScreenLocation());
              }).marginSymmetric(vertical: 26.h),
              Button(
                  height: 52.h,
                  width: 271.w,
                 title:  "Don't Allow",onPressed: () {
                Get.back();
              })
            ],
          ),
        ),
      ),
    ));
  }
}
