import 'dart:developer';

import 'package:careno/User/views/screens/screen_booking_details.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:careno/models/booking.dart';
import 'package:careno/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/colors.dart';

class ItemUserBooking extends StatelessWidget {
Booking booking;

@override
  Widget build(BuildContext context) {
    return  StreamBuilder<DocumentSnapshot>(
      stream: usersRef.doc(booking.hostId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState==ConnectionState.waiting) {
          return SizedBox();
        }
        var host=User.fromMap(snapshot.data!.data() as Map<String,dynamic>);
        log(booking.vehicleId);
        return StreamBuilder<DocumentSnapshot>(
          stream: addVehicleRef.doc(booking.vehicleId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.waiting) {
              return SizedBox();
            }
            var vehicle=AddHostVehicle.fromMap(snapshot.data!.data() as Map<String,dynamic>);
            return GestureDetector(
              onTap: (){
                Get.to(ScreenBookingDetails(booking: booking, host: host, vehicle: vehicle,));
              },
              child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    image: NetworkImage(host.imageUrl),
                                    fit: BoxFit.fill)),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        host.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 14.sp),
                                      ),
                                      Text(
                                        vehicle.address,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            decoration: TextDecoration.underline,

                                            fontFamily: "Nunito",

                                            color: AppColors.appPrimaryColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11.sp),
                                      ),
                                    ],
                                  ).marginOnly(left: 8.w, right: 15.w),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                                          height: 8.h,
                                          width: 8.h,
                                          decoration: BoxDecoration(
                                              color: booking
                                                  .bookingStatus ==
                                                  "Request Pending"
                                                  ? Color(0xFFFB9701)
                                                  : booking.bookingStatus ==
                                                  "Payment Pending"
                                                  ? Color(0xFF1A9667)
                                                  : booking.bookingStatus ==
                                                  "In progress"
                                                  ? Color(
                                                  0xFF3C79E6)
                                                  : booking.bookingStatus ==
                                                  "Completed"
                                                  ? Color(
                                                  0xFF0F9D58)
                                                  : Color(
                                                  0xFFFF2021),
                                              shape: BoxShape.circle),
                                        ),
                                        Text(
                                          booking.bookingStatus,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic,
                                              color: booking
                                                  .bookingStatus ==
                                                  "Request Pending"
                                                  ? Color(0xFFFB9701)
                                                  : booking.bookingStatus ==
                                                  "Payment Pending"
                                                  ? Color(0xFF1A9667)
                                                  : booking.bookingStatus ==
                                                  "In progress"
                                                  ? Color(
                                                  0xFF3C79E6)
                                                  : booking.bookingStatus ==
                                                  "Completed"
                                                  ? Color(
                                                  0xFF0F9D58)
                                                  : Color(
                                                  0xFFFF2021),
                                              fontSize: 12.sp),
                                        ).marginOnly(bottom: 4.h, top: 4.h),
                                      ],
                                    ),
                                    Text(
                                      "${vehicle.currency}${booking.price}",
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.appPrimaryColor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Booking Start & End Date',
                                style: TextStyle(
                                    color: Color(0xFF848484),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.sp,
                                    fontFamily: "Nunito"),
                              ).marginOnly(bottom: 3.h),
                              Text(
                                "${formatDateRange(DateTime.fromMillisecondsSinceEpoch(booking.bookingStartDate), DateTime.fromMillisecondsSinceEpoch(booking.bookingEndDate))}",
                                style:
                                TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp,color: Colors.black),
                              )
                            ],
                          ),
                          VerticalDivider(color: Colors.black.withOpacity(.1),),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Pick-up & Drop-off Time',
                                style: TextStyle(
                                    color: Color(0xFF848484),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.sp,
                                    fontFamily: "Nunito"),
                              ).marginOnly(bottom: 3.h),
                              Text(
                                "${formatTime(booking.startTime)} - ${formatTime(booking.EndTime)}",
                                style:
                                TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp,color: Colors.black),
                              )
                            ],
                          ),
                        ],
                      ),
                    ).marginOnly(top: 15.h),
                  ],
                ),
              ),
            );
          }
        );
      }
    );;
  }

ItemUserBooking({
    required this.booking,
  });


}
