import 'package:careno/User/views/screens/screen_search.dart';
import 'package:careno/User/views/screens/screen_search_filter.dart';
import 'package:careno/User/views/screens/screen_search_result.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/controllers/controller_filter.dart';
import 'package:careno/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../models/add_host_vehicle.dart';
import '../layouts/item_layout_explore_popular.dart';

class ScreenFilter extends StatelessWidget {
  HomeController homeController = Get.put(HomeController());

  void showCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      builder: (BuildContext context) {
        // Return the CommentBottomSheet widget
        return Container(
          margin: EdgeInsets.only(top: 110.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),

          ), // Add your desired top margin here
          child: ScreenSearchFilter(),
        );
      },
    );
  }

  ControllerFilter controller = Get.put(ControllerFilter());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.appPrimaryColor,
            shape: CircleBorder(),
            child: SvgPicture.asset(
              "assets/images/Group.svg", color: Colors.white,
            ),
            onPressed: () {
              showCommentBottomSheet(context);
            },),
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            title: Text(
              "Filter Results",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: "UrbanistBold"),
            ),
            actions: [
              IconButton(onPressed: () {
                Get.to(ScreenSearch());
              }, icon: Icon(Icons.search, color: Colors.black,))
            ],
            centerTitle: true,
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: Obx(() {
              return (controller.filterVehicle.isEmpty)?
              Center(child: Text("Make Custom Filtration")):
              ListView.builder(
                itemCount: controller.filterVehicle.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemLayoutExplorePopular(
                    addHostVehicle: controller.filterVehicle[index],);
                },);
            }),
          ),
        ));
  }
}
