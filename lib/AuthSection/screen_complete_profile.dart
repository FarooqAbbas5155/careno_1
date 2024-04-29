import 'dart:io';

import 'package:careno/AuthSection/screen_allow_location.dart';
import 'package:careno/AuthSection/screen_location.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/controllers/controller_update_profile.dart';
import 'package:careno/widgets/custom_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/location_utils.dart';
import '../widgets/custom_button.dart';

class ScreenCompleteProfile extends StatelessWidget {
  ControllerUpdateProfile controller = Get.put(ControllerUpdateProfile());

  // DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    print("UserType${controller.userType.value}");
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: GetBuilder<ControllerUpdateProfile>(builder: (logic) {
          return FutureBuilder<bool>(
              future: checkPermissionStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(
                    ),
                  );
                }
                if (snapshot.data == false) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Location Access Is Not Granted",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "UrbanistBold",
                            fontSize: 18.sp,
                          ),
                        ).marginSymmetric(vertical: 20.h),
                        CustomButton(
                          width: 200.w,
                          title: 'Retry',
                          onPressed: () {
                            logic.update();
                          },
                        )
                      ],
                    ),
                  );
                }
                return FutureBuilder<Position>(
                    future: Geolocator.getCurrentPosition(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                          ),
                        );
                      }
                      var position = snapshot.data!;
                      controller.permissionStatus.value = true;
                      if (controller.longitude.value==0.0) {
                        controller.latitude.value = position.latitude;
                        controller.longitude.value = position.longitude;
                      }
                      return FutureBuilder<String?>(
                          future: getAddressFromCurrentLocation(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> locationSnapshot) {
                            if (locationSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator.adaptive());
                            }

                            if (locationSnapshot.hasError || locationSnapshot.data == null) {
                              // Handle the error or null case here
                              return Center(
                                  child: TextButton(
                                      onPressed: () {
                                        logic.update();
                                      },
                                      child: Text(
                                          'Error loading location,try again')));
                            }
                            if (controller.address.value=="") {
                              controller.address.value = locationSnapshot.data;
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Let’s Complete Profile",
                                      style: TextStyle(
                                        fontFamily: "Urbanist",
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Center(
                                        child: Stack(
                                      children: [
                                        Obx(() {
                                          return Container(
                                            margin: EdgeInsets.all(16.sp),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6.sp),
                                            height: 90.h,
                                            width: 90.w,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: primaryColor,
                                                  width: 1),
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: controller
                                                            .images.value ==
                                                        ""
                                                    ? AssetImage(
                                                        "assets/images/profile.png")
                                                    : FileImage(controller
                                                            .images.value)
                                                        as ImageProvider, // Image from File object
                                              ),
                                            ),
                                            // child: Obx(() {
                                            //   return CircleAvatar(
                                            //     radius: 10.sp, // Adjust the radius as needed
                                            //     backgroundImage: controller.images.value == ""
                                            //         ? AssetImage(
                                            //         "assets/images/profile.png") as ImageProvider // Default image
                                            //         : FileImage(controller.images
                                            //         .value), // Image from File object
                                            //   );
                                            // }),
                                          );
                                        }),
                                        Positioned(
                                          bottom: 16.w,
                                          left: 68.sp,
                                          right: 0.w,
                                          child: GestureDetector(
                                            onTap: () {
                                              getImage();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        )
                                      ],
                                    )),
                                    Center(
                                        child: Text(
                                      "Add Profile Image",
                                      style: TextStyle(
                                          fontFamily: "Urbanist",
                                          fontSize: 13.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    )),
                                    Text(
                                      "Add Details",
                                      style: TextStyle(
                                          fontFamily: "Urbanist",
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700),
                                    ).marginOnly(
                                      top: 15.h,
                                    ),
                                    CustomTextField(
                                      controller: controller.fullName.value,
                                      padding:
                                          EdgeInsets.only(left: 18.w, top: 1.h),
                                      hint: "Enter Full Name",
                                      hintColor: controller.fullName.value ==
                                              null
                                          ? Color(0xff94979F).withOpacity(.7)
                                          : Colors.black,
                                    ).marginSymmetric(
                                        horizontal: 12.w, vertical: 8.h),
                                    CustomTextField(
                                      controller: controller.email.value,
                                      padding:
                                          EdgeInsets.only(left: 18.w, top: 1.h),
                                      hint: "Enter Email",
                                      hintColor: controller.email.value == null
                                          ? Color(0xff94979F).withOpacity(.7)
                                          : Colors.black,
                                    ).marginSymmetric(
                                        horizontal: 12.w, vertical: 8.h),
                                    Obx(() {
                                      return CustomTextField(
                                        padding: EdgeInsets.only(
                                            left: 18.w, top: 18.h),
                                        readOnly: true,
                                        hint: controller.Dob.value == null
                                            ? "Date of Birth"
                                            : "${controller.Dob.value?.year}/${controller.Dob.value?.month}/${controller.Dob.value?.day}",
                                        hintColor: controller.Dob.value == null
                                            ? Color(0xff94979F).withOpacity(.7)
                                            : Colors.black,
                                        suffix: IconButton(
                                          icon: SvgPicture.asset(
                                            "assets/images/picker.svg",
                                            width: 30.w,
                                          ),
                                          onPressed: () {
                                            controller.selectDate(context);
                                          },
                                        ).marginOnly(top: 4.h),
                                      );
                                    }).marginSymmetric(
                                        horizontal: 12.w, vertical: 8.h),
                                    Obx(() {
                                      return CustomTextField(
                                        padding: EdgeInsets.only(
                                            left: 18.w, top: 18.h),
                                        readOnly: true,
                                        hintColor: controller
                                                .selectedGender.value.isEmpty
                                            ? Color(0xff94979F).withOpacity(.7)
                                            : Colors.black,
                                        hint: controller
                                                .selectedGender.value.isEmpty
                                            ? "Gender"
                                            : controller.selectedGender.value,
                                        suffix: PopupMenuButton(
                                          icon: Icon(Icons.expand_more),
                                          color: Theme.of(context).primaryColor,
                                          itemBuilder: (BuildContext context) {
                                            return [
                                              'Male',
                                              'Female',
                                            ].map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(
                                                  choice,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "Urbanist"),
                                                ),
                                              );
                                            }).toList();
                                          },
                                          onSelected: (String choice) {
                                            // Update selected gender when an option is chosen
                                            controller.selectedGender.value =
                                                choice;
                                          },
                                        ).marginOnly(top: 4.h),
                                      );
                                    }).marginSymmetric(
                                        horizontal: 12.w, vertical: 8.h),
                                    CustomTextField(

                                      // controller: controller.controllerLocation.value,
                                      text: controller.address.value,
                                      padding:
                                          EdgeInsets.only(left: 18.w, top: 10.h),
                                      hint: 'Select Address again',
                                      // Use the address from the snapshot
                                      hintColor:
                                          Color(0xff94979F).withOpacity(.7),
                                      suffix: InkWell(
                                        onTap: () async {
                                          var result=await Get.to(ScreenLocation());
                                          if (result==true) {
                                            controller.update();
                                          }
                                        },
                                        child: SvgPicture.asset(
                                                "assets/images/location.svg")
                                            .marginOnly(top: 4.h),
                                      ),
                                    ).marginSymmetric(
                                        horizontal: 12.w, vertical: 8.h),
                                    CustomTextField(
                                      controller:
                                          controller.profileDescription.value,
                                      padding: EdgeInsets.only(left: 18.w),
                                      hint: "Profile Description",
                                      hintColor: controller
                                                  .profileDescription.value == null
                                          ? Color(0xff94979F).withOpacity(.7)
                                          : Colors.black,
                                    ).marginSymmetric(
                                        horizontal: 12.w, vertical: 8.h),
                                    Center(
                                      child: Obx(() {
                                        return CustomButton(
                                            isLoading: controller.loading.value,
                                            width: 310.w,
                                            title: "Save",
                                            onPressed: () async {
                                              var response = await controller
                                                  .UpdateProfileData();

                                              if (response == "success") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Profile Updated Successfully")));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text(response)));
                                              }
                                            });
                                      }).marginOnly(top: 8.h),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    });
              });
        }),
      ),
    );
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
      this.controller.images.value = imageFile;
      print("Image Path: ${controller.images.value}");
    } catch (error) {
      print("Error setting image: $error");
    }
  }
}
