import 'dart:developer';

import 'package:careno/constant/helpers.dart';
import 'package:careno/controllers/home_controller.dart';
import 'package:careno/extensions/num_extensions.dart';
import 'package:careno/models/booking.dart';
import 'package:careno/models/rating.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ControllerReview extends GetxController {
  TextEditingController reviewController = TextEditingController();
  RxString type = "Good".obs;
  RxDouble rating = 3.0.obs;
RxBool isLoading=false.obs;
  Future<String> submitReview(Booking booking) async {

    String response = "";
    String description = reviewController.text.trim();
    if (description.isNotEmpty) {
      isLoading.value=true;
      Rating _rating = Rating(
          bookingId: booking.bookingId,
          vehicleId: booking.vehicleId,
          userId: booking.userId,
          id: booking.bookingId,
          description: description,
          type: type.value,
          avgRating: rating.value,
          timeStamp: DateTime.now().millisecondsSinceEpoch);
      await reviewRef.doc(_rating.id).set(_rating.toMap()).then((value) async {
        var overallRating = await Get.find<HomeController>().calculateOverallRating(
            Get.find<HomeController>().ratedVehicleList.value, booking.vehicleId,rating.value);
        log(overallRating.toString());
        await bookingsRef.doc(booking.bookingId).update({
          "isRated": true
        });
        await addVehicleRef.doc(booking.vehicleId).update({
          "rating": overallRating.roundToNum(1)
        });
        response = "success";
      });
     isLoading.value=false;
    }
    else{
      response = "Please write a review";
    }
    return response;
  }
}
