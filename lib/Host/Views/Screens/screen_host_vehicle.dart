import 'package:careno/Host/Views/Layouts/layout_host_active_vehicle.dart';
import 'package:careno/Host/Views/Layouts/layout_host_pending_vehicle.dart';
import 'package:careno/Host/Views/Screens/screen_host_add_vehicle.dart';
import 'package:careno/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScreenHostVehicle extends StatelessWidget {
  const ScreenHostVehicle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text("My Vehicle"),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(55.h),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w
                ),
                decoration: BoxDecoration(
                    color: Color(0xFFE0E0E0).withOpacity(.5),
                    borderRadius: BorderRadius.circular(100.r)),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                  ),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF151515),
                      fontWeight: FontWeight.w600
                  ),
                  // indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    color: AppColors.appPrimaryColor
                  ),
                  tabs: [
                    Tab(text: "Pending Vehicles",),
                    Tab(text: "Active Vehicles",)
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              LayoutHostPendingVehicle(),
              LayoutHostActiveVehicle()
            ],
          ),
          floatingActionButton: FloatingActionButton(onPressed: () {
            Get.to(ScreenHostAddVehicle(

            ));
          },
          child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
