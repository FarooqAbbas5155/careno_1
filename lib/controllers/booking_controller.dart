import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';

class BookingController extends GetxController {
  Rx<String> bookingType = "Per day".obs;
  RxDouble MinTime=1.0.obs;
  RxDouble endTime=24.0.obs;
  RxDouble NewTime=1.0.obs;
  RxDouble endMinTime=1.0.obs;
  RxDouble startTime=1.0.obs;
  RxDouble  hoursDifference = 0.0.obs;
  RxDouble StartMinTimeDay = 1.0.obs;
  // RxDouble EndTimeDay1 = 1.0.obs;
  // RxDouble EndMinTimeDay = 1.0.obs;
  // RxDouble EndTimeDay2 = 24.0.obs;
  RxInt percentage = 15.obs;
  RxDouble TotalVehicleRent = 0.0.obs;

  RxDouble price = 0.0.obs;
  // RxDouble bookingPrice=1.0.obs;
  TextEditingController priceController=TextEditingController();
  Rx<DateTime?> bookingEndDate = Rx<DateTime?>(DateTime.now());
  Rx<DateTime?> bookingStartDate = Rx<DateTime?>(DateTime.now());
  Rx<DateTime?> bookingStartDateHour = Rx<DateTime?>(DateTime.now());
  Rx<String >paymentType = "CreditCard".obs;
  List<DateTime?> dates = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
  ];
  List<DateTime?> selectDates = [
  DateTime.now(),
  ];


 void calculateHoursDifference() {
   hoursDifference.value = endTime.value - startTime.value;
    if ( hoursDifference.value < 0) {
      hoursDifference.value += 24; // Adjust for cases where drop time is before pick time
    }
   hoursDifference.value =  hoursDifference.value;
  }



}