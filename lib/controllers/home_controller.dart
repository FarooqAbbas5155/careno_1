import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:careno/models/categories.dart';
import 'package:careno/models/rating.dart';
import 'package:careno/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Host/Views/Screens/screen_host_add_ident_identity_proof.dart';
import '../User/views/screens/screen_user_home.dart';
import '../constant/CustomDialog.dart';
import '../constant/fcm.dart';
import '../constant/firebase_utils.dart';
import '../interfaces/like_listener.dart';
import '../models/booking.dart';
import '../models/user.dart' as model;

class HomeController extends GetxController {
  RxInt selectHostIndex=0.obs;
  Rx<int> changeHomeLayout = 0.obs;



  RxInt selectIndex = 0.obs;
  RxList<Category> allCategory= RxList<Category>([]);
  RxList<AddHostVehicle> addhostvehicle= RxList<AddHostVehicle>([]);
  RxList<AddHostVehicle> popularVehicle = RxList<AddHostVehicle>([]);
  Stream<QuerySnapshot>? categoriesSnapshot;
  Stream<QuerySnapshot>? vehicleSnapshot;
  Stream<QuerySnapshot>? popularVehicleSnapshot;


// DateTime? dateTime;
  @override
  void onInit() {
updateToken();
UserStream();
vehicleSnapshot = addVehicleRef.snapshots();
popularVehicleSnapshot = addVehicleRef.where("rating",isGreaterThanOrEqualTo: 4).snapshots();

categoriesSnapshot = categoryRef.snapshots();
addhostvehicle.bindStream(vehicleSnapshot!.map((vehicle) => vehicle.docs.map((e) => AddHostVehicle.fromMap(e.data() as Map<String, dynamic>)).toList()));
popularVehicle.bindStream(popularVehicleSnapshot!.map((vehicle) => vehicle.docs.map((e) => AddHostVehicle.fromMap(e.data() as Map<String, dynamic>)).toList()));
getHostBookingList();
allCategory.bindStream(categoriesSnapshot!.map((category) => category.docs.map((e) => Category.fromMap(e.data() as Map<String, dynamic>)).toList()));
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
  Rx<model.User?> user = Rx<model.User?>(null);


  Set<String> shownPopups = {};

  StreamSubscription<List<Booking>>? requestedBookingsSubscription;
  StreamSubscription<List<Booking>>? startedBookingsSubscription;
  StreamSubscription<List<Booking>>? BookingsSubscription;
  StreamSubscription<List<Booking>>? completedBookingsSubscription;
  StreamSubscription<List<Booking>>? bookingsSubscription;
  RxList<Rating> ratedVehicleList = <Rating>[].obs;
  StreamSubscription<List<Rating>>? ratingSubscription;

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
          // checkAndShowBookingPopup(startedBookingsList);
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
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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
        .where("bookingStatus",isEqualTo: "Request Pending")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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


  Stream<List<Rating>> fetchRatingLists() {
    return reviewRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        return Rating.fromMap(data as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<Booking>> FetchCompletedBookingLists() {
    return bookingsRef
        .where("bookingStatus", whereIn: ["Completed", "Canceled"])
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        return Booking.fromMap(data as Map<String, dynamic>);
      }).toList();
    });
  }
  void checkAndShowBookingPopup(List<Booking> bookings) {
    final now = DateTime.now();
    log(now.toString());
    bookings.forEach((booking) async {
      log(shownPopups.toString());
            bool show=shownPopups.contains(booking.bookingId);
            log("Sho$show");
      if (show==false) {
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
          shownPopups.add(booking.bookingId);
          CustomDialog.showCustomDialog(
              Get.context!,
              Container(
                height: Get.height * .2,
                width: Get.width,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: usersRef.doc(booking.hostId).snapshots(),
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
                                ]).marginSymmetric(vertical: 20.h,horizontal: 20.w);
                          });
                    }),
              ),
              10.0);
        }
        else if (now.isAfter(fifteenMinutesBefore) ||
            now.isAtSameMomentAs(fifteenMinutesBefore)) {
          shownPopups.add(booking.bookingId);
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

  void clearController() {
    // Clear all lists and variables
    selectHostIndex.value = 0;
    changeHomeLayout.value = 0;
    selectIndex.value = 0;
    allCategory.clear();
    addhostvehicle.clear();
    popularVehicle.clear();
    ratedVehicleList.clear();
    requestedBookingsList.clear();
    startedBookingsList.clear();
    completedBookingsList.clear();
    bookingsList.clear();
    isFetchingStartedBookings.value = true;
    isFetchingRequestedBookings.value = true;
    isFetchingBookings.value = true;
    isFetchingCompletedBookings.value = true;

    // Cancel all subscriptions
    ratingSubscription?.cancel();
    bookingsSubscription?.cancel();
    requestedBookingsSubscription?.cancel();
    startedBookingsSubscription?.cancel();
    completedBookingsSubscription?.cancel();
  }

}

