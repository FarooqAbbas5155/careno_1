import 'dart:developer';

import 'package:careno/constant/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Host/Views/Screens/screen_host_home_page.dart';
import '../constant/firebase_utils.dart';
import '../models/add_host_vehicle.dart';

class ControllerHostAddVechicle extends GetxController {
  TextEditingController vehicleModel = TextEditingController();
  TextEditingController vehicleYear = TextEditingController();
  TextEditingController vehicleSeats = TextEditingController();
  TextEditingController vehicleNumberPlate = TextEditingController();
  TextEditingController vehicleColor = TextEditingController();
  TextEditingController vehicleLicenseExpiryDate =
  TextEditingController();
  TextEditingController vehiclePerDayRent = TextEditingController();
  TextEditingController vehiclePerHourRent = TextEditingController();
  TextEditingController vehicleDescription = TextEditingController();
  RxString search = "".obs;
  RxString currency = "\$".obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;


  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString address = ''.obs;

  RxString vehiclePath = "".obs;
  RxString vehicleRightSidePaths = "".obs;
  RxString vehicleInteriorPaths = "".obs;
  RxList<String> vehicleMore = RxList([]);
  RxList<String> imagesUrl = RxList([]);
  RxList<String> uploadedimageUrl = RxList([]);
  RxList<String> uploadedandimagesUrl = RxList([]);
  RxString vehicleRearPaths = "".obs;
  RxString vehicleNumberPlatePath = "".obs;
  RxString vehicleRegistrationProofPath = "".obs;
  RxString selectCategory = "".obs;
  RxString selectCategoryName = "".obs;
  RxString selectFuelType = "".obs;
  RxString selectTransmission = "".obs;
  RxBool showLoading = false.obs;
  String response = "";

  Future<String> hostAddVehicle() async {
    String response = "";
    if (vehicleModel.value.text.isEmpty ||
        vehicleYear.value.text.isEmpty ||
        vehicleSeats.value.text.isEmpty ||
        vehicleNumberPlate.value.text.isEmpty ||
        vehicleColor.value.text.isEmpty ||
        vehicleLicenseExpiryDate.value.text.isEmpty ||
        vehiclePerDayRent.value.text.isEmpty ||
        vehiclePerHourRent.value.text.isEmpty ||
        vehiclePath.value.isEmpty ||
        vehicleRightSidePaths.value.isEmpty ||
        vehicleInteriorPaths.value.isEmpty ||
        vehicleRearPaths.value.isEmpty ||
        vehicleNumberPlatePath.value.isEmpty ||
        vehicleRegistrationProofPath.value.isEmpty ||
        selectCategory.value.isEmpty ||
        selectFuelType.value.isEmpty ||
        address.value.isEmpty ||
        vehicleDescription.value.text.isEmpty ||
        selectTransmission.value.isEmpty) {
      response = "All Fields Required";
    } else {
      showLoading.value = true;
      int id = DateTime.now().millisecondsSinceEpoch;
      String userId = FirebaseAuth.instance.currentUser!.uid;

      String vehiclePathUrl = await FirebaseUtils.uploadImage(vehiclePath.value,
          "Host/addVehicle/${userId}/${id}/vehiclePath");
      String vehicleRightSidePathsUrl = await FirebaseUtils.uploadImage(
          vehicleRightSidePaths.value,
          "Host/addVehicle/${userId}/${id}/vehicleRightSidePaths");
      String vehicleInteriorPathsUrl = await FirebaseUtils.uploadImage(
          vehicleInteriorPaths.value,
          "Host/addVehicle/${userId}/${id}/vehicleInteriorPaths");
      String vehicleNumberPlatePathUrl = await FirebaseUtils.uploadImage(
          vehicleNumberPlatePath.value,
          "Host/addVehicle/${userId}/${id}/vehicleNumberPlatePath");
      String vehicleRegistrationProofPathUrl = await FirebaseUtils.uploadImage(
          vehicleRegistrationProofPath.value,
          "Host/addVehicle/${userId}/${id}/vehicleRegistrationProofPath");
      String vehicleRearPathsUrl = await FirebaseUtils.uploadImage(
          vehicleRearPaths.value,
          "Host/addVehicle/${userId}/${id}/vehicleRearPaths");
      imagesUrl.value = await FirebaseUtils.uploadMultipleImage(
        vehicleMore.value,
        "Host/addVehicle/${userId}/${id}/imageList",
        extension: "png",
      );

      AddHostVehicle addHostVehicle = AddHostVehicle(
        hostId: userId,
        address: address.value,
        vehicleId: id.toString(),
        vehicleImageComplete: vehiclePathUrl,
        vehicleImageNumberPlate: vehicleNumberPlatePathUrl,
        vehicleImageRightSide: vehicleRightSidePathsUrl,
        vehicleImageRear: vehicleRearPathsUrl,
        vehicleImageInterior: vehicleInteriorPathsUrl,
        vehicleModel: vehicleModel.value.text.trim(),
        vehicleSeats: vehicleSeats.value.text.trim(),
        vehicleCategory: selectCategory.value,
        vehicleYear: vehicleYear.value.text.trim(),
        vehicleTransmission: selectTransmission.value,
        vehicleNumberPlate: vehicleNumberPlate.value.text.trim(),
        vehicleColor: vehicleColor.value.text.trim(),
        vehicleLicenseExpiryDate: vehicleLicenseExpiryDate.value.text.trim(),
        vehiclePerDayRent: vehiclePerDayRent.value.text.trim(),
        vehiclePerHourRent: vehiclePerHourRent.value.text.trim(),
        vehicleRegistrationImage: vehicleRegistrationProofPathUrl,
        status: "Pending",
        rating: 0.0,
        latitude: latitude.value,
        longitude: longitude.value,
        vehicleFuelType: selectFuelType.value,
        imagesUrl: imagesUrl.value,
        vehicleDescription: vehicleDescription.value.text.trim(), isVerified: false,
        currency: currency.value,
      );
      await addVehicleRef
          .doc(id.toString())
          .set(addHostVehicle.toMap())
          .then((value) {
        response = "success";
        resetAllVehicleState();
        print(response);
        showLoading.value = false;
        Get.offAll(ScreenHostHomePage());
      }).catchError((error) {
        response = error.toString();
        showLoading.value = false;

        print(response);
      });
    }
    return response;
  }

  ///Update

  RxString vehicleImageCompleteUrl = ''.obs;
  RxString vehicleImageNumberPlateUrl = ''.obs;
  RxString vehicleImageRightSideUrl = ''.obs;
  RxString vehicleImageRearUrl = ''.obs;
  RxString vehicleImageInteriorUrl = ''.obs;
  RxString vehicleRegistrationUrl = ''.obs;
  // List<String> imagesUrls = [];

  void resetAllVehicleState() {
    vehicleModel.clear();
    vehicleYear.clear();
    vehicleSeats.clear();
    vehicleNumberPlate.clear();
    vehicleColor.clear();
    vehicleLicenseExpiryDate.clear();
    vehiclePerDayRent.clear();
    vehiclePerHourRent.clear();
    vehicleDescription.clear();
    latitude.value = 0.0;
    longitude.value = 0.0;
    address.value = '';

    vehiclePath.value = '';
    vehicleRightSidePaths.value = '';
    vehicleInteriorPaths.value = '';
    vehicleMore.clear();
    imagesUrl.clear();
    vehicleRearPaths.value = '';
    vehicleNumberPlatePath.value = '';
    vehicleRegistrationProofPath.value = '';
    selectCategory.value = '';
    selectCategoryName.value = '';
    selectFuelType.value = '';
    selectTransmission.value = '';
  }

  Future<String> UpdateVehicle(AddHostVehicle _addHostVehicle) async {
    String _response = "";
    showLoading.value = true;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    log("1");
    if (vehiclePath.value.isNotEmpty) {
      vehicleImageCompleteUrl.value = await FirebaseUtils.uploadImage(
          vehiclePath.value,
          "User/Host/${userId}/addVehicle/${_addHostVehicle.vehicleId}/vehiclePath");
    }
    log("2");

    if (vehicleRightSidePaths.value.isNotEmpty) {
      vehicleImageRightSideUrl.value = await FirebaseUtils.uploadImage(
          vehicleRightSidePaths.value,
          "User/Host/${userId}/addVehicle/${_addHostVehicle.vehicleId}/vehicleRightSidePaths");
    }
    log("3");

    if (vehicleInteriorPaths.value.isNotEmpty) {
      vehicleImageInteriorUrl.value = await FirebaseUtils.uploadImage(
          vehicleInteriorPaths.value,
          "User/Host/${userId}/addVehicle/${_addHostVehicle.vehicleId}/vehicleInteriorPaths");
    }
    log("4");

    if (vehicleNumberPlatePath.value.isNotEmpty) {
      vehicleImageNumberPlateUrl.value = await FirebaseUtils.uploadImage(
          vehicleNumberPlatePath.value,
          "Host/addVehicle/${userId}/${_addHostVehicle.vehicleId}/image/vehicleNumberPlatePath");
    }
    if (vehicleRegistrationProofPath.value.isNotEmpty) {
      vehicleRegistrationUrl.value = await FirebaseUtils.uploadImage(
          vehicleRegistrationProofPath.value,
          "Host/addVehicle/${userId}/${_addHostVehicle.vehicleId}/image/vehicleRegistrationProofPath");
    }
    if (vehicleRearPaths.value.isNotEmpty) {
      vehicleImageRearUrl.value = await FirebaseUtils.uploadImage(
          vehicleRearPaths.value,
          "Host/addVehicle/${userId}/${_addHostVehicle.vehicleId}/image/vehicleRearPaths");
    }
    if (vehicleMore.value.isNotEmpty) {
      imagesUrl.value = await FirebaseUtils.uploadMultipleImage(
        vehicleMore.value,
        "Host/addVehicle/${userId}/${_addHostVehicle.vehicleId}/image/imageList",
        extension: "png",
      );
    }
    AddHostVehicle addHostVehicle = AddHostVehicle(
        hostId: _addHostVehicle.hostId,
        vehicleId: _addHostVehicle.vehicleId,
        address: address.value,
        vehicleImageComplete: vehicleImageCompleteUrl.value,
        vehicleImageNumberPlate: vehicleImageNumberPlateUrl.value,
        vehicleImageRightSide: vehicleImageRightSideUrl.value,
        vehicleImageRear: vehicleImageRearUrl.value,
        vehicleImageInterior: vehicleImageInteriorUrl.value,
        vehicleModel: vehicleModel.text,
        vehicleCategory: selectCategory.value,
        vehicleYear: vehicleYear.text,
        vehicleSeats: vehicleSeats.text,
        vehicleTransmission: selectTransmission.value,
        vehicleFuelType: selectFuelType.value,
        vehicleNumberPlate: vehicleNumberPlate.text,
        vehicleColor: vehicleColor.text,
        vehicleLicenseExpiryDate: vehicleLicenseExpiryDate.text,
        vehiclePerDayRent: vehiclePerDayRent.text,
        vehiclePerHourRent: vehiclePerHourRent.text,
        vehicleRegistrationImage: vehicleRegistrationUrl.value,
        status: _addHostVehicle.status,
        vehicleDescription: vehicleDescription.text,
        rating: _addHostVehicle.rating,
        latitude: latitude.value,
        longitude: longitude.value,
        imagesUrl: imagesUrl, isVerified: false,
        currency: currency.value);
    log(addHostVehicle.toString());
    await addVehicleRef.doc(addHostVehicle.vehicleId).update(addHostVehicle.toMap());
    // await _updateCommonData(addHostVehicle);
    showLoading.value=false;
    Get.back();
    _response = "Success";
    log(addHostVehicle.toString());

    return _response;
  }

  Future<void> _updateCommonData(AddHostVehicle addHostVehicle) async {
    await addVehicleRef.doc(addHostVehicle.vehicleId).update({
      "vehicleImageComplete": addHostVehicle.vehicleImageComplete,
      "vehicleImageNumberPlate": addHostVehicle.vehicleImageNumberPlate,
      "vehicleImageRightSide": addHostVehicle.vehicleImageRightSide,
      "vehicleImageRear":addHostVehicle.vehicleImageRear,
      "vehicleImageInterior": addHostVehicle.vehicleImageInterior,
      "vehicleModel": addHostVehicle.vehicleModel,
      "address": addHostVehicle.address,
      "vehicleCategory":addHostVehicle.vehicleCategory,
      "vehicleYear": addHostVehicle.vehicleYear,
      "vehicleSeats": addHostVehicle.vehicleSeats,
      "vehicleTransmission": addHostVehicle.vehicleTransmission,
      "vehicleFuelType":addHostVehicle.vehicleFuelType,
      "vehicleNumberPlate": addHostVehicle.vehicleNumberPlate,
      "vehicleColor": addHostVehicle.vehicleColor,
      "vehicleLicenseExpiryDate": addHostVehicle.vehicleLicenseExpiryDate,
      "vehiclePerDayRent": addHostVehicle.vehiclePerDayRent,
      "vehiclePerHourRent": addHostVehicle.vehiclePerHourRent,
      "vehicleDescription": addHostVehicle.vehicleDescription,
      "latitude": addHostVehicle.latitude,
      "vehicleRegistrationImage": addHostVehicle.vehicleRegistrationImage,
      "imagesUrl": addHostVehicle.imagesUrl,
      "longitude": addHostVehicle.longitude,
    });
  }
}
