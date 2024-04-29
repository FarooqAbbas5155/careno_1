import 'package:careno/Host/Views/Layouts/item_host_booking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/controller_host_home.dart';
import '../../../models/booking.dart';

class LayoutHostPendingBooking extends StatelessWidget {
List<Booking> pendingList;
ControllerHostHome controllerHostHom=Get.put(ControllerHostHome());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controllerHostHom.requestedBookingsList.value.isNotEmpty?ListView.builder(
        itemCount: controllerHostHom.requestedBookingsList.value.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemHostBooking(booking: controllerHostHom.requestedBookingsList.value[index]);
        },):Center(child: Text("No Booking Yet"),);
    });
  }

LayoutHostPendingBooking({
    required this.pendingList,
  });
}
