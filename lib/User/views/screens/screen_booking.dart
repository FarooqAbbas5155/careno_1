import 'dart:developer';
import 'dart:ffi';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:careno/User/views/screens/screen_booking_review.dart';
import 'package:careno/User/views/screens/slider_test.dart';
import 'package:careno/constant/MyFonts.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/controllers/booking_controller.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:careno/widgets/custom_textfiled.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../constant/helpers.dart';

class ScreenBooking extends StatelessWidget {
  AddHostVehicle addHostVehicle;

  final BookingController controller = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    controller.price.value =double.tryParse( addHostVehicle.vehiclePerDayRent)!;
    print("controller.price.value ${controller.price.value}");
    if (controller.bookingType.value == "Per day") {
      controller.priceController.text = addHostVehicle.vehiclePerDayRent.toString();
      controller.price.value = double.tryParse(addHostVehicle.vehiclePerDayRent)!;
    }
    if (controller.bookingType.value == "Per hour") {
      controller.priceController.text = addHostVehicle.vehiclePerHourRent.toString();
      controller.price.value = double.tryParse(addHostVehicle.vehiclePerHourRent)!;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Bookings",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              fontFamily: "UrbanistBold",
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Booked As",
                    style: MyFont.heading18,
                  ),
                  Obx(
                        () =>
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  activeColor: primaryColor,
                                  value: "Per day",
                                  groupValue: controller.bookingType.value,
                                  onChanged: (String? value) {
                                    print("Radio button changed to: $value");
                                    controller.bookingType.value = value!;
                                    controller.price.value =
                                    double.tryParse(addHostVehicle.vehiclePerDayRent)!;
                                    controller.endMinTime.value = 0.0;
                                  },
                                ),
                                Text(
                                  "Per Day",
                                  style: MyFont.heading16,
                                )
                              ],
                            ),
                            Text(
                              "${addHostVehicle.currency}${addHostVehicle.vehiclePerDayRent}",
                              style: MyFont.heading18
                                  .copyWith(color: AppColors.appPrimaryColor),
                            )
                          ],
                        ),
                  ),
                  Obx(
                        () =>
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  activeColor: primaryColor,
                                  value: "Per hour",
                                  groupValue: controller.bookingType.value,
                                  onChanged: (String? value) {
                                    print("Radio button changed to: $value");
                                    controller.price.value = double.tryParse(addHostVehicle.vehiclePerHourRent)!;
                                    controller.bookingType.value = value!;
                                  },
                                ),
                                Text(
                                  "Per Hour",
                                  style: MyFont.heading16,
                                )
                              ],
                            ),
                            Text(
                              "${addHostVehicle.currency}${addHostVehicle.vehiclePerHourRent}",
                              style: MyFont.heading18
                                  .copyWith(color: AppColors.appPrimaryColor),
                            )
                          ],
                        ),
                  ),
                  Obx(() {
                    return Text("Booking Price ${controller.bookingType.value}",
                        style: MyFont.heading18);
                  }).marginSymmetric(vertical: 5.h),
                  Obx(() {
                    return CustomTextField(
                      keyboardType: TextInputType.number,
                      onChange: (value) {
                        controller.price.value = double.tryParse(value!)!;
                        if (controller.bookingType=="Per day") {
                          int difference = controller.dates[1]!.difference(controller.dates[0]!).inDays;
                          print("difference  ${difference}");
                          controller.price.value = double.tryParse("${value}")! * difference;
                        }
                        else{
                          DateTime endDate = controller.bookingStartDate.value!.add(Duration(hours:controller.hoursDifference.value.toInt()));

                          // Check if the end time is crossing into the next day
                          if (controller.endTime.value < controller.startTime.value) {
                            // Add an extra day if end time transitions to the next day
                            endDate = endDate.add(Duration(days: 1));
                          }

                          // Update the booking end date in the controller
                          controller.bookingEndDate.value = endDate;

                          controller.price.value =double.tryParse(addHostVehicle.vehiclePerHourRent)! * controller.hoursDifference.value.roundToDouble();

                        }
                      },
                      controller: controller.priceController..text = controller.bookingType.value == "Per day" ? "${addHostVehicle.vehiclePerDayRent}" : "${addHostVehicle.vehiclePerHourRent}",
                      // text: ,
                    );
                  }).marginSymmetric(vertical: 5.h),
                  Text(
                    "Select Date or Day",
                    style: MyFont.heading18,
                  ).marginSymmetric(vertical: 5.h),
                  Obx(() =>
                  controller.bookingType.value == "Per day"
                      ? CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      centerAlignModePicker: true,
                      firstDate: DateTime.now(),
                      currentDate: DateTime.now(),
                      lastDate: DateTime(2050),
                      lastMonthIcon: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.appPrimaryColor)),
                          child: CustomSvg(
                            name: "back",
                          )),
                      nextMonthIcon: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.appPrimaryColor)),
                          child: CustomSvg(
                            name: "next",
                          )),
                      yearTextStyle: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15.sp),
                      dayTextStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1B1B)),
                      calendarType: CalendarDatePicker2Type.range,
                    ),
                    value: controller.dates,
                    onValueChanged: (dates) {
                      controller.dates = dates;
                      controller.bookingStartDate.value = controller.dates[0];
                      // controller.bookingPrice.value = double.tryParse(controller.priceController.text)!;
                      controller.bookingEndDate.value = controller.dates[1];
                      int difference = dates[1]!.difference(dates[0]!).inDays;
                      print("difference  ${difference}");
                      controller.price.value = double.tryParse("${addHostVehicle.vehiclePerDayRent}")! * difference;
                      print("Price ${controller.price.value}");
                    },
                  )
                      : CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      centerAlignModePicker: true,
                      firstDate: DateTime.now(),
                      currentDate: DateTime.now(),
                      lastDate: DateTime(2050),
                      lastMonthIcon: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.appPrimaryColor)),
                          child: CustomSvg(
                            name: "back",
                          )),
                      nextMonthIcon: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.appPrimaryColor)),
                          child: CustomSvg(
                            name: "next",
                          )),
                      yearTextStyle: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15.sp),
                      dayTextStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1B1B)),
                      calendarType: CalendarDatePicker2Type.single,
                    ),
                    value: controller.selectDates,
                    onValueChanged: (dates) {
                      controller.selectDates = dates;
                      controller.bookingStartDateHour.value = dates[0];
                      controller.bookingStartDate.value=dates[0];
                     print( dateFormat( controller.bookingStartDateHour.value!));
                    }

                  )),
                  Text(
                    "Select Time",
                    style: MyFont.heading18,
                  ),
                ],
              ).marginSymmetric(horizontal: 19.w, vertical: 10.h),
              Container(
                margin: EdgeInsets.only(top: 10.h),
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 19.w),
                decoration:
                BoxDecoration(color: Color(0xFFD9D9D9).withOpacity(.15)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Pick-Up",
                          style: MyFont.heading12,
                        ),
                        Expanded(
                          child: Obx(() {
                            return
                              Slider(
                            min:     controller.MinTime.value,
                              // min:controller.bookingType.value == "Per hour"? controller.MinTime.value:controller.StartMinTimeDay.value,
                              max: 24,
                              divisions: 23,
                              value: controller.startTime.value,
                              // value:controller.bookingType.value == "Per hour"? controller.startTime.value:controller.EndTimeDay1.value,
                              // Clamp value within range
                              onChanged: (value) {

                                if (controller.bookingType.value=="Per day") {
                                  controller.startTime.value = value;
                                  print(controller.startTime.value.roundToDouble());
                                  }
                               else{
                                  controller.startTime.value = value;
                                  startTime = int.parse(controller.startTime.value.toStringAsFixed(0));
                                  controller.calculateHoursDifference();
                                  DateTime endDate = controller.bookingStartDate.value!.add(Duration(hours:controller.hoursDifference.value.toInt()));

                                  // Check if the end time is crossing into the next day
                                  if (controller.endTime.value < controller.startTime.value) {
                                    // Add an extra day if end time transitions to the next day
                                    endDate = endDate.add(Duration(days: 1));
                                  }

                                  // Update the booking end date in the controller
                                  controller.bookingEndDate.value = endDate;                                    controller.price.value =double.tryParse(addHostVehicle.vehiclePerHourRent)! * controller.hoursDifference.value.roundToDouble();

                                }

                              },
                            );
                          }),
                        ),
                        Obx(() {
                          return Row(
                            children: [
                              Text(
                                "${controller.startTime.value.toStringAsFixed(
                                    0)}:00 ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                    color: Color(0xFF1A1B1B)),
                              ),
                              Text(
                                controller.startTime.value>12?"PM":"AM",  style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: Color(0xFF1A1B1B)),),
                              // controller.bookingType.value == "Per hour"?
                              // Text(
                              //   "${controller.startTime.value.toStringAsFixed(
                              //       0)}:00 ",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w600,
                              //       fontSize: 12.sp,
                              //       color: Color(0xFF1A1B1B)),
                              // )
                              //     :Text(
                              //   "${controller.EndTimeDay1.value.toStringAsFixed(
                              //       0)}:00 ",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w600,
                              //       fontSize: 12.sp,
                              //       color: Color(0xFF1A1B1B)),
                              // ),
                              // controller.bookingType.value == "Per hour"?
                              // Text(
                              //   controller.startTime.value>12?"PM":"AM",  style: TextStyle(
                              //     fontWeight: FontWeight.w600,
                              //     fontSize: 12.sp,
                              //     color: Color(0xFF1A1B1B)),)
                              //     :Text(
                              //   controller.EndTimeDay1.value>12?"PM":"AM",  style: TextStyle(
                              //     fontWeight: FontWeight.w600,
                              //     fontSize: 12.sp,
                              //     color: Color(0xFF1A1B1B)),),
                         ]
                          );
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Drop-off",
                          style: MyFont.heading12,
                        ),
                        Expanded(
                          child: Obx(() {
                            return
                              Slider(
                                min: controller.endMinTime.value,
                              // min: controller.bookingType.value == "Per hour"?controller.endMinTime.value:controller.EndMinTimeDay.value,
                              max: 24,
                              divisions: 24,
                              value: controller.endTime.value,
                              // value:controller.bookingType.value == "Per hour"? controller.endTime.value:controller.EndTimeDay2.value,
                              onChanged: (value) {
                             // Reverse the value
                                if (controller.bookingType.value == "Per day") {
                                  controller.endTime.value = value;
                                  print(controller.endTime.value.roundToDouble());
                                  // Handle per day booking
                                }
                                else {
                                  controller.endTime.value = value;
                                  controller.calculateHoursDifference();
                                  print("controller.hoursDifference.value ${controller.hoursDifference.value}");
                                  DateTime endDate = controller.bookingStartDate.value!.add(Duration(hours:controller.hoursDifference.value.toInt()));

                                  // Check if the end time is crossing into the next day
                                  if (controller.endTime.value < controller.startTime.value) {
                                    // Add an extra day if end time transitions to the next day
                                    endDate = endDate.add(Duration(days: 1));
                                  }

                                  // Update the booking end date in the controller
                                  controller.bookingEndDate.value = endDate;

                                  controller.price.value =double.tryParse(addHostVehicle.vehiclePerHourRent)! * controller.hoursDifference.value.roundToDouble();


                                }
                              },
                            );
                          }),

                        ),
                        Obx(() {
                          return
                            Row(
                              children: [
                                Text(
                                  "${controller.endTime.value.toStringAsFixed(0)}:00 ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                      color: Color(0xFF1A1B1B)),
                                ),
                                Text(controller.endTime.value>12?"PM":"AM",  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                    color: Color(0xFF1A1B1B)),),
                              //   controller.bookingType.value == "Per hour"?
                              //   Text(
                              //   "${controller.endTime.value.toStringAsFixed(0)}:00 ",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w600,
                              //       fontSize: 12.sp,
                              //       color: Color(0xFF1A1B1B)),
                              //                             )
                              //       :Text(
                              //     "${controller.EndTimeDay2.value.toStringAsFixed(0)}:00 ",
                              //     style: TextStyle(
                              //         fontWeight: FontWeight.w600,
                              //         fontSize: 12.sp,
                              //         color: Color(0xFF1A1B1B)),
                              //   ),
                              //   controller.bookingType.value == "Per hour"?
                              //   Text(controller.endTime.value>12?"PM":"AM",  style: TextStyle(
                              // fontWeight: FontWeight.w600,
                              // fontSize: 12.sp,
                              // color: Color(0xFF1A1B1B)),)
                              //       : Text(controller.EndTimeDay2.value>12?"PM":"AM",  style: TextStyle(
                              //       fontWeight: FontWeight.w600,
                              //       fontSize: 12.sp,
                              //       color: Color(0xFF1A1B1B)),)

                              ],
                            );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              DottedLine(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                lineLength: double.infinity,
                lineThickness: 1.0,
                dashLength: 4.0,
                dashColor: Color(0xFFCFCFCF),
                dashRadius: 0.0,
                dashGapLength: 4.0,
                dashGapColor: Colors.transparent,
                dashGapRadius: 0.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Subtotal Price",
                    style:
                    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                  Obx(() {
                    return Text(
                      "${addHostVehicle.currency}${controller.bookingType == "Per day"
                          ? controller.price.value
                          : controller.price.value.roundToDouble()}",
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.appPrimaryColor),
                    );
                  })
                ],
              ).marginSymmetric(horizontal: 20.w, vertical: 15.h),
              CustomButton(
                  title: "Next",
                  onPressed: () {
                    // Get.to(TimePickerSliderDemo());
                    Get.to(ScreenBookingReview(addHostVehicle: addHostVehicle,));
                  }).marginSymmetric(vertical: 10.h)
            ],
          ),
        ),
      ),
    );
  }
  int startTime = 0;
  int EndTime = 0;
  ScreenBooking({
  required this.addHostVehicle
  });
}