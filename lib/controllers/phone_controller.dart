import 'package:careno/AuthSection/screen_otp.dart';
import 'package:careno/models/user.dart' as userModle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../AuthSection/screen_welcome.dart';
import '../constant/helpers.dart';

class PhoneController extends GetxController {
  var pinPutController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  RxBool loading = false.obs;
  var isButtonEnabled = true.obs;
  final _auth = FirebaseAuth.instance;
  String _verificationId = "";
  int _resendToken = 0;
  final showLoading = false.obs;
  String country_code = "+1";

  void verifyPin(String pin) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: pin);
    try {
      await _auth.signInWithCredential(phoneAuthCredential).then((value) {
        return verificationCompleted(value);
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      showSnackBar(e.message.toString());
    }
  }

  Future<void> verificationCompleted(UserCredential credential) async {
    showLoading.value = true;
    update();
    bool alreadyExists = await userAlreadyExists(credential.user!.uid);
    if (alreadyExists) {
      var screen = await getHomeScreen();
      Get.offAll(screen);
      showLoading.value = false;
    } else {
      await completeRegistration(credential);
      showLoading.value = false;
    }
  }

  Future<void> sendVerificationCode() async {
    String phone = phoneController.value.text;
    if (country_code.isEmpty || phone.isEmpty) {
      Get.snackbar("Alert", "Phone is required!",
          backgroundColor: primaryColor);
      return;
    }

    String full_phone = country_code + phoneController.value.text;
    Get.to(ScreenOtp());
    print(full_phone);

    await _auth.verifyPhoneNumber(
      phoneNumber: (full_phone),
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        _auth.signInWithCredential(credential).then((value) {
          pinPutController.value.text = credential.smsCode ?? "";

          verificationCompleted(value);
        }).catchError((error) {
          showSnackBar(error.toString());
          print(error.toString());
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBar(e.message.toString());
        print(e);
        Get.back();
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken ?? 0;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void showSnackBar(String message) {
    Get.snackbar("Alert", message);
  }

  Future<String> completeRegistration(UserCredential userCredential) async {
    String response = "";
    var user = userModle.User(
      userType: "",
      phoneNumber: country_code + phoneController.value.text,
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
    await await setDatabase(user);
    //
    showLoading.value = false;
    update();

    return response;
  }

  Future<String> setDatabase(userModle.User user) async {
    String response = "";
    await usersRef.doc(user.uid).set(user.toMap()).then((value) {
      response = "success";
      Get.offAll(ScreenWelcome());
    }).catchError((error) {
      Get.snackbar("Error", error.toString());
      response = error;
    });

    return response;
  }

  Future<bool> userAlreadyExists(String uid) async {
    final doc = await usersRef.doc(uid).get();
    return doc.exists;
  }

  Future<bool> checkIfUidExists(String uid) async {
    var doc = await usersRef.doc(uid).get();
    return doc.exists;
  }

  Future<bool> checkIfAuthIdExists(String authId) async {
    var snap = await usersRef.where("authId", isEqualTo: authId).get();
    print(snap);
    return snap.docs.isNotEmpty;
  }

// Future signOut() async {
//   await FirebaseAuth.instance.signOut();
//   _googleSignIn.signOut();
//   _googleSignIn.disconnect();
//   Get.offAll(ScreenLogin());
// }
}
