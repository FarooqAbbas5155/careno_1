import 'package:careno/controllers/controller_host_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking.dart';
import 'item_host_booking.dart';

class LayoutHostActiveBooking extends StatelessWidget {
List<Booking> activeList;
  @override
  Widget build(BuildContext context) {
    ControllerHostHome controllerHostHome=Get.put(ControllerHostHome());

    return Obx(() => controllerHostHome.startedBookingsList.value.isNotEmpty?ListView.builder(
      itemCount: controllerHostHome.startedBookingsList.value.length,
      itemBuilder: (BuildContext context, int index) {
        return ItemHostBooking(booking: controllerHostHome.startedBookingsList.value[index]);
      },):Center(child: Text("No Active Booking Yet"),));
  }

LayoutHostActiveBooking({
    required this.activeList,
  });
}
