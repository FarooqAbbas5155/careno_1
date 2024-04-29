import 'package:flutter/material.dart';

import '../../../models/booking.dart';
import 'item_host_booking.dart';

class LayoutHostCompletedBooking extends StatelessWidget {
 List<Booking> completedList;
  @override
  Widget build(BuildContext context) {
    return completedList.isNotEmpty?ListView.builder(
      itemCount: completedList.length,
      itemBuilder: (BuildContext context, int index) {
        return ItemHostBooking(booking: completedList[index]);
      },):Center(child: Text("No Completed Booking Yet"),);
  }

 LayoutHostCompletedBooking({
    required this.completedList,
  });
}
