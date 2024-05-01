import 'package:careno/Host/Views/Layouts/layout_host_booking.dart';
import 'package:careno/Host/Views/Layouts/layout_host_earning.dart';
import 'package:careno/Host/Views/Layouts/layout_host_profile.dart';
import 'package:careno/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../User/views/layouts/layout_user_messages.dart';
import '../../../User/views/screens/screen_user_home.dart';
import '../../../constant/colors.dart';
import '../../../constant/firebase_utils.dart';
import '../../../constant/helpers.dart';
import '../../../controllers/controller_host_home.dart';
import '../../../widgets/center_floating_button/src/simple_speed_dial.dart';
import '../../../widgets/center_floating_button/src/simple_speed_dial_child.dart';

class ScreenHostHomePage extends StatefulWidget {
  @override
  State<ScreenHostHomePage> createState() => _ScreenHostHomePageState();
}

class _ScreenHostHomePageState extends State<ScreenHostHomePage> with WidgetsBindingObserver {

List<Widget> Layouts=[
  LayoutHostBooking(),
  LayoutUserMessages(),
  LayoutHostEarning(),
  LayoutHostProfile()
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
ControllerHostHome controller=Get.put(ControllerHostHome());

  @override
  Widget build(BuildContext context) {
    // controller.getHostBookingList();
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: SpeedDial(
            child:  Icon(Icons.change_circle),
            speedDialChildren: <SpeedDialChild>[
              SpeedDialChild(
                child:  Icon(Icons.verified_user_outlined,),
                foregroundColor: Colors.white,
                backgroundColor: AppColors.appPrimaryColor,
                label: 'Switch to Buyer Mode',
                onPressed: () async {
                  await usersRef.doc(getUid()).update({
                    "userType": "user"
                  }).then((value) {
                    Get.offAll(ScreenUserHome());

                  });

                },
              ),
            ],
            closedForegroundColor: Colors.black,
            openForegroundColor: Colors.white,
            closedBackgroundColor: Colors.white,
            openBackgroundColor: Colors.black,
            lable: Text("Switch to Buyer Mode"),
          ),
          body: Obx(() {
            return Layouts[controller.selectHostIndex.value];
          }),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            // notchMargin: 10,
            // shape: CircularNotchedRectangle(),
            child: Container(
              height: 70.sp,
              child: Obx(() {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BottomBarItem(
                      icon: "assets/icons/booking.svg",
                      title: "Booking",
                      pageIndex: 0,
                      currentPageIndex: controller.selectHostIndex.value,
                      onTap: (index) {controller.selectHostIndex.value = index;
                        print(index);
                      },
                    ),
                    BottomBarItem(
                      icon: "assets/icons/message.svg",
                      title: "Messaging",
                      pageIndex: 1,
                      currentPageIndex: controller.selectHostIndex.value,
                      onTap: (index) {
                        print(index);

                        controller.selectHostIndex.value = index;
                      },
                    ),
                    BottomBarItem(
                      icon: "assets/icons/earning.svg",
                      title: "Earning",
                      pageIndex: 2,

                      currentPageIndex: controller.selectHostIndex.value,
                      onTap: (index) {
                        print(index);

                        controller.selectHostIndex.value = index;
                      },
                    ),
                    BottomBarItem(
                      icon: "assets/icons/profile.svg",
                      title: "Profile",
                      pageIndex: 3,

                      currentPageIndex: controller.selectHostIndex.value,
                      onTap: (index) {
                        print(index);

                        controller.selectHostIndex.value = index;
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
