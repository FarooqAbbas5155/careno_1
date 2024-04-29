import 'package:careno/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking.dart';
import 'item_user_booking.dart';

class LayoutCompletedBooking extends StatelessWidget {
  List<Booking> completedList;
  HomeController controllerHome=Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controllerHome.completedBookingsList.value.isNotEmpty?ListView.builder(
        itemCount: controllerHome.completedBookingsList.value.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemUserBooking(booking: controllerHome.completedBookingsList.value[index]);
        },):Center(child: Text("No Completed Booking Yet"),);
    });
  }

  LayoutCompletedBooking({
    required this.completedList,
  });
}
