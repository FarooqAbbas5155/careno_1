import 'package:careno/constant/firebase_utils.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/helpers.dart';
import 'item_host_vehicle.dart';

class LayoutHostPendingVehicle extends StatelessWidget {
  const LayoutHostPendingVehicle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: addVehicleRef
          .where("status", isEqualTo: "Pending")
          .where("hostId", isEqualTo: FirebaseUtils.myId)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(),
            ],
          );
        }
        var vehicleList = snapshot.data!.docs
            .map(
                (e) => AddHostVehicle.fromMap(e.data() as Map<String, dynamic>))
            .toList();

        return vehicleList.isEmpty
            ? Center(
                child: Text(
                "No Pending Vehicle ",
                style: TextStyle(color: Colors.black),
              ))
            : ListView.builder(
                padding: EdgeInsets.only(top: 15.h),
                itemCount: vehicleList.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: getCategory(vehicleList[index].vehicleCategory),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: SizedBox());
                      }
                      var category = snapshot.data!;
                      return ItemHostVehicle(
                        addHostVehicle: vehicleList[index],
                        categoryName: category.name,
                      );
                    },
                  );
                });
      },
    );
  }
}
