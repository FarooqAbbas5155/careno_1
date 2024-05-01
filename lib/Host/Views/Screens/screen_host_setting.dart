import 'package:careno/TermsConditionSection/screen_privacy_policy.dart';
import 'package:careno/TermsConditionSection/screen_terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/helpers.dart';
import '../../../controllers/controller_host_home.dart';
import '../../../controllers/home_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_svg.dart';

class ScreenHostSetting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    RxBool isNotification = true.obs;
    ControllerHostHome controller = Get.put(ControllerHostHome());
    // Check if controller.user.value is not null before accessing its properties
    if (controller.user.value != null) {
      // Use the null aware operator ?? to provide a default value if notification is null
      isNotification.value = controller.user.value!.notification ?? false;
    }
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            onTap: () {},
            leading: Container(
              height: 36.h,
              width: 36.w,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8.r)
              ),
              child: CustomSvg(
                name: "notification-setting",
              ),

            ),
            title: Text("Notifications", style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 15.sp
            ),),
            trailing: Obx(() {
              return Switch(
                value: isNotification.value, onChanged: (bool value) async{
                isNotification.value= value;
                await usersRef.doc(controller.user.value!.uid).update({
                  "notification": isNotification.value,
                });
              },);
            }),
          ),
          ListTile(
            onTap: (){
              Get.to(ScreenTermsAndConditions());
            },
            leading: Container(
              height: 36.h,
              width: 36.w,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8.r)
              ),
              child: CustomSvg(
                name: "terms",
              ),

            ),
            title: Text("Terms & Conditions",style: TextStyle(
                fontWeight: FontWeight.w700,fontSize: 15.sp
            ),),
            trailing: CustomSvg(name: "arrow-forward",),
          ),
          ListTile(
            onTap: (){
              Get.to(ScreenPrivacyPolicy());
            },
            leading: Container(
              height: 36.h,
              width: 36.w,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8.r)
              ),
              child: CustomSvg(
                name: "policy",
              ),

            ),
            title: Text("Privacy Policy",style: TextStyle(
                fontWeight: FontWeight.w700,fontSize: 15.sp
            ),),
            trailing: CustomSvg(name: "arrow-forward",),
          ),
          ListTile(
            onTap: (){
              Get.defaultDialog(
                  title: '',
                  content: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                          padding: EdgeInsets.all(12.sp),
                          margin: EdgeInsets.symmetric(horizontal:12.sp),
                          decoration: BoxDecoration(
                              color: Color(0xFFF0F0F0),
                              shape: BoxShape.circle
                          ),
                          child: Icon(Icons.clear,color: Colors.black,)),
                    ),
                  ),
                  actions: [
                    Column(
                      children: [
                        Container(
                          height: 55.h,
                          width: 55.w,
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                              color: Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(20.r)),
                          child: CustomSvg(
                            name: "block",
                            color: Color(0xffeb141b),
                          ),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Text(
                          "Delete",
                          style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.w700,fontFamily: "UrbanistBold",),
                        ),
                        SizedBox(
                          height: 13.sp,
                        ),
                        SizedBox(
                          height: 36.h,
                          width: 230.w,
                          child: Text(
                            textAlign: TextAlign.center,
                            "Are you sure you want to Delete Account?",
                            style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w600,fontFamily: "UrbanistBold",),
                          ),
                        ),
                        CustomButton(
                          color: Color(0xffeb141b),
                            width: 193.w,
                            title: "Yes, Delete",
                            onPressed: () {
                              Get.back();
                            }).marginSymmetric(vertical: 20.h)
                      ],
                    )
                  ]);
            },
            leading: Container(
              height: 36.h,
              width: 36.w,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8.r)
              ),
              child: CustomSvg(
                name: "delet",
              ),

            ),
            title: Text("Delete Account",style: TextStyle(
                fontWeight: FontWeight.w700,fontSize: 15.sp
            ),),
            trailing: CustomSvg(name: "arrow-forward",),
          ),


        ],
      ),
    ));
  }
}
