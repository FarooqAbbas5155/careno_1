import 'package:careno/Host/Views/Layouts/layout_host_active_booking.dart';
import 'package:careno/Host/Views/Layouts/layout_host_completed_booking.dart';
import 'package:careno/Host/Views/Layouts/layout_host_pending_booking.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/controllers/controller_host_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/firebase_utils.dart';
import '../../../constant/helpers.dart';
import '../../../models/booking.dart';

class LayoutHostBooking extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ControllerHostHome controllerHostHom=Get.put(ControllerHostHome());
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Bookings",
              style: TextStyle(
                  color: AppColors.appPrimaryColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800)),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.h),
            child: Container(
              height: 45.h,
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(
                  color: AppColors.appPrimaryColor
                )
              ),
              child: TabBar(

                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2,
                indicatorPadding: EdgeInsets.zero,
                dividerColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: AppColors.appPrimaryColor
                ),
                unselectedLabelStyle: TextStyle(
                  color: AppColors.blackLightColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Nunito"
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Nunito"
                ),
                tabs: [
                  Tab(
                    text: "Pending",
                  ),
                  Tab(
                    text: "Active",
                  ),
                  Tab(
                    text: "Completed",
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(children: [
          LayoutHostPendingBooking(pendingList:controllerHostHom.requestedBookingsList),
          LayoutHostActiveBooking (activeList:controllerHostHom.startedBookingsList),
          LayoutHostCompletedBooking(completedList:controllerHostHom.completedBookingsList),
        ],)
      ),
    );
  }

}
