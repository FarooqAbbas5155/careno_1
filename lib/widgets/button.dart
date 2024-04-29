import 'package:careno/constant/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  final String title;
  final Color? color;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  Button({
    required this.title,
    this.color,
    required this.onPressed,
    this.width,
    this.height,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  width?? 331.w,
      height: height?? 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            side: BorderSide(width: 2,color: primaryColor),
            backgroundColor:  Colors.white,
            foregroundColor: Colors.white,
            // elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            )
        ),
        child: Padding(
          padding:  EdgeInsets.all(12.sp),
          child: Text(
            title,
            style:  TextStyle(fontSize: 18.sp,fontFamily: "UrbanistBold", fontWeight: FontWeight.bold,color: primaryColor),
          ),
        ),
      ),
    );
  }
}
