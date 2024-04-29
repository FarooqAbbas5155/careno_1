import 'package:careno/Host/Views/Layouts/layout_host_booking.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/controllers/home_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constant/firebase_utils.dart';
import '../layouts/layout_user_booking.dart';
import '../layouts/layout_user_explore.dart';
import '../layouts/layout_user_messages.dart';
import '../layouts/layout_user_profile.dart';

class ScreenUserHome extends StatefulWidget {
  @override
  State<ScreenUserHome> createState() => _ScreenUserHomeState();
}

class _ScreenUserHomeState extends State<ScreenUserHome> with WidgetsBindingObserver {

  final widgetOptions = [
    LayoutUserExplore(),
    LayoutUserBooking(),
    LayoutUserMessages(),
    LayoutUserProfile(),
  ];
  void setStatus(String status) async {
    await usersRef.doc(FirebaseUtils.myId).update(
        {"status": status});
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }
@override
  void initState() {
  WidgetsBinding.instance?.addObserver(this);
  setStatus("Online");
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Obx(() {
            return IndexedStack(
              index: controller.selectIndex.value,
              children: [
                LayoutUserExplore(),
                LayoutUserBooking(),
                LayoutUserMessages(),
                LayoutUserProfile(),
              ],
            );
          }),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            // notchMargin: 10,
           // shape: CircularNotchedRectangle(),
            child: Container(
              // height: 70.sp,
              child: Obx(() {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BottomBarItem(
                      icon: "assets/images/car.svg",
                      title: "Explore",
                      pageIndex: 0,
                      currentPageIndex: controller.selectIndex.value,
                      onTap: (index) {
                        controller.selectIndex.value = index;
                        print(index);
                      },
                    ),
                    BottomBarItem(
                      icon: "assets/images/booking.svg",
                      title: "Booking",
                      pageIndex: 1,
                      currentPageIndex: controller.selectIndex.value,
                      onTap: (index) {
                        print(index);

                        controller.selectIndex.value = index;
                      },
                    ),
                    BottomBarItem(
                      icon: "assets/images/messages.svg",
                      title: "Messages",
                      pageIndex: 2,

                      currentPageIndex: controller.selectIndex.value,
                      onTap: (index) {
                        print(index);

                       controller.selectIndex.value = index;
                      },
                    ),
                    BottomBarItem(
                      icon: "assets/images/profile.svg",
                      title: "Profile",
                      pageIndex: 3,

                      currentPageIndex: controller.selectIndex.value,
                      onTap: (index) {
                        print(index);

                        controller.selectIndex.value = index;
                      },
                    ),
                  ],
                );
              }),
            ),
          ),
        ));
  }
}
class BottomBarItem extends StatelessWidget {
  final String icon;
  final String title;
  final int pageIndex;
  final int currentPageIndex;
  final Function(int) onTap;

  const BottomBarItem({
    required this.icon,
    required this.title,
    required this.pageIndex,
    required this.currentPageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = pageIndex == currentPageIndex;
    final color = isSelected ? primaryColor : Colors.grey;

    return TextButton(
      onPressed: () {
        onTap(pageIndex);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon, color: color,),
          // (isSelected) ? SizedBox(height: 5.h) :
          // SizedBox(height: 2.h,),
          Text(
            title,
            style: TextStyle(color: color, fontSize: 11.sp,fontFamily: "QuickSand",fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
