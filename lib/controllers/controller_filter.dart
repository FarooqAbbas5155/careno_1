import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/add_host_vehicle.dart';

class ControllerFilter extends GetxController{
  RxList<AddHostVehicle> filterVehicle= RxList<AddHostVehicle>([]);

  var selectedRange = RangeValues(10, 60).obs;

  Rx<String> sortBy = 'Low To High'.obs;
  Rx<String> selectCategoryName = ''.obs;
  RxDouble rating=0.0.obs;
  Rx<String> selectCategory = ''.obs;
  Rx<String> carBrand = 'Toyota'.obs;
  Rx<String> carModel = ''.obs;
  Rx<String> carTransmission = 'Automatic'.obs;
  Rx<String> carFuelType = 'Gasoline'.obs;
  Rx<String> carSeatsCapacity = '04'.obs;
  Rx<String> carLocation = 'Central park New York'.obs;
}