import 'dart:io';

import 'package:careno/AuthSection/screen_login.dart';
import 'package:careno/AuthSection/screen_welcome.dart';
import 'package:careno/Host/Views/Screens/screen_host_home_page.dart';
import 'package:careno/User/views/screens/screen_user_home.dart';
import 'package:careno/constant/my_helper_by_callofcoding.dart';
import 'package:careno/controllers/home_controller.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:careno/models/categories.dart';
import 'package:careno/models/rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

import '../AuthSection/screen_complete_profile.dart';
import '../AuthSection/screen_user_block_screen.dart';
import '../Host/Views/Screens/screen_host_account_pending.dart';
import '../Host/Views/Screens/screen_host_add_ident_identity_proof.dart';
import '../Host/Views/Screens/screen_host_add_vehicle.dart';
import '../controllers/controller_host_home.dart';
import '../interfaces/like_listener.dart';
import '../models/user.dart';

var uid = auth.FirebaseAuth.instance.currentUser!.uid;
String image_url =
    "https://phito.be/wp-content/uploads/2020/01/placeholder.png";
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
CollectionReference bannerRef = dbInstance.collection("promotionalBanner");
CollectionReference termsAndConditionsCollection =
    dbInstance.collection('termsAndConditions');
CollectionReference policyCollection = dbInstance.collection('policy');

Map<String, User> _allUsersMap = {};
Map<String, Category> _allCategoryMap = {};
Map<String, Rating> allVehicleRatings = {};
Map<String, Rating> ratingsMap = {};
// var currencyUnit = "\$";

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
    } else if (user.email.isEmpty) {
      screen = ScreenCompleteProfile();
    } else if (user.isBlocked == true) {
      screen = ScreenUserBlockScreen();
    } else {
      if (user.userType == "host") {
        if (user.hostIdentity == null)
        {
          screen = ScreenHostAddIdentIdentityProof();
        }
        else if (user.isVerified == true) {
          if (hasAddedVehicle == false) {
            screen = ScreenHostAddVehicle();
          }
          else {
            screen = ScreenHostHomePage();
          }
        } else {
          screen = ScreenHostAccountPending();
        }
      } else {
        if (user.email == "") {
          screen = ScreenCompleteProfile();
        } else {
          screen = ScreenUserHome();
        }
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

String dateFormat(
  DateTime dateTime,
) {
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
  DateTime dateTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, hour24);

  // Format the DateTime object using DateFormat to convert to 12-hour format with AM/PM
  DateFormat dateFormat =
      DateFormat('h:mm a'); // 'h:mm a' for 12-hour format with AM/PM
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

void showPopupImage(BuildContext context, String image) {
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

bool value = false;

Future<bool> hasInProgressBookings(String userId) async {
  QuerySnapshot querySnapshot = await bookingsRef
      .where('userId', isEqualTo: userId)
      .where('bookingStatus', isEqualTo: 'In progress')
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Future<void> deleteUserProfileImage(String userId) async {
  try {
    await FirebaseStorage.instance
        .ref('Careno/Users/ProfileImages/$userId')
        .delete();
    await FirebaseStorage.instance.ref('User/${uid}').delete();
    print('User profile image deleted successfully');
  } catch (error) {
    print('Failed to delete user profile image: $error');
  }
}

Future<void> deleteVehicleImages(String userId) async {
  try {
    ListResult listResult = await FirebaseStorage.instance
        .ref('Host/addVehicle/$userId/addVehicle/')
        .listAll();

    for (var item in listResult.items) {
      await item.delete();
    }
    print('All vehicle images deleted successfully');
  } catch (error) {
    print('Failed to delete vehicle images: $error');
  }
}

Future<void> deleteIdentityProofImages(String userId) async {
  try {
    ListResult listResult =
        await FirebaseStorage.instance.ref('User/Host${uid}/').listAll();

    for (var item in listResult.items) {
      await item.delete();
    }
    print('Identity deleted successfully');
  } catch (error) {
    print('Failed to delete vehicle images: $error');
  }
}

Future<void> deleteFolder(String path) async {
  try {
    // Get a reference to the folder
    Reference folderRef = FirebaseStorage.instance.ref().child(path);

    // List all items (files and subdirectories) in the folder
    ListResult result = await folderRef.listAll();

    // Delete each item (file or subdirectory) recursively
    for (Reference itemRef in result.items) {
      if (itemRef.fullPath.endsWith('/')) {
        // If the item is a subdirectory (ends with '/'), delete it recursively
        await deleteFolder(itemRef.fullPath);
      } else {
        // If the item is a file, delete it
        await itemRef.delete();
      }
    }

    // After deleting all items, delete the folder itself
    await folderRef.delete();

    print('Folder $path and its contents deleted successfully.');
  } catch (e) {
    print('Error deleting folder $path: $e');
  }
}

Future<void> deleteUserAccount(BuildContext context, String userId) async {
  hasInProgressBookings(uid);
  DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();

  if (userSnapshot.exists) {
    // Delete user bookings

    // Check for in-progress bookings
    bool hasInProgress = await hasInProgressBookings(userId);
    print("Booking Progerss $hasInProgress");
    if (hasInProgress) {
      Get.back();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cannot Delete Account'),
            content: Text(
              'You cannot delete your account until your booking is complete.',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Delete user vehicles
      await bookingsRef
          .where('userId', isEqualTo: userId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.delete();
        });
      });
      await addVehicleRef
          .where('userId', isEqualTo: userId)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.delete();
        });
        await deleteFolder("Host/addVehicle/$userId/");
      });

      // Delete host bookings
      await bookingsRef
          .where('hostId', isEqualTo: userId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.delete();
        });
      });
      HomeController homeController = HomeController();
      ControllerHostHome homeControllers = ControllerHostHome();

      // Delete user account
      await usersRef.doc(userId).delete();
      await deleteIdentityProofImages(userId);
      await deleteFolder('User/Host${uid}/');
      await deleteDirectory("Careno/Users/ProfileImages/$userId");
      homeController.clearController();
      homeControllers.clearControllers();
      Get.offAll(ScreenLogin());
    }
  } else {
    print('User does not exist!');
  }
}

Future<void> deleteDirectory(String path) async {
  try {
    // Get reference to the directory
    Reference directoryRef = FirebaseStorage.instance.ref().child(path);

    // List all items (files and subdirectories) in the directory
    ListResult result = await directoryRef.listAll();

    // Delete each item (file or subdirectory) recursively
    for (Reference ref in result.items) {
      if (ref.fullPath.endsWith('/')) {
        // If the item is a subdirectory (ends with '/'), delete it recursively
        await deleteDirectory(ref.fullPath);
      } else {
        // If the item is a file, delete it
        await ref.delete();
      }
    }

    // After deleting all items, delete the directory itself
    await directoryRef.delete();

    print('Directory $path and its contents deleted successfully.');
  } catch (e) {
    print('Error deleting directory $path: $e');
  }
}

String getCurrency() {
  var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
  dev.log(format.currencySymbol);
  return format.currencySymbol;
}
