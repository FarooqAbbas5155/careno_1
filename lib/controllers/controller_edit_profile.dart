import 'dart:developer';
import 'dart:io';
import 'package:careno/constant/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/firebase_utils.dart';

class ControllerEditProfile extends GetxController{

  Rx<DateTime?> dateTime = Rx<DateTime?>(DateTime.now());
  RxString selectedGender = ''.obs;
  Rx<File> images = Rx<File>(File(''));
  Rx<TextEditingController> editName = TextEditingController().obs;
  Rx<TextEditingController> editEmail = TextEditingController().obs;
  Rx<TextEditingController> editProfileDescription = TextEditingController().obs;
  Rx<TextEditingController> editPhone = TextEditingController().obs;
  Rx<TextEditingController> editAddress = TextEditingController().obs;
  RxString editGender = "".obs;
  RxDouble editLat = 0.0.obs;
  RxDouble editLng = 0.0.obs;
  RxBool loading = false.obs;


  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1800, 1,01),
        lastDate: DateTime(2101,12,01));
    if (picked != null && picked != dateTime) {

      dateTime.value = picked;

    }
  }
  Future<String> upDateProfile() async{
    String url = "";
    String response = "";
    String name = editName.value.text.trim();
    String email = editEmail.value.text.trim();
    String profileDescription = editProfileDescription.value.text.trim();
    String phone = editPhone.value.text.trim();

    if (images.value.path == "") {
      await usersRef.doc(uid).update({
        "name":name,
        "email":email,
        "gender":selectedGender.value,
        "profileDescription":profileDescription,
        "lat":editLat.value,
        "lng":editLng.value,
        "phoneNumber":phone,
        "dob":dateTime.value!.millisecondsSinceEpoch,

      }).then((value) {
        response == "success";
        loading.value = false;
      }).catchError((error){
        response = "success";
        loading.value = false;
        print(error.toString());
        response = error.toString();
        loading.value = false;

      }
      );
    }

    else{
      loading.value = true;
      url = await FirebaseUtils.uploadImage(images.value.path, "Careno/Users/ProfileImages/${FirebaseUtils.myId}").catchError((error){
        log(error.toString());
      });
      await usersRef.doc(uid).update({
        "name":name,
        "email":email,
        "gender":selectedGender.value,
        "profileDescription":profileDescription,
        "imageUrl":url,
        "lat":editLat.value,
        "lng":editLng.value,
        "phoneNumber":phone,
        "dob":dateTime.value!.millisecondsSinceEpoch,
      }).then((value) {
        response == "success";
        loading.value = false;

      }).catchError((error){
        response = "success";
        loading.value = false;
        print(error.toString());
        response = error;
        loading.value = false;

      }
      );
    }

  return response;
  }
  Future<void> getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      print("Image selection cancelled.");
      return;
    }

    final imageFile = File(image.path);
    if (!imageFile.existsSync()) {
      print("Image file does not exist at path: ${imageFile.path}");
      return;
    }

    try {
      this.images.value = imageFile;
      print("Image Path: ${images.value}");
    } catch (error) {
      print("Error setting image: $error");
    }
  }

}