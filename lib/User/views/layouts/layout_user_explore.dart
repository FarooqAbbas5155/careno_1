import 'package:careno/User/views/layouts/layout_user_explore_list.dart';
import 'package:careno/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'layout_vehicle_google_map.dart';

class LayoutUserExplore extends StatefulWidget {
  @override
  State<LayoutUserExplore> createState() => _LayoutUserExploreState();
}

class _LayoutUserExploreState extends State<LayoutUserExplore> {
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    print(controller.addhostvehicle.value.length);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Obx(() {
          return controller.changeHomeLayout.value == 0
              ? LayoutUserExploreList(controller: controller)
              : LayoutVehicleGoogleMap(controllerHome: controller);
        }),
      ),
    );
  }
}
