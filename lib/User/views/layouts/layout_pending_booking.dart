import 'package:careno/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking.dart';
import 'item_user_booking.dart';

class LayoutPendingBooking extends StatelessWidget {
 List<Booking> pendingList;
 HomeController controllerHome=Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    print("object ${controllerHome.requestedBookingsList.value.length}");
    return Obx(() {
      return controllerHome.requestedBookingsList.value.isNotEmpty?ListView.builder(
        itemCount: controllerHome.requestedBookingsList.value.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemUserBooking(booking: controllerHome.requestedBookingsList.value[index]);
        },):Center(child: Text("No Booking Yet"),);
    });
  }

 LayoutPendingBooking({
    required this.pendingList,
  });
}
