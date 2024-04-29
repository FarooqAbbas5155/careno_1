import 'package:careno/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking.dart';
import 'item_user_booking.dart';

class LayoutActiveBooking extends StatelessWidget {
  List<Booking> activeList;
  HomeController controllerHome=Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controllerHome.startedBookingsList.value.isNotEmpty?ListView.builder(
        itemCount: controllerHome.startedBookingsList.value.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemUserBooking(booking: controllerHome.startedBookingsList.value[index]);
        },):Center(child: Text("No Active Booking Yet"),);
    });
  }

  LayoutActiveBooking({
    required this.activeList,
  });
}
