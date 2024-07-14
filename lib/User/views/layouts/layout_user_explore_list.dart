import 'package:card_swiper/card_swiper.dart';
import 'package:careno/models/promotion_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

import '../../../models/add_host_vehicle.dart';
import '../screens/full_image_view.dart';
import '../screens/screen_filter.dart';
import '../screens/screen_preview_category.dart';
import '../screens/screen_search_result.dart';
import 'item_layout_explore_image.dart';
import 'item_layout_explore_popular.dart';
import 'layout_vehicle_google_map.dart';
class LayoutUserExploreList extends StatelessWidget {
HomeController controller = Get.put(HomeController());
var des;
  @override
  Widget build(BuildContext context) {
    controller.popularVehicle.where((p0) => p0.hostId == FirebaseAuth.instance.currentUser!.uid).toList();
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
                StreamBuilder<QuerySnapshot>(
                  stream: bannerRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: AppColors.appPrimaryColor,
                        ),
                      );
                    }

                    var banners = snapshot.data!.docs.map((e) =>
                        PromotionBanner.fromMap(e.data() as Map<String, dynamic>)).toList();

                    // Define index here
                    int index = 0;

                    return banners.isNotEmpty ? ConstrainedBox(
                      child: Stack(
                        children: [
                          Swiper(
                            outer: false,
                            itemBuilder: (context, i) {
                              index = i; // Assign the current index to the outer variable
                              var banner = banners[i];
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8.h),
                                height: 177.h,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Swiper(
                                  itemBuilder: (BuildContext context, int imageIndex) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Pass the tapped image URL to FullImageView
                                        Get.to(FullImageView(imageUrl: banner.imageList[imageIndex],des: banners[index].description,));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.r),
                                        ),
                                        child: Image.network(
                                          banner.imageList[imageIndex],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                  pagination: SwiperPagination(
                                    margin: EdgeInsets.symmetric(vertical: 15.h),
                                  ),
                                  itemCount: banner.imageList.length,
                                ),
                              );
                            },
                            itemCount: banners.length,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              color: Colors.transparent,
                              child: Text(
                                banners.isNotEmpty ? banners[index].description : '',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.appPrimaryColor,
                                  fontFamily: "Nunito"
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      constraints: BoxConstraints.loose(Size(Get.width, 177.0.h)),
                    ) : Container(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      height: 177.h,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.appPrimaryColor,
                            Colors.white
                          ],
                          begin: Alignment.topCenter,
                          end: FractionalOffset.bottomCenter,
                        ),
                      ),
                    );
                  },
                ),
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
                Obx(() =>  controller.popularVehicle.value.isNotEmpty ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.popularVehicle.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    var vehicle =  controller.popularVehicle.value[index];
                    return ItemLayoutExplorePopular(addHostVehicle: vehicle,);
                  },
                ):Align(
                  alignment: Alignment.center,
                  child: Text("........",style: TextStyle(color: AppColors.appPrimaryColor,fontWeight: FontWeight.w800),),
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
