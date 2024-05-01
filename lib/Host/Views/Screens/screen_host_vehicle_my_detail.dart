import 'package:card_swiper/card_swiper.dart';
import 'package:careno/Host/Views/Screens/screen_host_edit_vehicle.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_svg.dart';

class ScreenHostVehicleMyDetail extends StatelessWidget {
 AddHostVehicle addHostVehicle;
 String categoryName;


  @override
  Widget build(BuildContext context) {
    List<String> imagesList=[
      addHostVehicle.vehicleImageComplete,
      addHostVehicle.vehicleImageInterior,
      addHostVehicle.vehicleImageRear,
      addHostVehicle.vehicleImageRightSide,
      addHostVehicle.vehicleImageNumberPlate,
      ...addHostVehicle.imagesUrl
    ];

    print("addHostVehicle.imagesUrl ${addHostVehicle.imagesUrl.length}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Vehicle Details"),
          actions: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  height: 8.h,
                  width: 8.h,
                  decoration: BoxDecoration(
                      color: addHostVehicle.status == "Pending"
                          ? Color(0xFFFB9701)
                          : addHostVehicle.status == "In progress"
                              ? Color(0xFF3C79E6)
                              : addHostVehicle.status == "Completed"
                                  ? Color(0xFF0F9D58)
                                  : Color(0xFFFF2021),
                      shape: BoxShape.circle),
                ),
                Text(
                  addHostVehicle.status,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: addHostVehicle.status == "Pending"
                          ? Color(0xFFFB9701)
                          : addHostVehicle.status == "In progress"
                              ? Color(0xFF3C79E6)
                              : addHostVehicle.status == "Completed"
                                  ? Color(0xFF0F9D58)
                                  : addHostVehicle.status  == "Reject"?Colors.red:Color(0xFFFF2021),
                      fontSize: 12.sp),
                ).marginOnly(bottom: 4.h, top: 4.h),
              ],
            ).marginSymmetric(horizontal: 15.w)
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ConstrainedBox(
                  child: Swiper(
                    outer: false,
                    itemBuilder: (c, i) {
                      return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      imagesList[i]),
                                  fit: BoxFit.cover)),
                        child: Container(
                          height: 145.h,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.black.withOpacity(.0),
                                Colors.black
                              ]
                                ,
                                begin: Alignment.topCenter,
                                end: FractionalOffset.bottomCenter,
                              )
                          ),),

                      );
                    },
                    pagination: SwiperPagination(
                        margin: EdgeInsets.symmetric(vertical: 15.h)),
                    itemCount: imagesList.length,
                  ),
                  constraints:
                  BoxConstraints.loose(Size(Get.width, 231.0.h))),

              buildDetail("Make & Model of Vehicle", addHostVehicle.vehicleModel),
              buildDetail("Category/Type", categoryName!),
              buildDetail("Year of Vehicle", addHostVehicle.vehicleYear),
              buildDetail("Number of Seats", addHostVehicle.vehicleSeats),
              buildDetail("Transmission", addHostVehicle.vehicleTransmission),
              buildDetail("Fuel Type", addHostVehicle.vehicleFuelType),
              buildDetail("Vehicle Plate Number", addHostVehicle.vehicleNumberPlate),
              buildDetail("Vehicle License Expiry Date", addHostVehicle.vehicleLicenseExpiryDate),
              buildDetail("Per Day Rent", "${currencyUnit}${addHostVehicle.vehiclePerDayRent}"),
              buildDetail("Per Hours Rent", "${currencyUnit}${addHostVehicle.vehiclePerHourRent}"),
              Text(
                "Vehicle Registration",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ).marginSymmetric(horizontal: 14.w),
              Container(
                height: 162.h,
                margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 46.w),
                width: Get.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF979797)),
                    borderRadius: BorderRadius.circular(6.r),
                    image: DecorationImage(
                        image: NetworkImage(addHostVehicle.vehicleRegistrationImage),
                        fit: BoxFit.cover)),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: CustomButton(title: "Edit Vehicle",
                  textStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  ),onPressed: (){
                        Get.to(ScreenHostEditVehicle(addHostVehicle: addHostVehicle,));
                          })),
                  SizedBox(width: 10.w
                    ,),
                  Expanded(
                      child: CustomButton(title: "Delete Vehicle",

                  textStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  ),onPressed: ()async{
                          Get.defaultDialog(
                              title: '',
                              content: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                      padding: EdgeInsets.all(12.sp),
                                      margin: EdgeInsets.symmetric(horizontal:12.sp),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF0F0F0),
                                          shape: BoxShape.circle
                                      ),
                                      child: Icon(Icons.clear,color: Colors.black,)),
                                ),
                              ),
                              actions: [
                                Column(
                                  children: [
                                    Container(
                                      height: 55.h,
                                      width: 55.w,
                                      padding: EdgeInsets.all(12.sp),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF0F0F0),
                                          borderRadius: BorderRadius.circular(20.r)),
                                      child: Icon(Icons.delete_forever,color: Colors.red,)
                                    ),
                                    SizedBox(
                                      height: 10.sp,
                                    ),
                                    Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.w700,fontFamily: "UrbanistBold",),
                                    ),
                                    SizedBox(
                                      height: 13.sp,
                                    ),
                                    SizedBox(
                                      height: 36.h,
                                      width: 230.w,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        "Are you sure you want to Delete Vehicel?",
                                        style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w600,fontFamily: "UrbanistBold",),
                                      ),
                                    ),
                                    CustomButton(
                                        color: Color(0xffeb141b),
                                        width: 193.w,
                                        title: "Yes, Delete",
                                        onPressed: () async{
                                          await deleteDirectory("Host/addVehicle/${addHostVehicle.hostId}/${addHostVehicle.vehicleId}/image").then((value) async {
                                            await addVehicleRef.doc(addHostVehicle.vehicleId).delete();
                                            Get.back();

                                          }
                                          );
                                        }).marginSymmetric(vertical: 20.h)
                                  ],
                                )
                              ]);
                        },
                      color: Color(0xFFFE0000),
                      )),
                ],
              ).marginSymmetric(horizontal: 28.w
              ,vertical: 20.h),
            ],
          ),
        ),
      ),
    );
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

  Widget buildDetail(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: Color(0xFF6A6A6A)),
        ).marginSymmetric(vertical: 2.h),
        Text(
          subtitle,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
              color: Colors.black),
        ).marginSymmetric(vertical: 2.h),
        Divider(
          color: Colors.black.withOpacity(.1),
        )
      ],
    ).marginSymmetric(vertical: 6.h, horizontal: 14.w);
  }

 ScreenHostVehicleMyDetail({
    required this.addHostVehicle,
    required this.categoryName,
  });
}
