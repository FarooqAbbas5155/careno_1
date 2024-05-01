import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FullImageView extends StatelessWidget {
  String imageUrl;
  String? des;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: des!.isNotEmpty?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              imageUrl, // Path to your full image
              fit: BoxFit.contain, // Adjust as per your requirement
            ).marginSymmetric(vertical: 20.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 18.w),
              child: Text(des!,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontFamily: "Nunito"),),
            )
          ],
        ),
      ): Center(
        child: Image.network(
          imageUrl, // Path to your full image
          fit: BoxFit.contain, // Adjust as per your requirement
        ),
      ),
    );
  }

  FullImageView({
    required this.imageUrl,
     this.des,
  });
}
