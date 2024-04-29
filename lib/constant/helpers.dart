
import 'dart:io';

import 'package:careno/AuthSection/screen_login.dart';
import 'package:careno/AuthSection/screen_welcome.dart';
import 'package:careno/Host/Views/Screens/screen_host_home_page.dart';
import 'package:careno/User/views/screens/screen_user_home.dart';
import 'package:careno/constant/my_helper_by_callofcoding.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:careno/models/categories.dart';
import 'package:careno/models/rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;


import '../AuthSection/screen_complete_profile.dart';
import '../Host/Views/Screens/screen_host_account_pending.dart';
import '../Host/Views/Screens/screen_host_add_ident_identity_proof.dart';
import '../Host/Views/Screens/screen_host_add_vehicle.dart';
import '../interfaces/like_listener.dart';
import '../models/user.dart';

var uid = auth.FirebaseAuth.instance.currentUser!.uid;
String image_url = "https://phito.be/wp-content/uploads/2020/01/placeholder.png";
String googleApiKey = 'AIzaSyCjxRhtdw74nJ9YdYaGjvY5IZUEA5Ux0JA';

var dbInstance = FirebaseFirestore.instance;
CollectionReference usersRef = dbInstance.collection("users");
CollectionReference hostIdentityProofRef = dbInstance.collection("identies");
CollectionReference categoryRef = dbInstance.collection("categories");
CollectionReference addVehicleRef = dbInstance.collection("vehicles");
CollectionReference viewsRef = dbInstance.collection("views");
CollectionReference bookingsRef = dbInstance.collection("bookings");
CollectionReference reviewRef = dbInstance.collection("reviews");
CollectionReference notificationRef = dbInstance.collection("notifications");

Map<String, User> _allUsersMap = {};
Map<String, Category> _allCategoryMap = {};
Map<String, Rating> allVehicleRatings = {};
Map<String, Rating> ratingsMap = {};
var currencyUnit = "\$";

double? adminPercentage;
///Pushed



Future<bool> hostProofAlreadyExists(String uid) async {
  final doc = await hostIdentityProofRef.doc(uid).get();
  return doc.exists;
}

// Future<Rating> getRatingByVehicleId(String id) async {
//   if (allVehicleRatings.containsKey(id)) {
//     return allVehicleRatings[id]!;
//   }
//   var bookingsDocs =
//       (await bookingsRef.where("vehicleId", isEqualTo: id).get()).docs;
//   var bookings = bookingsDocs
//       .map((e) => Booking.fromMap(e.data() as Map<String, dynamic>))
//       .toList();
//   double rating = 0;
//   int num = 0;
//   bookings.forEach((e) {
//     rating += e.rating ?? 0;
//     num += e.rating != null ? 1 : 0;
//   });
//   var avgRating = (rating / num);
//   if (num == 0) {
//     avgRating = 0;
//   }
//   var obj = Rating(
//       serviceId: id,
//       avgRating: avgRating,
//       num: num,
//       vehicleId: '',
//       userId: '',
//       timeStamp: DateTime.now().millisecondsSinceEpoch);
//   allVehicleRatings[id] = obj;
//   return obj;
// }

Future<Category> getCategory(String id) async {
  var category = _allCategoryMap[id];
  if (category == null) {
    var doc = await categoryRef.doc(id).get();
    category = Category.fromMap(doc.data() as Map<String, dynamic>);
    _allCategoryMap[id] = category;
  }
  return category;
}

Future<User> getUser(String id) async {
  var user = _allUsersMap[id];

  if (user == null) {
    var doc = await usersRef.doc(id).get();
    user = User.fromMap(doc.data() as Map<String, dynamic>);
    _allUsersMap[id] = user;
  }

  return user;
}

String getUid() {
  var uid = (auth.FirebaseAuth.instance.currentUser?.uid ?? "").trim();
  dev.log("uid: $uid");
  return uid;
}

User defaultUser = User(
  userType: "",
  phoneNumber: "phoneNumber",
  imageUrl: "",
  name: '',
  email: '',
  profileDescription: '',
  dob: 0,
  lat: 0.0,
  lng: 0.0,
  uid: uid,
  gender: "",
  notification: false,
  notificationToken: '',
  timeStamp: DateTime.now().millisecondsSinceEpoch,
  isVerified: false,
  isBlocked: false,
  status: '',
  address: '',
  // currentBalance: 0.0,
);

Color primaryColor = Color(0xff4C0AE1);
bool hasAddedVehicle = false;
Future<bool> userHasAddedVehicle() async {
  // Query the database to find all vehicles
  var querySnapshot = await addVehicleRef.where('hostId', isEqualTo: uid).get();

  if (querySnapshot.docs.isNotEmpty) {
    // If there are any documents in the snapshot, it means the user has added a vehicle
    hasAddedVehicle = true;
  }

  return hasAddedVehicle;
}



Future<Widget> getHomeScreen() async {
  Widget screen = ScreenLogin();
  if (auth.FirebaseAuth.instance.currentUser != null) {
    adminPercentage = await getAdminPercentage();
    await userHasAddedVehicle();
    print("hasAddedVehicle $hasAddedVehicle");

    var uid = auth.FirebaseAuth.instance.currentUser!.uid;
    var user = await getUser(uid);
    if (user.userType == "") {
      screen = ScreenWelcome();
    } else if (user.userType == "host") {
      if (user.email == "") {
        screen=ScreenCompleteProfile();
      }
      else if (user.hostIdentity == null) {
        screen = ScreenHostAddIdentIdentityProof();
      } else if (user.isVerified == false){
      screen = ScreenHostAccountPending();
      }
      else if(user.isVerified == true){
        if (hasAddedVehicle == false) {
          screen = ScreenHostAddVehicle();
        }
      }
      else {
        screen = ScreenHostHomePage();
      }
    } else {
      if (user.email == "") {
        screen=ScreenCompleteProfile();
      }
      else{
        screen = ScreenUserHome();
      }
    }
  }

  return screen;
}

Future<FilePickerResult?> PickFile(List<String> type) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: true,
    allowedExtensions: type,
  );
  var files = [];
  if (result != null) {
    PlatformFile file = result.files.first;
    print(file.name);
    print(file.bytes);
    print(files);
    print(file.size);
    print(file.extension);
    print(file.path);
  } else {
    Get.snackbar("Alert", "No File Pick");
  }
  return result;
}

String dateFormat(DateTime dateTime,) {
  // Use DateFormat class from intl package to format the date
  DateFormat dateFormat = DateFormat.yMMMMd('en_US');
  return dateFormat.format(dateTime);
}
String formatDateRange(DateTime startDate, DateTime endDate) {
  // Format the start date and end date
  DateFormat dateFormat = DateFormat.yMMMMd('en_US');

  String formattedStartDate = dateFormat.format(startDate);
  String formattedEndDate = dateFormat.format(endDate);

  // Construct the formatted date range string
  return '$formattedStartDate - $formattedEndDate';
}
String formatTime(int hour24) {

  // Create a DateTime object with the given hour in 24-hour format
  DateTime dateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour24);

  // Format the DateTime object using DateFormat to convert to 12-hour format with AM/PM
  DateFormat dateFormat = DateFormat('h:mm a'); // 'h:mm a' for 12-hour format with AM/PM
  String formattedTime = dateFormat.format(dateTime);

  return formattedTime;
}
void checkForLikes(String vehical_id, LikeListener listener) {
  List<String> likes = [];
  addVehicleRef.doc(vehical_id).collection("likes").snapshots().listen((event) {
    likes = event.docs
        .map((e) => ((e.data() as Map<String, dynamic>)['uid']).toString())
        .toList();
    listener.onLikesUpdated(likes);
  });



}
void showPopupImage(BuildContext context,String image) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Container(
            width: 300.h,
            height: 300.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    },
  );
}

String getCurrency() {
  var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
  dev.log(format.currencySymbol);
  return format.currencySymbol;
}