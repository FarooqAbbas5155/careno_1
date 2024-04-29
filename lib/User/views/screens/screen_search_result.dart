import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../layouts/item_layout_explore_popular.dart';

class ScreenSearchResult extends StatefulWidget {
  @override
  State<ScreenSearchResult> createState() => _ScreenSearchResultState();
}

class _ScreenSearchResultState extends State<ScreenSearchResult> {
  final TextEditingController _searchController = TextEditingController();

  RxString search = "".obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Search Results",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              fontFamily: "Urbanist",
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Color(0xffAAAAAA).withOpacity(.3),
                  width: 1.0,
                ),
                color: Color(0xffF0F0F0),
              ),
              child:  TextField(
                onChanged: (value) {
                  search.value = value;
                  setState(() {

                  });
                  print("search.value ${search.value}");

                },
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: "Urbanist"),
                  hintText: "Luxury Car",
                  contentPadding: EdgeInsets.only(left: 12, top: 15.h),
                  fillColor: Color(0xffF0F0F0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xffABABAB),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    color: Colors.black,
                    onPressed: () {
                      _searchController.clear(); // Clear text when pressed
                    },
                  ),
                ),
              ),
            ).marginSymmetric(horizontal: 20.w, vertical: 10.h),
            StreamBuilder<QuerySnapshot>(
              stream: addVehicleRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appPrimaryColor,
                      strokeWidth: 2,
                    ),
                  );
                }

                // Get list of AddHostVehicle objects from snapshot
                var vehicleList = snapshot.data!.docs.map((e) =>
                    AddHostVehicle.fromMap(e.data() as Map<String, dynamic>))
                    .toList();

                // Apply search filter if search value is not empty
                if (search.value.isNotEmpty) {
                  vehicleList = vehicleList.where((vehicle) =>
                      vehicle.vehicleColor.toLowerCase().startsWith(
                          search.value.toLowerCase())).toList();
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${vehicleList.length} results found",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Urbanist",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ).marginSymmetric(horizontal: 14.w),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: vehicleList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var vehicle = vehicleList[index];
                        return ItemLayoutExplorePopular(
                            addHostVehicle: vehicle);
                      },
                    ).marginSymmetric(horizontal: 14.w),
                  ],
                );
              },
            )

          ],
        ),
      ),
    );
  }
}