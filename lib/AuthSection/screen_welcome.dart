import 'package:careno/AuthSection/screen_complete_profile.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/controllers/controller_update_profile.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScreenWelcome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ControllerUpdateProfile controller = Get.put(ControllerUpdateProfile());


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          child: Stack(
            children: [
              Container(
                height: 540.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login_image.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 460.h,
                bottom: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0, 4),
                        blurRadius: 50,
                        spreadRadius: 50,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/careno.png",
                      ).marginSymmetric(vertical: 30.sp, horizontal: 15.sp),
                      Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Urbanist"),
                      ).marginOnly(left: 14.w, bottom: 10.h),
                      Obx(() {
                        return RadioListTile(
                            title: Text(
                              "As a Customer/User",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Urbanist",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp),
                            ),
                            controlAffinity: ListTileControlAffinity.trailing,
                            activeColor: primaryColor,
                            value: "user",
                            groupValue: controller.userType.value,
                            onChanged: (String? value) {
                              controller.userType.value = value!;
                              print("UserType${controller.userType.value}");

                            });
                      }),
                      Obx(() {
                        return RadioListTile(
                            title: Text(
                              "As a Vehicle Host",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Urbanist",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp),
                            ),
                            controlAffinity: ListTileControlAffinity.trailing,
                            activeColor: primaryColor,
                            value: "host",
                            groupValue: controller.userType.value,
                            onChanged: (String? value) {
                              controller.userType.value = value!;
                              print("UserType${controller.userType.value}");

                            });
                      }),
                      Center(
                        child: Obx(() {
                          return CustomButton(
                            width: 310.w,
                            isLoading: controller.loadingUserType.value,
                            title: 'Next',
                            onPressed: () async {
                              Get.to(ScreenCompleteProfile());

                              // var response = await controller.updateUserType();
                              // if (response == "success") {
                              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("content")));
                                // Get.to(ScreenCompleteProfile());
                              // }
                              //   else {
                              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
                              // }
                            },
                          );
                        }).marginSymmetric(vertical: 25.h),
                      ),
        
                      // Button(title: "Register", onPressed: (){
                      //   Get.to(ScreenSignup());
                      // })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
