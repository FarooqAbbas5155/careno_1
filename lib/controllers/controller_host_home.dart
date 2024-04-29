import 'dart:async';
import 'dart:developer';

import 'package:careno/constant/CustomDialog.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/constant/my_helper_by_callofcoding.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constant/fcm.dart';
import '../models/add_host_vehicle.dart';
import '../models/booking.dart';
import '../models/rating.dart';
import '../models/user.dart' as model;

class ControllerHostHome extends GetxController {
  RxInt selectHostIndex = 0.obs;

  Rx<model.User?> user = Rx<model.User?>(null);

// DateTime? dateTime;
  @override
  void onInit() {
    updateToken();
    UserStream();
    getHostBookingList();
    super.onInit();
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;

  void updateToken() async {
    var token = (await FCM.generateToken()) ?? "";
    usersRef.doc(uid).update({"notificationToken": token});
  }

  void UserStream() {
    usersRef.doc(uid).snapshots().listen((event) {
      user.value = model.User.fromMap(event.data() as Map<String, dynamic>);
      log("${user.value}");
    });
  }

  Set<String> shownPopups = {};
  RxList<Rating> ratedVehicleList = <Rating>[].obs;
  StreamSubscription<List<Rating>>? ratingSubscription;

  StreamSubscription<List<Booking>>? requestedBookingsSubscription;
  StreamSubscription<List<Booking>>? startedBookingsSubscription;
  StreamSubscription<List<Booking>>? BookingsSubscription;
  StreamSubscription<List<Booking>>? completedBookingsSubscription;
  StreamSubscription<List<Booking>>? bookingsSubscription;
  RxList<Booking> requestedBookingsList = <Booking>[].obs;
  RxList<Booking> startedBookingsList = <Booking>[].obs;
  RxList<Booking> completedBookingsList = <Booking>[].obs;
  RxList<Booking> bookingsList = <Booking>[].obs;
  RxBool isFetchingStartedBookings = true.obs;
  RxBool isFetchingRequestedBookings = true.obs;
  RxBool isFetchingBookings = true.obs;
  RxBool isFetchingCompletedBookings = true.obs;

  void getHostBookingList() {
    ratingSubscription = fetchRatingLists().listen((List<Rating> ratings) {
      ratedVehicleList.assignAll(ratings);
      isFetchingBookings.value = false;
      log(ratings.toString());
    });
    bookingsSubscription = fetchBookingLists().listen((List<Booking> bookings) {
      bookingsList.assignAll(bookings);
      isFetchingBookings.value = false;
      log(bookings.toString());
    });
    requestedBookingsSubscription =
        FetchRequestedBookingLists().listen((List<Booking> bookings) {
      requestedBookingsList.assignAll(bookings);
      isFetchingRequestedBookings.value = false;
      log(bookings.toString());
    });
    startedBookingsSubscription =
        FetchStartedBookingLists().listen((List<Booking> bookings) {
      startedBookingsList.assignAll(bookings);
      isFetchingStartedBookings.value = false;
      log(bookings.toString());
      checkAndShowBookingPopup(startedBookingsList);
    });

    completedBookingsSubscription =
        FetchCompletedBookingLists().listen((List<Booking> bookings) {
      completedBookingsList.assignAll(bookings);
      isFetchingCompletedBookings.value = false;

      // checkAndShowRatingPopup(bookings);
    });
  }

  Stream<List<Booking>> FetchStartedBookingLists() {
    return bookingsRef
        .where("bookingStatus", whereIn: ["In progress", "Pending Approval"])
        .where("hostId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            var data = doc.data();
            return Booking.fromMap(data as Map<String, dynamic>);
          }).toList();
        });
  }

  Stream<List<Booking>> FetchRequestedBookingLists() {
    return bookingsRef
        .where("bookingStatus", whereIn: ["Request Pending", "Payment Pending"])
        .where("hostId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            var data = doc.data();
            return Booking.fromMap(data as Map<String, dynamic>);
          }).toList();
        });
  }

  Stream<List<Booking>> fetchBookingLists() {
    return bookingsRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        return Booking.fromMap(data as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<Booking>> FetchCompletedBookingLists() {
    return bookingsRef
        .where("bookingStatus", whereIn: ["Completed", "Canceled"])
        .where("hostId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            var data = doc.data();
            return Booking.fromMap(data as Map<String, dynamic>);
          }).toList();
        });
  }

  @override
  void onClose() {
    // shownPopups = {};
  }
  Stream<List<Rating>> fetchRatingLists() {
    return reviewRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        return Rating.fromMap(data as Map<String, dynamic>);
      }).toList();
    });
  }

  void checkAndShowBookingPopup(List<Booking> bookings) {
    final now = DateTime.now();
    log(now.toString());
    bookings.forEach((booking) async {
      log(shownPopups.toString());

      if (!shownPopups.contains(booking.bookingId)) {
        shownPopups.add(booking.bookingId);
        final bookingEndDate =
            DateTime.fromMillisecondsSinceEpoch(booking.bookingEndDate);
        final bookingEndTime =
            DateTime.fromMillisecondsSinceEpoch(booking.EndTime);

        final endTime = DateTime(
          bookingEndDate.year,
          bookingEndDate.month,
          bookingEndDate.day,
          bookingEndTime.hour,
          bookingEndTime.minute,
        );

        log(endTime.toString());

        final fifteenMinutesBefore = endTime.subtract(Duration(minutes: 15));
        log(fifteenMinutesBefore.toString());

        if (now.isAfter(endTime)) {

          await updateBookingStatus(booking.bookingId, "Pending Approval");
          CustomDialog.showCustomDialog(
              Get.context!,
              Container(
                height: Get.height * .25,
                width: Get.width,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: usersRef.doc(booking.userId).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox();
                      }
                      var user = model.User.fromMap(
                          snapshot.data!.data() as Map<String, dynamic>);
                      return StreamBuilder<DocumentSnapshot>(
                          stream:
                              addVehicleRef.doc(booking.vehicleId).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox();
                            }
                            var vehicle = AddHostVehicle.fromMap(
                                snapshot.data!.data() as Map<String, dynamic>);
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Congratulation",
                                    style: TextStyle(
                                        fontSize: 24.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text:
                                              "Your Booking has been completed of vehicle ",
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.black,
                                              height: 1.5,

                                              fontWeight: FontWeight.w400),
                                          children: [
                                        TextSpan(
                                            text: "${vehicle.vehicleModel}",
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppColors.appPrimaryColor)),
                                        TextSpan(
                                            text: " with ",
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400)),
                                        TextSpan(
                                            text: "${user.name}.",
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppColors.appPrimaryColor)),
                                      ])),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: CustomButton(
                                            title: "Later",
                                            height: 36.h,
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.sp,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Get.back();
                                            }),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                            title: "Mark Completed",
                                            height: 35.h,
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.sp,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async {

                                              await bookingsRef
                                                  .doc(booking.bookingId)
                                                  .update({
                                                "completed": true,
                                                "bookingStatus": "Completed"
                                              });
                                              
                                              await updateHostWallet(senderName: user.name, paymentMethod: booking.paymentStatus, vehicleName: vehicle.vehicleModel, newAmount: booking.price, hostId: booking.hostId);
                                              
                                              // await usersRef.doc(booking.hostId).update({"currentBalance": user!.currentBalance+booking.price});

                                              Get.back();
                                            }),
                                      ),
                                    ],
                                  ),
                                ]).marginSymmetric(vertical: 20.h,horizontal: 20.w);
                          });
                    }),
              ),
              10.0);
        } else if (now.isAfter(fifteenMinutesBefore) ||
            now.isAtSameMomentAs(fifteenMinutesBefore)) {
          ScaffoldMessenger.of(Get.context!)
              .showSnackBar(SnackBar(content: Text("End")));

          Get.snackbar(
            "Booking Reminder",
            "Your booking will end in 15 minutes",
            duration: Duration(seconds: 10),
            backgroundColor: Colors.amber,
            colorText: Colors.black,
          );
        }
      }
    });
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    // Implement your logic to update booking status here
    // For example, make a call to update the booking status in your database
    await bookingsRef.doc(bookingId).update({"bookingStatus": newStatus});
  }
  double calculateOverallRating(List<Rating> ratings, String vehicleId,totalRating) {
    log(ratings.length.toString());
    // double totalRating = 0.0;
    int totalFeedbackCount = 1;

    // Iterate through completed bookings for the specific provider
    for (Rating rating in ratings) {
      // Check if the booking belongs to the provider and has feedback
      if (rating.vehicleId == vehicleId) {
        totalRating += rating.avgRating;
        log(totalRating.toString());
        totalFeedbackCount++;
      }
    }
    // overFeedBack.value=totalFeedbackCount;
    // Calculate average rating
    double overallRating = totalFeedbackCount > 0 ? totalRating / totalFeedbackCount : 0.0;
    return overallRating;
  }
  int getReviewCount(List<Rating> ratings, String vehicleId) {

    int completedBookingsCount = 0;
    // Iterate through completed bookings for the specific provider
    for (Rating rating in ratings) {
      // Check if the booking belongs to the provider and has feedback
      if (rating.vehicleId == vehicleId ) {
        completedBookingsCount++;
      }
    }

    return completedBookingsCount;
  }
}
