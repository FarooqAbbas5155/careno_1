import 'package:careno/models/categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';

class ItemLayoutExploreImage extends StatelessWidget {
Category category;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              // Replace 'imageUrl' with the URL of the image from Firebase Storage
              image: NetworkImage(category.image),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // CircleAvatar(
        //   radius: 35.r,
        //   backgroundColor: Colors.red,
        //  backgroundImage: AssetImage("assets/images/explore_car.png",),
        //
        // ),
        Expanded(
          child: Text(
            category.name,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Urbanist",
                height: 0,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                overflow: TextOverflow.ellipsis
            ),
          ),
        )
      ],
    ).marginSymmetric(horizontal: 5.w);
  }

ItemLayoutExploreImage({
    required this.category,
  });
}
