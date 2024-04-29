import 'package:careno/Host/Views/Screens/screen_host_add_vehicle.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScreenHostAccountPending extends StatelessWidget {
  const ScreenHostAccountPending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3),(){
      Get.to(ScreenHostAddVehicle());
    });
    return SafeArea(
      child: Scaffold(
        
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomSvg(name: "pending",),
            Text("Thank you for your trust. Your request has been sent. We will try to approve you as soon as possible. Please check your email for approval status.",style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(.8),

            ),
            textAlign: TextAlign.center,
            ).marginOnly(top: 30.h)
          ],
        ).marginSymmetric(horizontal: 28.w
        ),
      ),
    );
  }
}
