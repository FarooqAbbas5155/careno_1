import 'dart:io';
import 'dart:math';

import 'package:careno/constant/colors.dart';
import 'package:careno/constant/location_utils.dart';
import 'package:careno/controllers/controller_edit_profile.dart';
import 'package:careno/controllers/home_controller.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:careno/widgets/custom_edit_text_filed.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../AuthSection/screen_allow_location.dart';
import '../../../constant/helpers.dart';
import '../../../controllers/controller_host_home.dart';

class ScreenHostEditProfile extends StatelessWidget {
  String userType;
  ControllerHostHome controller = Get.put(ControllerHostHome());

  @override
  Widget build(BuildContext context) {
    ControllerEditProfile controllerEditProfile = Get.put(
        ControllerEditProfile());
    controllerEditProfile.selectedGender.value = controller.user.value!.gender ?? "";
    controllerEditProfile.dateTime.value=DateTime.fromMillisecondsSinceEpoch(controller.user.value!.dob);
    controllerEditProfile.editLat.value = controller.user.value!.lat ?? 0.0;
    controllerEditProfile.editLng.value = controller.user.value!.lng ?? 0.0;
    // String des=controller.user.value!.profileDescription;
    // controllerEditProfile.editEmail!.value.text = controller.user.value!.email ?? "";
    // controllerEditProfile.editName.value!.text =  controller.user.value!.name ?? "";
    // controllerEditProfile.editPhone.value!.text = controller.user.value!.phoneNumber ?? "";
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Edit Profile"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Align(
              alignment: Alignment.center,
              child: Obx(() {
                print(controller.user.value!.imageUrl);
                return Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.appPrimaryColor),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: controllerEditProfile.images.value.path == "" ?
                          NetworkImage(controller.user.value!.imageUrl)
                              : FileImage(controllerEditProfile.images!
                              .value) as ImageProvider
                      )
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.appPrimaryColor
                      ),
                      child: GestureDetector(
                          onTap: () {
                            controllerEditProfile.getImage();
                          },
                          child: CustomSvg(name: "camera",)),
                    ),),
                );
              }),
            ).marginSymmetric(vertical: 15.h),
            CustomEditTextField(
                labelText: "Full Name",
                hint: controller.user.value!.name,
                controller: controllerEditProfile.editName.value,
              text: controller.user.value!.name,
              // TextEditingController(text: "Jenny Wilson"),
            ),
            CustomEditTextField(
              controller: controllerEditProfile.editEmail.value,
              labelText: "Email",
              hint: controller.user.value!.email,
              text: controller.user.value!.email,
            ),
            Obx(() {
              DateTime dobDateTime = DateTime.fromMillisecondsSinceEpoch(controller.user.value!.dob);
              String formattedDate = DateFormat('d MMMM yyyy ').format(dobDateTime);

              return CustomEditTextField(

                labelText: "Date of Birth",
                padding: EdgeInsets.only(left: 18.w, top: 22.h),
                readOnly: true,
                hint: controllerEditProfile.dateTime.value == null
                    ? "${formattedDate}"
                    : "${controllerEditProfile.dateTime.value
                    ?.day}/${controllerEditProfile.dateTime.value
                    ?.month}/${controllerEditProfile.dateTime.value?.year}",
                hintColor: controllerEditProfile.dateTime.value == null ? Color(
                    0xff94979F).withOpacity(.7) : Colors.black,
                // controller: TextEditingController.edi,
                suffix: IconButton(
                  icon: SvgPicture.asset(
                    "assets/images/picker.svg", width: 30.w,),
                  onPressed: () {
                    controllerEditProfile.selectDate(context);
                  },).marginOnly(top: 4.h),
              );
            }),
            Obx(() {
              return CustomEditTextField(
                labelText: "Gender",
                padding: EdgeInsets.only(left: 18.w, top: 22.h),
                readOnly: true,
                hintColor: controllerEditProfile.selectedGender.value.isEmpty
                    ? Colors.black.withOpacity(.5)
                    : Colors.black,

                hint: controllerEditProfile.selectedGender.value.isEmpty
                    ? controller.user.value!.gender
                    : controllerEditProfile.selectedGender.value,
                suffix: PopupMenuButton(
                  icon: Icon(Icons.expand_more),
                  color: Theme
                      .of(context)
                      .primaryColor,
                  itemBuilder: (BuildContext context) {
                    return ['Male', 'Female',].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice, style: TextStyle(
                            color: Colors.white, fontFamily: "Urbanist"),),
                      );
                    }).toList();
                  },
                  onSelected: (String choice) {
                    // Update selected gender when an option is chosen
                    controllerEditProfile.selectedGender.value = choice;
                  },
                ).marginOnly(top: 4.h),
              );
            }),
            if(userType == "host") CustomEditTextField(
              controller: controllerEditProfile.editPhone.value,
              labelText: "Phone(Optional)",
              hint: controller.user.value!.phoneNumber,
              text: controller.user.value!.phoneNumber,
              hintColor: controllerEditProfile.editPhone.value == null
                  ? Colors.black.withOpacity(.5)
                  : Colors.black,
            ),

            FutureBuilder<String?>(
                future: getAddressFromLatLng(
                    controller.user.value!.lat, controller.user.value!.lng),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> locationSnapshot) {
                  if (locationSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator.adaptive());
                  }

                  if (locationSnapshot.hasError ||
                      locationSnapshot.data == null) {
                    // Handle the error or null case here
                    return TextButton(
                        onPressed: () {},
                        child: Text(
                            'Error loading location,try again'));
                  }
                  controllerEditProfile.editAddress.value.text =
                      locationSnapshot.data;

                  return CustomEditTextField(
                    labelText: "Address",
                    controller: controllerEditProfile.editAddress.value,
                    padding: EdgeInsets.only(left: 18.w, top: 1.h),
                    hint: controllerEditProfile.editAddress.value.text,
                    suffix: InkWell(
                        onTap: () {
                          Get.to(ScreenAllowLocation());
                        },
                        child: SvgPicture.asset("assets/images/location.svg")
                            .marginOnly(top: 4.h)),
                  );
                }),


            CustomEditTextField(
                controller: controllerEditProfile.editProfileDescription.value,
                labelText: "Profile Description",
                text: controller.user.value!.profileDescription,
                hint: controller.user.value!.profileDescription,
            ),
            Obx(() {
              return CustomButton(
                  isLoading: controllerEditProfile.loading.value,
                  width: 310.w,
                  title: "Upadte Changes",
                  onPressed: () async {
                    var response = await controllerEditProfile.upDateProfile();
                    controllerEditProfile.update();
                    if (response == "success") {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          content: Text("Profile Updated Successfully")));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          content:
                          Text(response)));
                    }
                  });
            }).marginOnly(top: 8.h)

          ],).marginSymmetric(horizontal: 24.w),
        ),
      ),
    );
  }

  ScreenHostEditProfile({
    required this.userType,
  });
}
