import 'package:careno/AuthSection/screen_welcome.dart';
import 'package:careno/Host/Views/Screens/screen_host_home_page.dart';
import 'package:careno/User/views/screens/screen_user_home.dart';
import 'package:careno/controllers/phone_controller.dart';
import 'package:careno/models/user.dart' as usermodel;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../AuthSection/screen_complete_profile.dart';
import '../constant/helpers.dart';

class GoogleController extends GetxController {
  PhoneController controller = Get.put(PhoneController());

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCrediential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    var user = userCrediential.user!;
    if (await userAlreadyExists(user.uid)) {
    } else {
      var phoneNo = user.phoneNumber;
      final String name = user.displayName ?? "";
      String image = user.photoURL ?? "";

      var _user = usermodel.User(
        userType: "",
        phoneNumber: phoneNo ?? "",
        imageUrl: image,
        name: '',
        email: '',
        profileDescription: '',
        dob:  0,
        lat: 0.0,
        lng: 0.0,
        uid: uid,
        gender: "",
        notification: false,
        notificationToken: '',
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        isVerified: false,
        isBlocked: false, status: '', address: '', /*currentBalance: 0.0*/
      );
      ;
      await usersRef.doc(user.uid).set(_user.toMap()).then((value) {
        Get.offAll(ScreenWelcome());
      });
    }
  }

  Future<bool> userAlreadyExists(String uid) async {
    var documentSnapshot = await usersRef.doc(uid).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?; // Explicit casting
      if (data != null) {
        var userStatus = data['userType'];
        if (userStatus == "host") {
          Get.offAll(ScreenHostHomePage());
        } else {
          Get.offAll(ScreenUserHome());
        }
        // Now you can use userStatus as Map<String, dynamic>
        return true; // User exists
      }
    }
    return false; // User doesn't exist
  }
}
