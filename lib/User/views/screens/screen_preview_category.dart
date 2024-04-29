
import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:careno/models/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../layouts/item_layout_explore_popular.dart';

class ScreenPreviewCategory extends StatelessWidget {
Category category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          }, icon: Icon(Icons.arrow_back,color: Colors.black),),
        title: Text("Luxary Cars ",style: TextStyle(color: Colors.black,fontSize:24.sp ,fontWeight:FontWeight.w700 ,fontFamily: "UrbanistBold"),),
        centerTitle: true,
        actions: [
          Icon(Icons.search,color: Colors.black,).marginOnly(right: 20.w)
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: addVehicleRef.where("vehicleCategory",isEqualTo: category.id).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.appPrimaryColor,),
            );

          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available related this category'));
          }
var documents = snapshot.data!.docs.map((e)=> AddHostVehicle.fromMap(e.data() as Map<String,dynamic>)).toList();
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              var addvehicle = documents[index];
              return ItemLayoutExplorePopular(addHostVehicle: addvehicle,).marginSymmetric(horizontal: 10.w);
            },);
        },

      ),
    );
  }

ScreenPreviewCategory({
    required this.category,
  });
}
