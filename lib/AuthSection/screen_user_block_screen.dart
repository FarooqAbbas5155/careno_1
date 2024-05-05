import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/custom_svg.dart';

class ScreenUserBlockScreen extends StatelessWidget {
  const ScreenUserBlockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomSvg(name: "block",),
            Text(
              "Your account has been blocked due to unusual activity",
              style: TextStyle(
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
