import 'dart:developer';

import 'package:careno/User/views/screens/screen_filter.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/controllers/controller_filter.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/add_host_vehicle.dart';
import '../../../models/categories.dart';

class ScreenSearchFilter extends StatefulWidget {
  @override
  State<ScreenSearchFilter> createState() => _ScreenSearchFilterState();
}

class _ScreenSearchFilterState extends State<ScreenSearchFilter> {
  ControllerFilter controller = Get.put(ControllerFilter());

  @override
  Widget build(BuildContext context) {
    controller.selectCategoryName.value = Get
        .find<HomeController>()
        .allCategory
        .first
        .name;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),

        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Filter by",
                  style: TextStyle(
                    color: AppColors.appPrimaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: "UrbanistBold",
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Car Category/Type",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "UrbanistBold",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(children: [
                    Obx(() {
                      return Text(
                        controller.selectCategoryName.value,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Urbanist",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500),
                      );
                    }),
                    PopupMenuButton<Category>(
                      icon: Icon(Icons.expand_more),
                      color: Theme
                          .of(context)
                          .primaryColor,
                      itemBuilder: (BuildContext context) {
                        return Get
                            .find<HomeController>()
                            .allCategory
                            .value
                            .map((choice) {
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
                          controller.selectCategory.value = choice.id.toString();
                          controller.selectCategoryName.value = choice.name.toString();
                      },
                    ),
                  ])
                ],
              ),
              Divider(
                height: 0,
                thickness: .5,
                color: Color(0xffD8D8D8),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Model Year",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "UrbanistBold",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(children: [
                    Text(
                      controller.carModel.value,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Urbanist",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    PopupMenuButton(
                      icon: Icon(Icons.expand_more),
                      color: Theme.of(context).primaryColor,
                      itemBuilder: (BuildContext context) {
                        Set<String> uniqueYear = Set();
                        Get.find<HomeController>().addhostvehicle.value.forEach((choice) {
                          uniqueYear.add(choice.vehicleYear.toString());
                        });
                        return uniqueYear.map((yearType) {
                          return PopupMenuItem<AddHostVehicle>(
                            value: Get.find<HomeController>()
                                .addhostvehicle
                                .value
                                .firstWhere((choice) => choice.vehicleYear.toString() == yearType),
                            child: Text(
                              yearType,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Urbanist",
                              ),
                            ),
                          );
                        }).toList();
                      },
                      onSelected: (AddHostVehicle choice) {
                        // Update selected fuel type when an option is chosen
                        controller.carModel.value = choice.vehicleYear!.toString();
                        setState(() {
                          // Update state if necessary
                        });
                      },
                    ),
                  ])
                ],
              ),
              Divider(
                height: 0,
                thickness: .5,
                color: Color(0xffD8D8D8),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transmission",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "UrbanistBold",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(children: [
                    Text(
                      controller.carTransmission.value,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Urbanist",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    PopupMenuButton(
                      icon: Icon(Icons.expand_more),
                      color: Theme.of(context).primaryColor,
                      itemBuilder: (BuildContext context) {
                        Set<String> uniqueTransmission = Set();
                        Get.find<HomeController>().addhostvehicle.value.forEach((choice) {
                          uniqueTransmission.add(choice.vehicleTransmission.toString());
                        });
                        return uniqueTransmission.map((fuelType) {
                          return PopupMenuItem<AddHostVehicle>(
                            value: Get.find<HomeController>()
                                .addhostvehicle
                                .value
                                .firstWhere((choice) => choice.vehicleTransmission.toString() == fuelType),
                            child: Text(
                              fuelType,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Urbanist",
                              ),
                            ),
                          );
                        }).toList();
                      },
                      onSelected: (AddHostVehicle choice) {
                        // Update selected fuel type when an option is chosen
                        controller.carTransmission.value = choice.vehicleTransmission!.toString();
                        setState(() {
                          // Update state if necessary
                        });
                      },
                    ),
                  ])
                ],
              ),
              Divider(
                height: 0,
                thickness: .5,
                color: Color(0xffD8D8D8),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Fuel Type",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "UrbanistBold",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(children: [
                    Text(
                      controller.carFuelType.value,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Urbanist",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    PopupMenuButton(
                      icon: Icon(Icons.expand_more),
                      color: Theme.of(context).primaryColor,
                      itemBuilder: (BuildContext context) {
                        Set<String> uniqueFuelTypes = Set();
                        Get.find<HomeController>().addhostvehicle.value.forEach((choice) {
                          uniqueFuelTypes.add(choice.vehicleFuelType.toString());
                        });
                        return uniqueFuelTypes.map((fuelType) {
                          return PopupMenuItem<AddHostVehicle>(
                            value: Get.find<HomeController>()
                                .addhostvehicle
                                .value
                                .firstWhere((choice) => choice.vehicleFuelType.toString() == fuelType),
                            child: Text(
                              fuelType,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Urbanist",
                              ),
                            ),
                          );
                        }).toList();
                      },
                      onSelected: (AddHostVehicle choice) {
                        // Update selected fuel type when an option is chosen
                        controller.carFuelType.value = choice.vehicleFuelType!.toString();
                        setState(() {
                          // Update state if necessary
                        });
                      },
                    ),

                  ])
                ],
              ),
              Divider(
                height: 0,
                thickness: .5,
                color: Color(0xffD8D8D8),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Seats Capacity",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "UrbanistBold",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(children: [
                    Text(
                      controller.carSeatsCapacity.value,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Urbanist",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    PopupMenuButton(
                      icon: Icon(Icons.expand_more),
                      color: Theme.of(context).primaryColor,
                      itemBuilder: (BuildContext context) {
                        Set<String> uniqueSeats = Set();
                        Get.find<HomeController>().addhostvehicle.value.forEach((choice) {
                          uniqueSeats.add(choice.vehicleSeats.toString());
                        });
                        return uniqueSeats.map((fuelType) {
                          return PopupMenuItem<AddHostVehicle>(
                            value: Get.find<HomeController>()
                                .addhostvehicle
                                .value
                                .firstWhere((choice) => choice.vehicleSeats.toString() == fuelType),
                            child: Text(
                              fuelType,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Urbanist",
                              ),
                            ),
                          );
                        }).toList();
                      },
                      onSelected: (AddHostVehicle choice) {
                        // Update selected fuel type when an option is chosen
                        controller.carSeatsCapacity.value = choice.vehicleSeats!.toString();
                        setState(() {
                          // Update state if necessary
                        });
                      },
                    ),
                  ])
                ],
              ),
              Divider(
                height: 0,
                thickness: .5,
                color: Color(0xffD8D8D8),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Car Location",
              //       style: TextStyle(
              //           color: Colors.black,
              //           fontFamily: "UrbanistBold",
              //           fontSize: 15.sp,
              //           fontWeight: FontWeight.w600),
              //     ),
              //     Row(children: [
              //       Text(
              //         controller.carLocation.value,
              //         style: TextStyle(
              //             color: Colors.black,
              //             fontFamily: "Urbanist",
              //             fontSize: 15.sp,
              //             fontWeight: FontWeight.w500),
              //       ),
              //       // PopupMenuButton(
              //       //   icon: Icon(Icons.expand_more),
              //       //   color: Theme
              //       //       .of(context)
              //       //       .primaryColor,
              //       //   itemBuilder: (BuildContext context) {
              //       //     return CarLocation.map((String choice) {
              //       //       return PopupMenuItem<String>(
              //       //         value: choice,
              //       //         child: Text(
              //       //           choice,
              //       //           style: TextStyle(
              //       //               color: Colors.white,
              //       //               fontFamily: "Urbanist"),
              //       //         ),
              //       //       );
              //       //     }).toList();
              //       //   },
              //       //   onSelected: (String choice) {
              //       //     // Update selected gender when an option is chosen
              //       //     controller.CarLocation.value = choice;
              //       //     setState(() {
              //       //
              //       //     });
              //       //   },
              //       // ),
              //     ])
              //   ],
              // ),
              Divider(
                height: 0,
                thickness: .5,
                color: Color(0xffD8D8D8),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rating",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "UrbanistBold",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  RatingBar(
                    filledIcon: Icons.star,
                    emptyIcon: Icons.star_border,
                    onRatingChanged: (value) => controller.rating.value = value,
                    initialRating: 5,
                    maxRating: 5,
                    filledColor: primaryColor,
                    size: 24,
                  )
                ],
              ).marginSymmetric(vertical: 8.h),
              Divider(
                height: 0,
                thickness: .5,
                color: Color(0xffD8D8D8),
              ),
              Text(
                "Price Range",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "UrbanistBold",
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: Get.width,
                child: Obx(() {
                  final startLabel = "${currencyUnit}${controller.selectedRange
                      .value.start.toStringAsFixed(0)}";
                  final endLabel = "${currencyUnit}${controller.selectedRange
                      .value.end.toStringAsFixed(0)}";

                  return SliderTheme(
                    data: SliderThemeData(
                      thumbShape: SliderComponentShape.noOverlay,
                      overlayColor: AppColors.appPrimaryColor,
                      valueIndicatorColor: Color(0xFF2F97D1),
                      // Change the overlay color
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white, // Change the label text color here
                      ),
                    ),
                    child: RangeSlider(
                      min: 0,
                      max: 100,
                      divisions: 99,
                      labels: RangeLabels(startLabel, endLabel),
                      values: controller.selectedRange.value,
                      onChanged: (value) {
                        controller.selectedRange.value = value;
                        log(controller.selectedRange.value.start.toString());
                        log(controller.selectedRange.value.end.toString());
                      },
                    ),
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${currencyUnit}0", style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600
                  ),),
                  Text("${currencyUnit}100", style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600
                  ),),
                ],
              ).marginSymmetric(horizontal: 25.w
              ),
              Image.asset("assets/images/Line 39.png").marginSymmetric(
                  horizontal: 40.w, vertical: 20.h),
              Center(
                child: Text(
                  "Sort by",
                  style: TextStyle(
                    color: AppColors.appPrimaryColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600
                    , fontFamily: "UrbanistBold",
                  ),
                ),
              ),
              Divider(
                height: 20.h,
                thickness: .5,
                color: Color(0xffD8D8D8),
              ),
              RadioListTile(
                  title: Text("Price Low to High",
                    style: TextStyle(color: Colors.black,
                        fontFamily: "UrbanistBold",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),),
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: primaryColor,
                  value: "Low To High",
                  groupValue: controller.sortBy.value,
                  onChanged: (String? value) {
                    setState(() {
                      controller.sortBy.value = value!;
                    });
                  }),
              Divider(
                height: 0,
                thickness: .5,
                color: Color(0xffD8D8D8),
              ),
              RadioListTile(
                  title: Text("Price Heigh To Low",
                    style: TextStyle(color: Colors.black,
                        fontFamily: "UrbanistBold",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),),
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: primaryColor,
                  value: "High to Low",
                  groupValue: controller.sortBy.value,
                  onChanged: (String? value) {
                    setState(() {
                      controller.sortBy.value = value!;
                    });
                  }),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                        width: 164.w,
                        color: Color(0xffC7C7C7),
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp
                            , color: Colors.black
                        ),
                        title: "Clear",
                        onPressed: () {}),
                    CustomButton(
                        width: 164.w,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp
                            , color: Colors.white
                        ),
                        title: "Apply", onPressed: () {
                      List<AddHostVehicle> applyFiltersAndSort(List<AddHostVehicle> vehicles) {
                        return vehicles.where((vehicle) {
                          // Apply filtering based on controller values
                          final matchesCategory = vehicle.vehicleCategory ==   controller.selectCategory.value;
                          log(matchesCategory.toString());
                          final matchesModelYear = vehicle.vehicleYear == controller.carModel.value;
                          log(matchesModelYear.toString());
                          final matchesTransmission = vehicle.vehicleTransmission == controller.carTransmission.value;
                          log(matchesTransmission.toString());
                          final matchesFuelType = vehicle.vehicleFuelType == controller.carFuelType.value;
                          final matchesSeatsCapacity = vehicle.vehicleSeats == controller.carSeatsCapacity.value;
                          // final matchesLocation = vehicle.address.toLowerCase().contains(controller.carLocation.value.toLowerCase());
                          // final matchesBrand = vehicle.vehicleModel.toLowerCase().contains(controller.carBrand.value.toLowerCase());

                          // Add more filter conditions as needed...

                          return matchesCategory &&
                              matchesModelYear &&
                              matchesTransmission &&
                              matchesFuelType &&
                              matchesSeatsCapacity ;
                              // matchesLocation &&
                              // matchesBrand;
                        }).toList()
                          ..sort((a, b) {
                            // Sorting logic based on price (vehiclePerHourRent or vehiclePerDayRent)
                            double priceA = double.parse(a.vehiclePerHourRent); // Assuming this is a double value
                            double priceB = double.parse(b.vehiclePerHourRent); // Assuming this is a double value

                            if (controller.sortBy.value == 'Low To High') {
                              return priceA.compareTo(priceB);
                            } else {
                              return priceB.compareTo(priceA);
                            }
                          });
                      }
                      controller.filterVehicle.value = applyFiltersAndSort(Get.find<HomeController>().addhostvehicle);
                      Get.back();



                    }),
                  ]
              )

            ],
          ).marginSymmetric(horizontal: 15.w, vertical: 15.h),

        ),
      ),
    );
  }

  var Cartype = ["Sedan", "Trucks", "Luxury Car", "Electronic Car"];
  var CarBrand = ["Toyota", "Jeep", "Luxury Car", "Ford Ranger"];
  var CarModel = ["2000", "2019", "2022", "2025"];
  var CarTransmission = ["Automatic", "Compterized"];
  var CarFuelType = ["Gasoline", "Petrol", "Diesel"];
  var CarSeatsCapacity = ["01", "02", "03", "04"];
  var CarLocation = [
    "Central Park New York",
    "Pakistan layyah",
    "Krachi layyah"
  ];
}
