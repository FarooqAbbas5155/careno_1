import 'dart:io';

import 'package:careno/Host/Views/Screens/screen_host_add_vehicle_location.dart';
import 'package:careno/Host/Views/Screens/screen_host_home_page.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/controllers/controller_host_add_vechicle.dart';
import 'package:careno/models/categories.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:careno/widgets/custom_image.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:careno/widgets/custom_textfiled.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant/colors.dart';
import '../../../constant/file_pick.dart';
import '../../../constant/firebase_utils.dart';

class ScreenHostAddVehicle extends StatelessWidget {
  const ScreenHostAddVehicle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControllerHostAddVechicle controllerAddVehicle = Get.put(ControllerHostAddVechicle());
    print(controllerAddVehicle.showLoading.value);
    // controllerAddVehicle.showLoading.value = false;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.clear),
          ),
        ),
        body: SingleChildScrollView(
          child: GetBuilder<ControllerHostAddVechicle>(builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Now Add Your Vehicle",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24.sp),
                ),
                Wrap(
                  spacing: 20.w,
                  runSpacing: 20.h,
                  children: [
                    Obx(() {
                      return addVehicle(() async {
                        controllerAddVehicle.vehiclePath.value =
                        await FilePick().pickImage(ImageSource.gallery);
                      }, "Vehicle Image must be visible in image",
                          RxString((controllerAddVehicle.vehiclePath
                              .value)));
                    }),
                    Obx(() {
                      return addVehicle(() async {
                        controllerAddVehicle.vehicleNumberPlatePath.value =
                        await FilePick().pickImage(ImageSource.gallery);
                      }, "Car plate number must visible in image",
                          RxString((controllerAddVehicle.vehicleNumberPlatePath
                              .value)));
                    }),
                    Obx(() {
                      return addVehicle(() async {
                        controllerAddVehicle.vehicleRightSidePaths.value =
                        await FilePick().pickImage(ImageSource.gallery);
                      }, "Capture vehicle's right side in the image",
                          RxString((controllerAddVehicle.vehicleRightSidePaths
                              .value)));
                    }),
                    Obx(() {
                      return addVehicle(() async {
                        controllerAddVehicle.vehicleRearPaths.value =
                        await FilePick().pickImage(ImageSource.gallery);
                      }, "Include the rear, with the rear plate",
                          RxString((controllerAddVehicle.vehicleRearPaths
                              .value)));
                    }),
                    Obx(() {
                      return addVehicle(() async {
                        controllerAddVehicle.vehicleInteriorPaths.value =
                        await FilePick().pickImage(ImageSource.gallery);
                      }, "Provide car interior picture",
                          RxString((controllerAddVehicle.vehicleInteriorPaths
                              .value)));
                    }),
                    addVehicle(() async {
                      var path = await PickFile([
                        'png',
                        'jpg',
                        'jpeg'
                      ]).then((value) {
                        controllerAddVehicle.vehicleMore.value =
                            value!.paths
                                .map((e) =>
                                e
                                    .toString())
                                .toList();

                      });
                      controller.update();
                    }, "Add More Images",
                        RxString(''))

                  ],
                ),
                Obx(() {
                  return (controllerAddVehicle.vehicleMore.value.isEmpty)?SizedBox():SizedBox(
                    height: 90.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controllerAddVehicle.vehicleMore.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10.h,right: 10.w),
                          height: 89.h,
                          width: 92.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                      File(controllerAddVehicle.vehicleMore
                                          .value[index])))
                          ),);
                      },),
                  );
                }),
                // buildVehicleContainer(controllerAddVehicle)
                //     .marginSymmetric(horizontal: 40.w, vertical: 20.h),
                Text(
                  "Add Details",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 20.sp),
                ).marginSymmetric(vertical: 10.h),
                CustomTextField(
                  controller: controllerAddVehicle.vehicleModel,
                  hint: "Enter Model of Vehicle",
                  readOnly: controllerAddVehicle.showLoading.value,
                ).marginSymmetric(vertical: 8.h),
                buildCategoryContainer(controllerAddVehicle, context)
                    .marginSymmetric(vertical: 10.h),
                CustomTextField(
                  readOnly: controllerAddVehicle.showLoading.value,


                  controller: controllerAddVehicle.vehicleYear,
                  hint: "Enter Year of Vehicle",
                  keyboardType: TextInputType.number,
                ).marginSymmetric(vertical: 8.h),
                CustomTextField(
                  readOnly: controllerAddVehicle.showLoading.value,

                  controller: controllerAddVehicle.vehicleSeats,
                  hint: "Number of Seats",
                  keyboardType: TextInputType.number,
                ).marginSymmetric(vertical: 8.h),
                buildTransmissionContainer(
                    controllerAddVehicle, context)
                    .marginSymmetric(vertical: 10.h),
                buildFuelContainer(controllerAddVehicle, context),
                CustomTextField(
                  readOnly: controllerAddVehicle.showLoading.value,

                  controller: controllerAddVehicle.vehicleNumberPlate,
                  hint: "Vehicle Plate Number",
                  keyboardType: TextInputType.name,
                ).marginSymmetric(vertical: 8.h),
                CustomTextField(
                  readOnly: controllerAddVehicle.showLoading.value,

                  controller: controllerAddVehicle.vehicleColor,
                  hint: "Enter Vehicle Color",
                  keyboardType: TextInputType.name,
                ).marginSymmetric(vertical: 8.h),
                CustomTextField(
                  readOnly: controllerAddVehicle.showLoading.value,

                  controller: controllerAddVehicle.vehicleLicenseExpiryDate
                  ,
                  hint: "Vehicle License Expiry Date",
                  keyboardType: TextInputType.name,
                ).marginSymmetric(vertical: 8.h),
                buildCurrencyContainer(controllerAddVehicle, context),

                CustomTextField(
                  readOnly: controllerAddVehicle.showLoading.value,

                  controller: controllerAddVehicle.vehiclePerDayRent,
                  hint: "Per Day Rent ${controllerAddVehicle.currency.value}",
                  keyboardType: TextInputType.number,
                ).marginSymmetric(vertical: 8.h),
                CustomTextField(
                  readOnly: controllerAddVehicle.showLoading.value,

                  controller: controllerAddVehicle.vehiclePerHourRent,
                  hint: "Per Hours Rent ${controllerAddVehicle.currency.value}",
                  keyboardType: TextInputType.number,
                ).marginSymmetric(vertical: 8.h),
                // buildVehicleNumberPlate(controllerAddVehicle),

                Obx(() {
                  return CustomTextField(
                    controller: TextEditingController(
                        text: controllerAddVehicle.address.value),
                    text: controllerAddVehicle.address.value,
                    padding: EdgeInsets.only(left: 18.w, top: 1.h),
                    hint: 'Add Vehicle Location',
                    // Use the address from the snapshot
                    hintColor:
                    Color(0xff94979F).withOpacity(.7),
                    suffix: InkWell(
                      onTap: () async {
                        var result = await Get.to(
                            ScreenHostAddVehicleLocation());
                        if (result == true) {
                          controller.update();
                        }
                      },
                      child: SvgPicture.asset(
                          "assets/images/location.svg")
                          .marginOnly(top: 4.h),
                    ),
                  );
                }).marginSymmetric(
                    vertical: 8.h),
                CustomTextField(
                  readOnly: controllerAddVehicle.showLoading.value,
                  controller: controllerAddVehicle.vehicleDescription,
                  hint: "About Vehicle",

                ).marginSymmetric(vertical: 8.h),

                buildRegistrationProof(controllerAddVehicle),
                Obx(() {
                  return CustomButton(
                      title: 'Add',
                      isLoading: controllerAddVehicle.showLoading.value,
                      onPressed: () async {
                        var response =
                        await controllerAddVehicle.hostAddVehicle();
                        if (response == "success") {
                          Get.offAll(ScreenHostHomePage());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Your Vehicle added Successfully")));
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response)));
                        }
                      });
                }).marginSymmetric(vertical: 20.h)
              ],
            );
          }).marginSymmetric(horizontal: 22.w),
        ),
      ),
    );
  }

  Obx buildRegistrationProof(ControllerHostAddVechicle controllerAddVehicle) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          controllerAddVehicle.vehicleRegistrationProofPath.value =
          await FilePick().pickImage(ImageSource.gallery);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 60.w, vertical: 15.h),
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Color(0xFFA6A6A6), width: 2.r),
          ),
          child: (controllerAddVehicle
              .vehicleRegistrationProofPath.value.isNotEmpty)
              ? Image.file(File(controllerAddVehicle
              .vehicleRegistrationProofPath.value))
              : Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomSvg(
                    name: "car-insurance",
                  ),
                  Text(
                    "Add vehicle\nregistration\nImage",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Obx buildVehicleNumberPlate(ControllerHostAddVechicle controllerAddVehicle) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          controllerAddVehicle.vehicleNumberPlatePath.value =
          await FilePick().pickImage(ImageSource.gallery);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 60.w, vertical: 15.h),
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Color(0xFFA6A6A6),
            border: Border.all(color: Color(0xFFA6A6A6), width: 2.r),
          ),
          child: (controllerAddVehicle
              .vehicleNumberPlatePath.isNotEmpty)
              ? Image.file(File(
              controllerAddVehicle.vehicleNumberPlatePath.value))
              : Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CustomSvg(
                        name: "vechilcle-number",
                      ),
                      Text(
                        "Take vehicle\nimage",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomSvg(
                    name: "info",
                  ).marginOnly(right: 3.w),
                  Text(
                    "Car plate number must visible in image",
                    style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: "Nunito"),
                  )
                ],
              ).marginSymmetric(vertical: 5.h)
            ],
          ),
        ),
      );
    });
  }

  // Stream<Category> fetchCategories() {
  //   return categoryRef.snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) => doc.).toList();
  //   });
  // }



  Widget buildCategoryContainer(ControllerHostAddVechicle controllerAddVehicle,
      BuildContext context) {
    var categoryName = "";
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return StreamBuilder<QuerySnapshot>(
          stream: categoryRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text(
                  "No Category Added"); // Loading indicator while fetching data
            }

            var categories = snapshot.data!.docs.map((e) =>
                Category.fromMap(e.data() as Map<String, dynamic>)).toList();
            var categoryNameList = categories.map((e) => e.name).toList();

            return CustomTextField(
              padding: EdgeInsets.only(left: 18.w, top: 22.h),
              readOnly: true,
              hint: controllerAddVehicle.selectCategoryName.value.isEmpty
                  ? "Select Category/Type"
                  : controllerAddVehicle.selectCategoryName.value,
              hintColor: controllerAddVehicle.selectCategoryName.value.isEmpty
                  ? Color(0xff94979F)
                  : Colors.black,
              suffix: PopupMenuButton<Category>(
                icon: Icon(Icons.expand_more),
                color: Theme
                    .of(context)
                    .primaryColor,
                itemBuilder: (BuildContext context) {
                  return categories.map((choice) {
                    return PopupMenuItem<Category>(
                      value: choice,
                      child: Text(
                        choice.name,
                        style: TextStyle(
                            color: Colors.white, fontFamily: "Urbanist"),
                      ),
                    );
                  }).toList();
                },
                onSelected: (Category choice) {
                  // Update selected category when an option is chosen
                  setState(() {
                    controllerAddVehicle.selectCategory.value = choice.id.toString();
                    controllerAddVehicle.selectCategoryName.value = choice.name.toString();
                  });
                },
              ).marginOnly(top: 4.h),
            );
          },
        );
      },
    );
  }


  Obx buildTransmissionContainer(ControllerHostAddVechicle controllerAddVehicle,
      BuildContext context) {
    return Obx(() {
      return CustomTextField(
        padding: EdgeInsets.only(left: 18.w, top: 18.h),
        readOnly: true,
        hint: controllerAddVehicle.selectTransmission.value.isEmpty
            ? "Select Transmission"
            : controllerAddVehicle.selectTransmission.value,
        hintColor:
        controllerAddVehicle.selectTransmission.value.isEmpty
            ? Color(0xff94979F)
            : Colors.black,
        suffix: PopupMenuButton(
          icon: Icon(Icons.expand_more),
          color: Theme
              .of(context)
              .primaryColor,
          itemBuilder: (BuildContext context) {
            return [
              'Automatic',
              'Switch',
            ].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyle(color: Colors.white, fontFamily: "Urbanist"),
                ),
              );
            }).toList();
          },
          onSelected: (String choice) {
            // Update selected gender when an option is chosen
            controllerAddVehicle.selectTransmission.value = choice;
          },
        ).marginOnly(top: 4.h),
      );
    });
  }

  Widget addVehicle(VoidCallback onTap, String text, RxString imagePath) {
    return Obx(() {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          // margin: EdgeInsets.only(r.h),
          height: 89.h,
          width: 92.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: Color(0xFFC4C4C4).withOpacity(.3),
          ),
          child: (imagePath.value.isNotEmpty)
              ? Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r
              ),
              image: DecorationImage(
                image: FileImage(File(imagePath.value)),
                fit: BoxFit.fill,
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: CustomSvg(
                name: "edit-car",
              ).marginOnly(top: 10.h, right: 10.w),
            ),
          )
              : Column(
            children: [
              Spacer(),
              CustomSvg(
                name: "camer-",
              ),
              Spacer(),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 6.sp,
                  fontFamily: "Nunito",
                  color: Colors.black.withOpacity(.5),
                ),
              ).marginSymmetric(horizontal: 5.w, vertical: 8.h),
            ],
          ),
        ),
      );
    });
  }

  Obx buildFuelContainer(ControllerHostAddVechicle controllerAddVehicle, BuildContext context) {
    return Obx(() {
      return CustomTextField(
        padding: EdgeInsets.only(left: 18.w, top: 18.h),
        readOnly: true,
        hint: controllerAddVehicle.selectFuelType.value.isEmpty
            ? "Select Fuel Type"
            : controllerAddVehicle.selectFuelType.value,
        hintColor: controllerAddVehicle.selectFuelType.value.isEmpty
            ? Color(0xff94979F)
            : Colors.black,
        suffix: PopupMenuButton(
          icon: Icon(Icons.expand_more),
          color: Theme
              .of(context)
              .primaryColor,
          itemBuilder: (BuildContext context) {
            return [
              'Gasoline',
              'Patrol',
            ].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyle(color: Colors.white, fontFamily: "Urbanist"),
                ),
              );
            }).toList();
          },
          onSelected: (String choice) {
            // Update selected gender when an option is chosen
            controllerAddVehicle.selectFuelType.value = choice;
          },
        ).marginOnly(top: 4.h),
      );
    });
  }
  Obx buildCurrencyContainer(ControllerHostAddVechicle controllerAddVehicle, BuildContext context) {
    return Obx(() {
      return CustomTextField(
        padding: EdgeInsets.only(left: 18.w, top: 18.h),
        readOnly: true,
        hint: controllerAddVehicle.currency.value.isEmpty
            ? "Select Currency"
            : controllerAddVehicle.currency.value,
        hintColor: controllerAddVehicle.currency.value.isEmpty
            ? Color(0xff94979F)
            : Colors.black,
        suffix: PopupMenuButton(
          icon: Icon(Icons.expand_more),
          color: Theme
              .of(context)
              .primaryColor,
          itemBuilder: (BuildContext context) {
            return [
              '\$',
              'PKR',
            ].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyle(color: Colors.white, fontFamily: "Urbanist"),
                ),
              );
            }).toList();
          },
          onSelected: (String choice) {
            // Update selected gender when an option is chosen
            controllerAddVehicle.currency.value = choice;
          },
        ).marginOnly(top: 4.h),
      );
    });
  }

  Obx buildVehicleContainer(ControllerHostAddVechicle controllerAddVehicle) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          controllerAddVehicle.vehiclePath.value =
          await FilePick().pickImage(ImageSource.gallery);
        },
        child: SizedBox(
          height: 135.h,
          child: Stack(
            children: [
              DottedBorder(
                borderType: BorderType.RRect,
                color: Colors.black,
                dashPattern: [6, 6, 6, 6],
                strokeWidth: .5.sp,
                radius: Radius.circular(12),
                // padding: EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    height: 123.w,
                    width: Get.width,
                    child: controllerAddVehicle
                        .vehiclePath.value.isEmpty
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomImage(
                          name: "add-vehicle",
                        ),
                        Text(
                          "Click for add",
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appPrimaryColor),
                        )
                      ],
                    )
                        : Image.file(File(
                        controllerAddVehicle.vehiclePath.value)),
                  ),
                ),
              ).marginSymmetric(horizontal: 18.w),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                    height: 38.h,
                    width: 38.w,
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.appPrimaryColor,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 14,
                        ))),
              )
            ],
          ),
        ),
      );
    });
  }
}
