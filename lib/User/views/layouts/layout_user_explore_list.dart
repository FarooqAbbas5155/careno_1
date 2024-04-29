import 'package:flutter/material.dart';
import 'dart:async';

import 'package:careno/Host/Views/Screens/screen_host_notification.dart';
import 'package:careno/User/views/screens/screen_search_filter.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/screen_filter.dart';
import '../screens/screen_preview_category.dart';
import '../screens/screen_search_result.dart';
import 'item_layout_explore_image.dart';
import 'item_layout_explore_popular.dart';
import 'layout_vehicle_google_map.dart';
class LayoutUserExploreList extends StatelessWidget {
HomeController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 156.h,
          width: Get.width,
          color: primaryColor,
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CARENO HOME",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Urbanist",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(ScreenHostNotification());
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.notifications_none_outlined,
                                  color: primaryColor,
                                  size: 30.sp,
                                ),
                              ),
                              Positioned(
                                top: 8.h,
                                right: 0,
                                left: 10.w,
                                child: Container(
                                  height: 8.h,
                                  width: 8.w,
                                  padding: EdgeInsets.all(1.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    // Set the color to red
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).marginSymmetric(horizontal: 10.w),
                      ),
                      Container(
                        height: 40.h,
                        width: 40.w,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r)),
                        child: GestureDetector(
                          onTap: () {
                            controller.changeHomeLayout.value=1;
                          },
                          child: SvgPicture.asset(
                            "assets/images/export.svg",
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ).marginSymmetric(vertical: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45.h,
                    width: 294.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r)),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Search for City, airport, or a hotel...",
                        hintStyle: TextStyle(
                            color: Color(0xffABABAB),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Urbanist"),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xffABABAB),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        border: InputBorder.none,
                      ),
                      onTap:(){
                        Get.to(ScreenSearchResult());

                      } ,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                      Get.to(ScreenFilter());
                    },
                    child: Container(
                      height: 42.h,
                      width: 42.w,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r)),
                      child: SvgPicture.asset(
                        "assets/images/Group.svg",
                      ),
                    ),
                  ),
                ],
              ).marginSymmetric(vertical: 16.h)
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  alignment: Alignment.center,
                  height: 177.h,
                  width: 345.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.r),
                      image: DecorationImage(
                          image: AssetImage("assets/images/car.png"),
                          fit: BoxFit.fill)),
                ).marginSymmetric(vertical: 14.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: Text(
                    "Explore Categories",
                    style: TextStyle(
                        fontFamily: "UrbanistBold",
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Obx(() {
                  return controller.allCategory.value !=null? Container(
                      color: Colors.white,
                      height: 140.h,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),

                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // Adjust the number of items per row
                          crossAxisSpacing: 2.0,
                          // Adjust spacing between items horizontally
                          mainAxisSpacing:
                          2.0, // Adjust spacing between items vertically
                        ),
                        itemCount: controller.allCategory.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          var category = controller.allCategory.value[index];
                          return InkWell(
                              onTap: () {
                                Get.to(ScreenPreviewCategory(category: category,));
                              },
                              child: ItemLayoutExploreImage(
                                category: category,));
                        },
                      )):Center(
                    child: CircularProgressIndicator(color: AppColors.appPrimaryColor,),
                  );
                }).marginOnly(bottom: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Vehicles",
                      style: TextStyle(
                          fontFamily: "UrbanistBold",
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        Text(
                          "See all ",
                          style: TextStyle(
                              fontFamily: "Urbanist",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: primaryColor),
                        ).marginSymmetric(horizontal: 2.w),
                        SvgPicture.asset("assets/images/see_all.svg")
                      ],
                    ),
                  ],
                ),
                Obx(() =>  controller.addhostvehicle.value != null ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.addhostvehicle.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    var vehicle =  controller.addhostvehicle.value[index];
                    return ItemLayoutExplorePopular(addHostVehicle: vehicle,);
                  },
                ):Center(
                  child: CircularProgressIndicator(color: AppColors.appPrimaryColor,),
                ))
              ],
            ).marginSymmetric(horizontal: 14.w),
          ),
        ),
      ],
    );
  }

LayoutUserExploreList({
  required this.controller,

});
}
