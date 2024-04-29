import 'dart:developer';
import 'dart:io';

import 'package:careno/User/views/screens/screen_user_home.dart';
import 'package:careno/constant/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Host/Views/Screens/screen_host_add_ident_identity_proof.dart';
import '../constant/firebase_utils.dart';

class ControllerUpdateProfile extends GetxController {
  RxString userType = 'user'.obs;
  RxString address = ''.obs;
  RxBool loading = false.obs;
  Rx<TextEditingController> fullName = TextEditingController().obs;
  Rx<TextEditingController> controllerLocation = TextEditingController().obs;
  Rx<TextEditingController> email = TextEditingController().obs;
  Rx<TextEditingController> profileDescription = TextEditingController().obs;
  RxString selectedGender = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool checkBox = false.obs;
  Rx<File> images = Rx<File>(File(''));

  RxString gender = "Male".obs;

  RxBool permissionStatus = false.obs;

  Rx<DateTime?> Dob = Rx<DateTime?>(null);

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1800, 1, 01),
        lastDate: DateTime(2101, 12, 01));
    if (picked != null && picked != Dob) {
      Dob.value = picked;
    }
  }

  Future<String> UpdateProfileData() async {
    String response = '';
    String name = fullName.value.text.trim();
    String userEmail = email.value.text.trim();
    String description = profileDescription.value.text.trim();
    var _uid = FirebaseAuth.instance.currentUser!.uid;

    if (name.isEmpty &&
        userEmail.isEmpty &&
        description.isEmpty &&
        Dob.value == null &&
        selectedGender.isEmpty &&
        images.value == null) {
      return "All Fields Required"; // Return here to exit the function if fields are empty
    }

    loading.value = true;
    try {
      String url = await FirebaseUtils.uploadImage(images.value.path, "Careno/Users/ProfileImages/${_uid}").catchError((error){
        loading.value = false;
        log(error.toString());
      });

      log(_uid);

      await usersRef.doc(_uid).update({
        "name": name,
        "userType": userType.value,
        "email": userEmail,
        "profileDescription": description,
        "imageUrl": url,
        "address": address.value,
        "dob": Dob.value!.millisecondsSinceEpoch,
        "gender": selectedGender.value,
        "lat": latitude.value,
        "lng": longitude.value,
      });
      response = "success";
      loading.value = false;
      if (userType.value == "host") {
        Get.offAll(ScreenHostAddIdentIdentityProof());
      } else {
        Get.offAll(ScreenUserHome());
      }
    } catch (error) {
      response = error.toString();
      loading.value = false;
    }
    return response;
  }
  RxBool loadingUserType = false.obs;
  // Future<String> updateUserType() async {
  //   String response="";
  //   loadingUserType.value=true;
  //   var id=FirebaseAuth.instance.currentUser!.uid;
  //   await usersRef.doc(id).update({"userType":userType.value}).then((value) {
  //     response ="success";
  //     loadingUserType.value=false;
  //   }).catchError((error){
  //     response=error.toString();
  //     loadingUserType.value=false;
  //   });
  //   return response;
  // }
}
