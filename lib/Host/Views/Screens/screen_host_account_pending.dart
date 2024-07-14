import 'dart:async';

import 'package:careno/Host/Views/Screens/screen_host_add_vehicle.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/controllers/controller_host_add_identity_proof.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/firebase_utils.dart';
import '../../../constant/helpers.dart';
import '../../../models/user.dart';

class ScreenHostAccountPending extends StatefulWidget {
  @override
  State<ScreenHostAccountPending> createState() => _ScreenHostAccountPendingState();
}

class _ScreenHostAccountPendingState extends State<ScreenHostAccountPending> {
  ControllerHostAddIdentityProof controller = Get.put(ControllerHostAddIdentityProof());
  late StreamSubscription userStream;

  @override
  void initState() {
    userStream = usersRef.doc(FirebaseUtils.myId).snapshots().listen((event) {

      if (event.exists){
        var data = event.data();
        var user = User.fromMap(data as Map<String, dynamic>);
        if (user.isVerified){
          Get.offAll(ScreenHostAddVehicle());
        }
      }

    });
    super.initState();
  }

  @override
  void dispose() {
    userStream.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Account Pending Verification'),
          centerTitle: true,
        ),
        body: Center(
          child: StreamBuilder<DocumentSnapshot>(
              stream: usersRef.doc(FirebaseUtils.myId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState==ConnectionState.waiting) {
                  return CircularProgressIndicator.adaptive(
                    backgroundColor: AppColors.appPrimaryColor,
                    strokeWidth: 1.5,
                  );
                }
                var user=User.fromMap(snapshot.data!.data() as Map<String,dynamic>);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomSvg(name: "pending",),
                    Text("Thank you for your trust. Your request has been sent. We will try to approve you as soon as possible. you get notification for approval status.",style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(.8),

                    ),
                      textAlign: TextAlign.center,
                    ).marginOnly(top: 30.h)
                  ],
                ).marginSymmetric(horizontal: 28.w
                );
              }
          ),
        ),
      ),
    );
  }
}
