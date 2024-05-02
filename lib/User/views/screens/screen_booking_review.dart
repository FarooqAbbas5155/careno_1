import 'package:careno/User/views/screens/screen_user_home.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/constant/my_helper_by_callofcoding.dart';
import 'package:careno/controllers/booking_controller.dart';
import 'package:careno/controllers/home_controller.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:careno/models/booking.dart';
import 'package:careno/models/user.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/fcm.dart';
import '../../../constant/firebase_utils.dart';
import '../../../constant/helpers.dart';
import '../../../models/notification_model.dart';

class ScreenBookingReview extends StatelessWidget {
  AddHostVehicle addHostVehicle;
  BookingController controller = Get.put(BookingController());
  var user;
  RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) {
    // var percentageValue =
    //     controller.price.value / 100 * controller.percentage.value;
    // controller.TotalVehicleRent.value = percentageValue + controller.price.value;
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
            "Bookings Review",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              fontFamily: "UrbanistBold",
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<User>(
            future: getUser(addHostVehicle.hostId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: AppColors.appPrimaryColor,
                    strokeWidth: 1,
                  ),
                );
              }
              user = snapshot.data;
              return Container(
                height: 640.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 18.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1, // Spread radius
                      blurRadius: 3, // Blur radius
                      offset: Offset(0, 3), // Offset of the shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Payment Method",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: "UrbanistBold",
                        ),
                      ),
                    ),

                    Obx(() {
                      return RadioListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                "assets/images/card.png",
                                width: 35.w,
                                height: 30.h,
                              ).marginOnly(right: 4.w),
                              Text(
                                "Credit or Debit Card",
                                style: TextStyle(
                                    color: Color(0xff484848),
                                    fontFamily: "UrbanistBold",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp),
                              ),
                            ],
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                          activeColor: primaryColor,
                          value: "CreditCard",
                          groupValue: controller.paymentType.value,
                          onChanged: (String? value) {
                            controller.paymentType.value = value!;
                          });
                    }),
                    Obx(() {
                      return RadioListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                "assets/images/me_paisa.png",
                                width: 35.w,
                                height: 30.h,
                              ).marginOnly(right: 4.w),
                              Text(
                                "M-Pesa Mobile ",
                                style: TextStyle(
                                    color: Color(0xff484848),
                                    fontFamily: "UrbanistBold",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp),
                              ),
                            ],
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                          activeColor: primaryColor,
                          value: "Mepaisa",
                          groupValue: controller.paymentType.value,
                          onChanged: (String? value) {
                            controller.paymentType.value = value!;
                          });
                    }),
                    Divider(
                      indent: 1,
                      endIndent: 1,
                      color: Color(0xffEDEEEE),

                      // color: AppColors.dividerColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Booking Summary",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: "UrbanistBold",
                        ),
                      ),
                    ),
                    // controller.bookingType.value == "Per Day" ?
                    Column(
                      children: [
                        BookingSummary("Start Date",
                            dateFormat(controller.bookingStartDate.value!)),
                        BookingSummary("End Date",
                            dateFormat(controller.bookingEndDate.value!)),
                      ],
                    ),
                    // : BookingSummary("Start Date",
                    // dateFormat(controller.bookingStartDateHour.value!)),

                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pick-up Time",
                            style: TextStyle(
                              color: Color(0xff484848).withOpacity(.7),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              // controller.bookingType.value == "Per hour" ?
                              Text(
                                "${controller.startTime.value.toStringAsFixed(0)}:00 ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "UrbanistBold"),
                              ),
                              //     :
                              // Text(
                              //   "${controller.EndTimeDay1.value.toStringAsFixed(
                              //       0)}:00 ",
                              //   style: TextStyle(color: Colors.black,
                              //       fontSize: 16.sp,
                              //       fontWeight: FontWeight.w600,
                              //       fontFamily: "UrbanistBold"),
                              // ),
                              // controller.bookingType.value == "Per hour" ?
                              Text(
                                controller.startTime.value > 12 ? "PM" : "AM",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "UrbanistBold"),
                              )
                              //   : Text(
                              // controller.EndTimeDay1.value > 12 ? "PM" : "AM",
                              // style: TextStyle(color: Colors.black,
                              //     fontSize: 16.sp,
                              //     fontWeight: FontWeight.w600,
                              //     fontFamily: "UrbanistBold"),),
                            ],
                          ),
                        ],
                      );
                    }).marginSymmetric(horizontal: 12.w, vertical: 4.h),
                    // controller.bookingType.value == "Per hour"? BookingSummary("Pick-up Time", "10:00 AM"),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Drop-off Time",
                            style: TextStyle(
                              color: Color(0xff484848).withOpacity(.7),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              // controller.bookingType.value == "Per hour" ?
                              Text(
                                "${controller.endTime.value.toStringAsFixed(0)}:00 ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "UrbanistBold"),
                              ),
                              //     : Text(
                              //   "${controller.EndTimeDay2.value.toStringAsFixed(
                              //       0)}:00 ",
                              //   style: TextStyle(color: Colors.black,
                              //       fontSize: 16.sp,
                              //       fontWeight: FontWeight.w600,
                              //       fontFamily: "UrbanistBold"),
                              // ),
                              // controller.bookingType.value == "Per hour" ?
                              Text(
                                controller.endTime.value > 12 ? "PM" : "AM",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "UrbanistBold"),
                              ),
                              //   : Text(
                              // controller.EndTimeDay2.value > 12 ? "PM" : "AM",
                              // style: TextStyle(color: Colors.black,
                              //     fontSize: 16.sp,
                              //     fontWeight: FontWeight.w600,
                              //     fontFamily: "UrbanistBold"),),
                            ],
                          ),
                        ],
                      );
                    }).marginSymmetric(horizontal: 12.w, vertical: 4.h),

                    Divider(
                      indent: 1,
                      endIndent: 1,
                      color: Color(0xffEDEEEE),

                      // color: AppColors.dividerColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Price Summary",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: "UrbanistBold",
                        ),
                      ),
                    ),
                    BookingSummary("Subtotal",
                        "${currencyUnit}${controller.price.value.toStringAsFixed(0)}"),
                    BookingSummary(
                        "Service Fee", "${currencyUnit}${((controller.price.value * adminPercentage!) / 100).toStringAsFixed(1)}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            color: Color(0xff484848),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${currencyUnit}${calculateAmountForUser(controller.price.value).toStringAsFixed(1)}",
                          style: TextStyle(
                              color: AppColors.appPrimaryColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "UrbanistBold"),
                        ),
                      ],
                    ).marginSymmetric(horizontal: 12.w, vertical: 4.h),
                    Center(child: Obx(() {
                      return CustomButton(
                          isLoading: loading.value,
                          title: "Add Payment Method",
                          onPressed: () async {
                            await setBooking(context, user);

                            // Get.to(ScreenAddCard());
                          });
                    })).marginSymmetric(horizontal: 24.w, vertical: 30.h),
                    Center(
                        child: Text(
                      "Your payment information is secure",
                      style: TextStyle(
                        color: Color(0xff484848),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Future<void> setBooking(BuildContext context, User host) async {
    loading.value = true;
    var user = Get.find<HomeController>().user.value;

    int id = DateTime.now().millisecondsSinceEpoch;
    DateTime startTimeDate = DateTime(
        controller.bookingStartDate.value!.year,
        controller.bookingStartDate.value!.month,
        controller.bookingStartDate.value!.day);
    Booking booking = Booking(
        bookingId: id.toString(),
        vehicleId: addHostVehicle.vehicleId,
        userId: user!.uid,
        hostId: addHostVehicle.hostId,
        bookingStatus: "Request Pending",
        paymentStatus: controller.paymentType.value,
        bookingType: controller.bookingType.value,
        bookingStartDate: startTimeDate.millisecondsSinceEpoch,
        bookingEndDate: controller.bookingType == "Per Day"
            ? (controller.bookingEndDate.value!.millisecondsSinceEpoch)
            : controller.bookingEndDate.value!
                .millisecondsSinceEpoch,
        completed: false,
        startTime: controller.startTime.value.toInt(),
        EndTime: controller.endTime.value.toInt(),
        price: controller.price.value,
        cancelBY: '',
        cancelDetail: '',
        isRated: false);
    await bookingsRef
        .doc(id.toString())
        .set(booking.toMap())
        .then((value) async {
      await FCM.sendMessageSingle(
        "New Booking Request",
        "${user!.name} has sent you a request for Booking",
        host.notificationToken,
        {},
      );

      var notification = NotificationModel(
        id: FirebaseUtils.newId.toString(),
        title: "${user.name} sent you a request for booking",
        read: false,
        data: {
          "bookingId": booking.bookingId,
          "vehicleId": addHostVehicle.vehicleId
        },
        timestamp: FirebaseUtils.newId,
        senderId: FirebaseUtils.myId,
        receiverId: addHostVehicle.hostId,
        type: 'Booking Request',
        subtitle: '',
      );
      await notificationRef
          .doc(notification.id)
          .set(notification.toMap())
          .catchError((error) {
        loading.value = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
      loading.value = false;

      showBottomSheet(context);
    }).catchError((error) {
      loading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
    // await PaymentsController2().makePayment(
    //     controller.TotalVehicleRent.value.round()
    //         .toString(), "NOK",
    //     onSuccess: (infoData) {
    //       print(infoData);
    //     }, onError: (error) {
    //   return;
    // }).then((value) async{
    // }).catchError((error){
    //   print(error.toString());
    // });
  }

  ScreenBookingReview({
    required this.addHostVehicle,
  });
}

Future<void> showBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/successful_purchase.png",
                width: 140,
                height: 140,
              ),
              SizedBox(height: 6.h),
              Text(
                "Congratulations!",
                style: TextStyle(
                  fontSize: 20,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Your request has been sent to the driver. You will be notified once it is accepted.",
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: CustomButton(
                    title: "Back Home",
                    onPressed: () {
                      Get.offAll(ScreenUserHome());
                    }),
              )
            ],
          ),
        );
      });
}

Widget BookingSummary(String title, description) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Color(0xff484848).withOpacity(.7),
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        description,
        style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "UrbanistBold"),
      ),
    ],
  ).marginSymmetric(horizontal: 12.w, vertical: 4.h);
}
