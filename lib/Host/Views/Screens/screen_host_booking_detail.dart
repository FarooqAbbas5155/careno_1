import 'dart:developer';

import 'package:careno/User/views/screens/screen_user_chat.dart';
import 'package:careno/constant/my_helper_by_callofcoding.dart';
import 'package:careno/controllers/controller_host_home.dart';
import 'package:careno/models/categories.dart';
import 'package:careno/models/rating.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/colors.dart';
import '../../../constant/fcm.dart';
import '../../../constant/firebase_utils.dart';
import '../../../constant/helpers.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/add_host_vehicle.dart';
import '../../../models/booking.dart';
import '../../../models/notification_model.dart';
import '../../../models/user.dart';

class ScreenHostBookingDetail extends StatelessWidget {
  Booking booking;
  User user;
  AddHostVehicle vehicle;

  @override
  Widget build(BuildContext context) {
    var percentageValue = booking.price / 100 * 15;
    var totalRent = percentageValue + booking.price;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2.0,
          title: Text(
            "Booking Detail",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
        ),
        body: FutureBuilder<Category>(
            future: getCategory(vehicle.vehicleCategory),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              var category = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    buildBookedServiceContainer(),
                    buildVehicleContainer(category!.name),
                    buildSummaryContainer(percentageValue, totalRent)
                  ],
                ),
              );
            }),
      ),
    );
  }

  Container buildSummaryContainer(percentageValue, totalRent) {
    return Container(
      padding: EdgeInsets.all(10.r),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.12),
                offset: Offset(2, 2),
                blurStyle: BlurStyle.outer,
                blurRadius: 15.r,
                spreadRadius: 2.r),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Booking Summary",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Start Date ",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF484848).withOpacity(.7)),
              ),
              Text(
                dateFormat(DateTime.fromMillisecondsSinceEpoch(
                    booking.bookingStartDate)),
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263238)),
              ),
            ],
          ).marginSymmetric(vertical: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "End Date ",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF484848).withOpacity(.7)),
              ),
              Text(
                dateFormat(DateTime.fromMillisecondsSinceEpoch(
                    booking.bookingEndDate)),
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263238)),
              ),
            ],
          ).marginSymmetric(vertical: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pick-up Time ",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF484848).withOpacity(.7)),
              ),
              Text(
                formatTime(booking.startTime),
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263238)),
              ),
            ],
          ).marginSymmetric(vertical: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Drop-off Time",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF484848).withOpacity(.7)),
              ),
              Text(
                formatTime(booking.EndTime),
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263238)),
              ),
            ],
          ).marginSymmetric(vertical: 4.h),
          Divider(
            color: Colors.black.withOpacity(.1),
          ),
          Text(
            "Booking Summary",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF484848).withOpacity(.7)),
              ),
              Text(
                "${booking.price}${currencyUnit}",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263238)),
              ),
            ],
          ).marginSymmetric(vertical: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Service Fee",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF484848).withOpacity(.7)),
              ),
              Text(
                "${percentageValue}${currencyUnit}",
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263238)),
              ),
            ],
          ).marginSymmetric(vertical: 4.h),
          Divider(
            height: 10.h,
            color: Colors.black.withOpacity(.1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF484848).withOpacity(.7)),
              ),
              Text(
                "${totalRent}${currencyUnit}",
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appPrimaryColor),
              ),
            ],
          ).marginSymmetric(vertical: 4.h),
          if (booking.bookingStatus == "Request Pending") buildPendingButton(),
          if (booking.bookingStatus=="Pending Approval") buildMarkedCompletedButton(),
          if (booking.bookingStatus == "Payment Pending")
            buildPendingPaymentButton().marginOnly(top: 10.h),
          if (booking.bookingStatus == "In progress") buildInprogressButton(),
          if (booking.bookingStatus == "Completed" ||
              booking.bookingStatus == "Canceled")
            buildCompletedButton(),
          if (booking.isRated == true) buildReview(),
          if (booking.bookingStatus == "Canceled") buildCanceledReason(),
        ],
      ),
    );
  }
RxBool loading=false.obs;
  Widget buildMarkedCompletedButton() {
    return Column(
      children: [
        Row(
          children: [
            // Expanded(
            //   child: CustomButton(
            //     title: "Later",
            //     onPressed: () async {
            //       loading.value=true;
            //       var host = Get
            //           .find<ControllerHostHome>()
            //           .user
            //           .value;
            //       await bookingsRef
            //           .doc(booking.bookingId)
            //           .update({"bookingStatus": "Pending Approval"}).then((value) async {
            //         await FCM.sendMessageSingle(
            //           "Your Booking Not Completed",
            //           "${host!.name} Not Marked Completed booking",
            //           user.notificationToken,
            //           {},
            //         );
            //
            //         var notification = NotificationModel(
            //           id: FirebaseUtils.newId.toString(),
            //           title: "${host.name}  Not Marked Completed booking",
            //           read: false,
            //           data: {
            //             "bookingId": booking.bookingId,
            //             "vehicleId": vehicle.vehicleId
            //           },
            //           timestamp: FirebaseUtils.newId,
            //           senderId: FirebaseUtils.myId,
            //           receiverId: user.uid,
            //           type: 'Booking Not Completed',
            //           subtitle: '',
            //         );
            //         await notificationRef
            //             .doc(notification.id)
            //             .set(notification.toMap());
            //         loading.value=false;
            //         Get.back();
            //       });
            //     },
            //     textStyle: TextStyle(
            //         fontSize: 15.sp,
            //         fontWeight: FontWeight.w700,
            //         color: Colors.white),
            //     color: Color(0xFFFF2021),
            //   ),
            // ),
            Expanded(
              child: CustomButton(
                  width: 217.w,
                  textStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                  title: "Message",
                  onPressed: () {
                    Get.to(ScreenUserChat(
                      user: user,
                    ));
                  }),
            ),
            SizedBox(
              width: 15.w,
            ),
            Expanded(
              child: CustomButton(
                title: "Mark Completed",
                onPressed: () async {
                  loading.value=true;
                  var host = Get
                      .find<ControllerHostHome>()
                      .user
                      .value;
                  log(host.toString());
                  await bookingsRef.doc(booking.bookingId).update(
                      {"bookingStatus": "Completed",
                      "completed":true
                      }).then((value) async {


                        // await usersRef.doc(host!.uid).update({"currentBalance": host.currentBalance+booking.price});

                    await updateHostWallet(senderName: user.name, paymentMethod: booking.paymentStatus, vehicleName: vehicle.vehicleModel, newAmount: booking.price, hostId: booking.hostId);
                    if (host!.notification  == true)   {


                      await FCM.sendMessageSingle(
                        "Your Booking Completed",
                        "${host!.name} has marked booking completed",
                        user.notificationToken,
                        {},
                      );

                      var notification = NotificationModel(
                        id: FirebaseUtils.newId.toString(),
                        title: "${host.name} has marked booking completed",
                        read: false,
                        data: {
                          "bookingId": booking.bookingId,
                          "vehicleId": vehicle.vehicleId
                        },
                        timestamp: FirebaseUtils.newId,
                        senderId: FirebaseUtils.myId,
                        receiverId: user.uid,
                        type: 'Booking Request',
                        subtitle: '',
                      );
                      await notificationRef
                          .doc(notification.id)
                          .set(notification.toMap());

                    }
                    loading.value=false;

                    Get.back();
                  });
                },
                color: Color(0xFF0F9D58),
                textStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            )
          ],
        ).marginSymmetric(vertical: 15.h),
        // Align(
        //   alignment: Alignment.center,
        //   child: CustomButton(
        //       width: 217.w,
        //       textStyle: TextStyle(
        //           fontSize: 15.sp,
        //           fontWeight: FontWeight.w700,
        //           color: Colors.white),
        //       title: "Message",
        //       onPressed: () {
        //         Get.to(ScreenUserChat(
        //           user: user,
        //         ));
        //       }),
        // )
      ],
    );
  }
  Widget buildPendingButton() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: "Decline",
                onPressed: () async {
                  loading.value=true;
                  var host = Get
                      .find<ControllerHostHome>()
                      .user
                      .value;
                  await bookingsRef.doc(booking.bookingId).update({"bookingStatus": "Rejected"}).then((value) async {
                    if (host!.notification == true) {
                      await FCM.sendMessageSingle(
                        "Your Booking Request Rejected",
                        "${host!.name} has Rejected your booking request",
                        user.notificationToken,
                        {},
                      );

                      var notification = NotificationModel(
                        id: FirebaseUtils.newId.toString(),
                        title: "${host.name} has Rejected your booking request",
                        read: false,
                        data: {
                          "bookingId": booking.bookingId,
                          "vehicleId": vehicle.vehicleId
                        },
                        timestamp: FirebaseUtils.newId,
                        senderId: FirebaseUtils.myId,
                        receiverId: user.uid,
                        type: 'Booking Request',
                        subtitle: '',
                      );
                      await notificationRef.doc(notification.id).set(notification.toMap());

                    }
                    loading.value=false;
                    Get.back();
                  });
                },
                textStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                color: Color(0xFFFF2021),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            Expanded(
              child: CustomButton(
                title: "Accept",
                onPressed: () async {
                  loading.value=true;
                  var host = Get
                      .find<ControllerHostHome>()
                      .user
                      .value;
                  log(host.toString());
                  await bookingsRef.doc(booking.bookingId).update(
                      {"bookingStatus": "Payment Pending"}).then((value) async {
                        if (host!.notification == true) {
                          await FCM.sendMessageSingle(
                            "Your Booking Request Accepted",
                            "${host!.name} has sent you a request for Booking Payment Request",
                            user.notificationToken,
                            {},
                          );

                          var notification = NotificationModel(
                            id: FirebaseUtils.newId.toString(),
                            title: "${host.name} has sent you a request for Booking Payment Request",
                            read: false,
                            data: {
                              "bookingId": booking.bookingId,
                              "vehicleId": vehicle.vehicleId
                            },
                            timestamp: FirebaseUtils.newId,
                            senderId: FirebaseUtils.myId,
                            receiverId: user.uid,
                            type: 'Booking Request',
                            subtitle: '',
                          );
                          await notificationRef
                              .doc(notification.id)
                              .set(notification.toMap());
                        }
                    loading.value=false;

                    Get.back();
                  });
                },
                color: Color(0xFF0F9D58),
                textStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            )
          ],
        ).marginSymmetric(vertical: 15.h),
        Align(
          alignment: Alignment.center,
          child: CustomButton(
              width: 217.w,
              textStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              title: "Message",
              onPressed: () {
                Get.to(ScreenUserChat(
                  user: user,
                ));
              }),
        )
      ],
    );
  }

  Container buildVehicleContainer(String categoryName) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.12),
                offset: Offset(2, 2),
                blurStyle: BlurStyle.outer,
                blurRadius: 15.r,
                spreadRadius: 2.r),
          ]),
      child: ExpansionTile(
        textColor: Colors.black,
        iconColor: Colors.black,

        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: EdgeInsets.symmetric(horizontal: 16.w),

        // expandedAlignment: Alignment.centerLeft,
        maintainState: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
        ),
        title: Text(
          "Vehicle Details",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),
        ),
        children: [
          SizedBox(
            height: 72.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: Get.height,
                  width: 73.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      image: DecorationImage(
                          image: NetworkImage(vehicle.vehicleImageComplete),
                          fit: BoxFit.fill)),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.vehicleModel,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14.sp),
                            ),
                            Text(
                              vehicle.address,
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  color: AppColors.appPrimaryColor,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  fontSize: 11.sp),
                            ),
                          ],
                        ).marginOnly(left: 8.w, right: 15.w),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ).marginSymmetric(vertical: 4.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: RichText(
                    text: TextSpan(
                        text: "Year: ",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF616161)),
                        children: [
                      TextSpan(
                          text: vehicle.vehicleYear.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Color(0xFF828282)))
                    ])),
              ),
              Expanded(
                flex: 2,
                child: RichText(
                    text: TextSpan(
                        text: "Type: ",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF616161)),
                        children: [
                      TextSpan(
                          text: categoryName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Color(0xFF828282)))
                    ])),
              ),
            ],
          ).marginSymmetric(vertical: 4.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: RichText(
                    text: TextSpan(
                        text: "Color: ",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF616161)),
                        children: [
                      TextSpan(
                          text: vehicle.vehicleColor,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Color(0xFF828282)))
                    ])),
              ),
              Expanded(
                flex: 2,
                child: RichText(
                    text: TextSpan(
                        text: "Seats: ",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF616161)),
                        children: [
                      TextSpan(
                          text: vehicle.vehicleSeats,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Color(0xFF828282)))
                    ])),
              ),
            ],
          ).marginSymmetric(vertical: 4.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: RichText(
                    text: TextSpan(
                        text: "Transmission: ",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF616161)),
                        children: [
                      TextSpan(
                          text: vehicle.vehicleTransmission,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Color(0xFF828282)))
                    ])),
              ),
              Expanded(
                flex: 2,
                child: RichText(
                    text: TextSpan(
                        text: "Fuel Type: ",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF616161)),
                        children: [
                      TextSpan(
                          text: vehicle.vehicleFuelType,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Color(0xFF828282)))
                    ])),
              ),
            ],
          ).marginSymmetric(vertical: 4.h),
          Text(
            "Description",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ).marginSymmetric(vertical: 4.h),
          Text(
            vehicle.vehicleDescription,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
                color: Color(0xFf828282)),
          ).marginSymmetric(vertical: 4.h),
        ],
      ),
    );
  }

  Container buildBookedServiceContainer() {
    return Container(
      padding: EdgeInsets.all(10.r),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.12),
                offset: Offset(2, 2),
                blurStyle: BlurStyle.outer,
                blurRadius: 15.r,
                spreadRadius: 2.r),
          ]),
      child: SizedBox(
        height: 72.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: Get.height,
              width: 73.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  image: DecorationImage(
                      image: NetworkImage(user.imageUrl), fit: BoxFit.fill)),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14.sp),
                        ),
                        Text(
                          user.address,
                          style: TextStyle(
                              fontFamily: "Nunito",
                              color: AppColors.appPrimaryColor,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              fontSize: 11.sp),
                        ),
                      ],
                    ).marginOnly(left: 8.w, right: 15.w),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        height: 8.h,
                        width: 8.h,
                        decoration: BoxDecoration(
                            color: booking.bookingStatus == "Request Pending"
                                ? Color(0xFFFB9701)
                                : booking.bookingStatus == "Payment Pending"
                                    ? Color(0xFF1A9667)
                                    : booking.bookingStatus == "In progress"
                                        ? Color(0xFF3C79E6)
                                        : booking.bookingStatus == "Completed"
                                            ? Color(0xFF0F9D58)
                                            : Color(0xFFFF2021),
                            shape: BoxShape.circle),
                      ),
                      Text(
                        booking.bookingStatus,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: booking.bookingStatus == "Request Pending"
                                ? Color(0xFFFB9701)
                                : booking.bookingStatus == "Payment Pending"
                                    ? Color(0xFF1A9667)
                                    : booking.bookingStatus == "In progress"
                                        ? Color(0xFF3C79E6)
                                        : booking.bookingStatus == "Completed"
                                            ? Color(0xFF0F9D58)
                                            : Color(0xFFFF2021),
                            fontSize: 12.sp),
                      ).marginOnly(bottom: 4.h, top: 4.h),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPendingPaymentButton() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            title: "Message",
            textStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white),
            color: AppColors.appPrimaryColor,
            onPressed: () {
              Get.to(ScreenUserChat(
                user: user,
              ));
            },
          ),
        ),
      ],
    );
  }

  buildInprogressButton() {
    return Row(
      children: [
        // Expanded(
        //   child: CustomButton(
        //     title: "Cancel Booking",
        //     textStyle: TextStyle(
        //         fontSize: 15.sp,
        //         fontWeight: FontWeight.w700,
        //         color: Colors.white),
        //     color: AppColors.appPrimaryColor,
        //     onPressed: () {
        //       showDialog(
        //         context: Get.context!,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(14.r),
        //             ),
        //             backgroundColor: Colors.white,
        //             title: Center(
        //               child: Text(
        //                 'Cancel Booking',
        //                 style: TextStyle(
        //                   color: primaryColor,
        //                   fontSize: 20.sp,
        //                   fontWeight: FontWeight.w700,
        //                 ),
        //               ),
        //             ),
        //             contentPadding: EdgeInsets.symmetric(vertical: 20.h),
        //             // Decrease height here
        //             content: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 TextField(
        //                   maxLines: 8,
        //                   decoration: InputDecoration(
        //                     border: OutlineInputBorder(
        //                       borderRadius: BorderRadius.circular(12.0),
        //                       borderSide: const BorderSide(
        //                         width: 1,
        //                         style: BorderStyle.none,
        //                       ),
        //                     ),
        //                     filled: true,
        //                     hintStyle: TextStyle(
        //                         color: Color(0xFF7D7D7D),
        //                         fontSize: 12.sp,
        //                         fontWeight: FontWeight.w500),
        //                     hintText: "Explain Cancel Reason",
        //                     contentPadding:
        //                         EdgeInsets.only(left: 12, top: 10.h, bottom: 5),
        //                     fillColor: Colors.white,
        //                   ),
        //                 ).paddingSymmetric(horizontal: 20.w),
        //                 SizedBox(height: 20.h),
        //                 CustomButton(
        //                     title: 'Submit',
        //                     onPressed: () {
        //                       Get.back();
        //                     }).paddingSymmetric(horizontal: 20.w),
        //               ],
        //             ),
        //           );
        //         },
        //       );
        //     },
        //   ),
        // ),
        // SizedBox(
        //   width: 10.w,
        // ),
        Expanded(
          child: CustomButton(
            title: "Message",
            textStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white),
            color: AppColors.appPrimaryColor,
            onPressed: () {},
          ),
        ),
      ],
    ).marginSymmetric(vertical: 15.h);
  }

  buildCompletedButton() {
    return CustomButton(
      title: "Message",
      onPressed: () {
        Get.to(ScreenUserChat(
          user: user,
        ));
      },
      textStyle: TextStyle(
          fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white),
    ).marginSymmetric(vertical: 15.h);
  }

  buildReview() {
    return FutureBuilder<DocumentSnapshot>(
      future: reviewRef.doc(booking.bookingId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState==ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());

        }
        var rating = Rating.fromMap(snapshot.data!.data() as Map<String,dynamic>);
        return FutureBuilder<User?>(
          future: getUser(rating.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            var user=snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.black.withOpacity(.1),
                  thickness: .5,
                ),
                Text(
                  "Customer Review",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user!.imageUrl,),
                  ),
                  title: Text(
                    user.name,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B1B1B)),
                  ),
                  subtitle: Text(
                    "${dateFormat(DateTime.fromMillisecondsSinceEpoch(rating.timeStamp))}",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 8.sp,
                        color: Color(0xFF999999)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Color(0xFFFBC017),
                      ),
                      Text(
                        rating.avgRating.toString(),
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
                      )
                    ],
                  ),
                ),
                Text(
                  rating.description,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF414141)),
                )
              ],
            ).marginSymmetric(vertical: 10.h);
          }
        );
      }
    );
  }

  buildCanceledReason() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Colors.black.withOpacity(.1),
          thickness: .5,
        ),
        Text(
          "Cancel Reason",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),
        ),
        Text(
          "Customer has canceled the Booking.",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFFFF2021),
              fontSize: 12.sp),
        ).marginSymmetric(vertical: 5.h),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tempor turpis quis ex eleifend, eget tempor diam ultricies. Nullam eu velit nec justo vestibulum aliquam. Duis auctor diam eu elit consequat, vel dapibus purus consequat.',
          style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF414141)),
        )
      ],
    );
  }

  ScreenHostBookingDetail({
    required this.booking,
    required this.user,
    required this.vehicle,
  });
}
