import 'package:careno/User/views/layouts/item_layout_explore_popular.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScreenUserFavoriteVehicles extends StatelessWidget {
  const ScreenUserFavoriteVehicles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Favorite Vehicles"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.doc(uid).collection("isLiked").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.appPrimaryColor,),
            );
          }
          var vehicles = snapshot.data!.docs.map((e) => AddHostVehicle.fromMap(e.data() as Map<String,dynamic>)).toList();

          return vehicles.isNotEmpty? ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 26.w,vertical: 10.h),
            itemCount: vehicles.length,
            itemBuilder: (BuildContext context, int index) {
              var vehicel =  vehicles[index];
            return ItemLayoutExplorePopular(addHostVehicle: vehicel,);
          },):Center(child: Text("No Found yet",style: TextStyle(fontWeight: FontWeight.w700,fontFamily: "Nunito"),),);
        }
      ),
    ));
  }
}
