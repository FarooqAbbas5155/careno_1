//
// import 'package:careno/AuthSection/screen_login.dart';
// import 'package:careno/AuthSection/screen_otp.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../widgets/custom_button.dart';
// import '../widgets/custom_textfiled.dart';
// import '../constant/helpers.dart';
// import '../controllers/home_controller.dart';
//
//
// class ScreenSignup extends StatelessWidget {
//   final HomeController _homeController = Get.put(HomeController()); // Initialize HomeController
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.asset("assets/images/careno.png").marginSymmetric(
//                   vertical: 55.h),
//               Center(child: Text("Sign up for your Account ", style: TextStyle(
//                   fontFamily: "UrbanistBold",
//                   fontWeight: FontWeight.w700,
//                   fontSize: 18.sp,
//                   color: Colors.black),)),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 30.w),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Full Name", style: TextStyle(fontFamily: "UrbanistBold",
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700),).marginOnly(
//                         top: 20.h, bottom: 4.h),
//                     CustomTextField(
//                       hint: "Enter Name",
//                     ),
//                     Text("Email", style: TextStyle(fontFamily: "UrbanistBold",
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700),).marginOnly(
//                         top: 20.h, bottom: 4.h),
//                     CustomTextField(
//                       hint: "Enter Email",
//                     ),
//                     Text("Password", style: TextStyle(fontFamily: "UrbanistBold",
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700),).marginOnly(
//                         top: 20.h, bottom: 4.h),
//                     Obx(() =>
//                         CustomTextField(
//                           padding: EdgeInsets.only(top: 20.h, left: 10.w),
//                           // Observe the changes in isPasswordVisible
//                           hint: "Password",
//                           suffix: IconButton(
//                             onPressed: () {
//                               _homeController.isPasswordVisible
//                                   .toggle(); // Toggle password visibility
//                             },
//                             icon: Padding(
//                               padding: EdgeInsets.only(top: 10.h,),
//                               // Observe the changes in isPasswordVisible
//                               child: Icon(
//                                 _homeController.isPasswordVisible.value ? Icons
//                                     .visibility : Icons.visibility_off,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                           // isPasswordField: _homeController.isPasswordVisible.value,
//                           obsercureText: _homeController.isPasswordVisible.value,
//                         )),
//
//                     Text("Repeat Password", style: TextStyle(fontFamily: "UrbanistBold",
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700),).marginOnly(
//                         top: 20.h, bottom: 4.h),
//                     Obx(() =>
//                         CustomTextField(
//                           padding: EdgeInsets.only(top: 20.h, left: 10.w),
//                           // Observe the changes in isPasswordVisible
//                           hint: "Repeat Password",
//                           suffix: IconButton(
//                             onPressed: () {
//                               _homeController.isPasswordVisible
//                                   .toggle(); // Toggle password visibility
//                             },
//                             icon: Padding(
//                               padding: EdgeInsets.only(top: 10.h,),
//                               // Observe the changes in isPasswordVisible
//                               child: Icon(
//                                 _homeController.isPasswordVisible.value ? Icons
//                                     .visibility : Icons.visibility_off,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                           // isPasswordField: _homeController.isPasswordVisible.value,
//                           obsercureText: _homeController.isPasswordVisible.value,
//                         )),
//                     Row(
//                       children: [
//                         Obx(() {
//                           return Checkbox(
//                             value: _homeController.checkBox.value,
//                             fillColor: MaterialStateProperty.all( _homeController.checkBox.isTrue?primaryColor:Colors.white),
//                             // Set initial value as per your requirement
//                             onChanged: (bool? value) {
//                               _homeController.checkBox.toggle();
//                             },
//                           );
//                         }
//                         ),
//                         Image.asset("assets/images/terms.png",width: 200.w,)
//                       ],
//                     ).marginSymmetric(vertical: 4.h),
//                     Center(child: CustomButton(title: "Signup", onPressed: (){
//                       Get.to(ScreenOtp());
//
//                     })).marginSymmetric(vertical: 30.h),
//                     Center(
//                       child: RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: "Already have an account? ",
//                               style: TextStyle(color: Colors.black,fontFamily: "Urbanist",fontSize: 15.sp),
//                             ),
//                             TextSpan(
//                                 text: "Login",
//                                 style: TextStyle(color: primaryColor,fontFamily: "UrbanistBold",fontSize: 16.sp), // Use primary color
//                                 recognizer: TapGestureRecognizer()..onTap = (){
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) => ScreenLogin(),
//                                   ));
//                                 }
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
