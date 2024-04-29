import 'package:careno/AuthSection/screen_otp.dart';
import 'package:careno/controllers/google_controller.dart';
import 'package:careno/controllers/phone_controller.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:careno/constant/helpers.dart';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../widgets/custom_textfiled.dart';
import '../controllers/home_controller.dart';


class ScreenLogin extends StatelessWidget {
  var code = '';

  PhoneController controller = Get.put(PhoneController());
  GoogleController _controller = Get.put(GoogleController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/images/careno.png").marginSymmetric(
                  vertical: 50.h),
              Center(child: Text("Let’s Get It Started! ", style: TextStyle(
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  color: Colors.black),)),
              Text(
                  "Please enter your phone number to verify your identity. You will receive a code on this number..",
                  style: TextStyle(color: Color(0xff989898),
                      fontFamily: "Urbanist",
                      fontSize: 13.sp)).marginSymmetric(
                  horizontal: 40.w, vertical: 6.h),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phone", style: TextStyle(fontFamily: "Urbanist",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700),).marginOnly(
                        top: 30.h, bottom: 8.h),
                    Obx(() {
                      return CustomTextField(
                        controller: controller.phoneController.value,
                        padding: EdgeInsets.only(left: 10.w, top: 22.h),
                        hint: "Phone Number",
                        keyboardType: TextInputType.number,
                        hintColor: controller.country_code == null ? Color(
                            0xff94979F).withOpacity(.7) : Colors.black,
                        prefix: CountryCodePicker(
                          padding: EdgeInsets.zero,
                          onChanged: (value) {
                            controller.country_code = value.dialCode.toString();
                          },
                          textStyle: TextStyle(
                              fontSize: 16.sp, fontFamily: "UrbanistBold"),
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'US',
                          favorite: ['+1', 'US'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ).marginOnly(top: 4.h),
                      );
                    }).marginSymmetric(vertical: 4.h),
                    // Text("Password", style: TextStyle(fontFamily: "UrbanistBold",
                    //     fontSize: 16.sp,
                    //     fontWeight: FontWeight.w700),).marginOnly(
                    //     top: 30.h, bottom: 8.h),
                    // Obx(() =>
                    //     CustomTextField(
                    //       padding: EdgeInsets.only(top: 20.h, left: 10.w),
                    //       // Observe the changes in isPasswordVisible
                    //       hint: "********",
                    //       suffix: IconButton(
                    //         onPressed: () {
                    //           controller.isPasswordVisible
                    //               .toggle(); // Toggle password visibility
                    //         },
                    //         icon: Padding(
                    //           padding: EdgeInsets.only(top: 10.h,),
                    //           // Observe the changes in isPasswordVisible
                    //           child: Icon(
                    //             controller.isPasswordVisible.value ? Icons
                    //                 .visibility : Icons.visibility_off,
                    //             color: Colors.grey,
                    //           ),
                    //         ),
                    //       ),
                    //       // isPasswordField: _homeController.isPasswordVisible.value,
                    //       obsercureText: controller.isPasswordVisible.value,
                    //     )),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Obx(() {
                    //           return Checkbox(
                    //             value: controller.checkBox.value,
                    //             fillColor: MaterialStateProperty.all( controller.checkBox.isTrue?primaryColor:Colors.white),
                    //             // Set initial value as per your requirement
                    //             onChanged: (bool? value) {
                    //               controller.checkBox.toggle();
                    //             },
                    //           );
                    //         }
                    //         ),
                    //         Text('Remember me', style: TextStyle(
                    //             fontFamily: "Urbanist",
                    //             fontSize: 15.sp,
                    //             fontWeight: FontWeight.w500,
                    //             color: Colors.black),),
                    //
                    //       ],
                    //     ),
                    //     InkWell(
                    //       onTap: (){
                    //         Get.to(ScreenForgetPassword());
                    //       },
                    //       child: Text('Forget Password?', style: TextStyle(
                    //           fontFamily: "Urbanist",
                    //           fontSize: 15.sp,
                    //           color: primaryColor,
                    //           fontWeight: FontWeight.w600),),
                    //     ),
                    //   ],
                    // ).marginSymmetric(vertical: 4.h),
                  Center(
                      child: CustomButton(
                          title: "Send Code", onPressed: () {
                        controller.sendVerificationCode();
                      })).marginOnly(top: 50.h, bottom: 30.h),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            indent: (10.w).toDouble(),
                            // endIndent: (2.w).toDouble(),
                            color: Color(0xffEDEEEE),
                            thickness: 2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("or Continue with", style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Urbanist",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),),
                        ),
                        Expanded(
                          child: Divider(
                            // indent: (5.w).toDouble(),
                            // endIndent: (2.w).toDouble(),
                            color: Color(0xffEDEEEE),
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainer(
                            "Apple", "assets/images/cib_apple.svg", () {}),
                        CustomContainer(
                            "Google", "assets/images/google.svg", () {
                              _controller.googleLogin();
                        })
                      ],
                    ),
                    // Center(
                    //   child: RichText(
                    //     text: TextSpan(
                    //       children: [
                    //         TextSpan(
                    //           text: "Don't have an account? ",
                    //           style: TextStyle(color: Colors.black,fontFamily: "Urbanist",fontSize: 15.sp),
                    //         ),
                    //         TextSpan(
                    //           text: "Signup",
                    //           style: TextStyle(color: primaryColor,fontFamily: "UrbanistBold",fontSize: 16.sp), // Use primary color
                    //        recognizer: TapGestureRecognizer()..onTap = (){
                    //          Navigator.of(context).push(MaterialPageRoute(
                    //            builder: (context) => ScreenSignup(),
                    //          ));
                    //         }
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

            ],
          ).marginSymmetric(horizontal: 4.w),
        ),
      ),
    );
  }
}

Widget CustomContainer(String title, String imagePath, VoidCallback onpress) {
  return InkWell(
    onTap: onpress,
    child: Container(
      width: 145.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(width: 1, color: Color(0xffEDEEEE),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(imagePath, width: 25.w,),
          SizedBox(width: 8), // Add some space between icon and text
          Text(
            title,
            style: TextStyle(fontSize: 14.sp,
                fontFamily: "Urbanist",
                fontWeight: FontWeight.w600),
          ),
        ],
      ),),
  ).marginSymmetric(vertical: 35.h);
}