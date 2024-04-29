import 'package:card_swiper/card_swiper.dart';
import 'package:careno/User/views/screens/full_image_view.dart';
import 'package:careno/User/views/screens/screen_all_reviews.dart';
import 'package:careno/User/views/screens/screen_booking.dart';
import 'package:careno/User/views/screens/screen_user_chat.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/controllers/vehicle_controller.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:careno/models/rating.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../layouts/item_screen_car_details.dart';

class ScreenCarDetails extends StatelessWidget {
  AddHostVehicle? addHostVehicle;
  VehicleController vehicleController = Get.put(VehicleController());

  // List<String> imagesList=[
  //   "assets/images/image.png",
  //   "assets/images/image1.png",
  //   "assets/images/image2.png",
  //   "assets/images/image3.png",
  //   "assets/images/image4.png",
  // ];

  @override
  Widget build(BuildContext context) {
    vehicleController.checkCondition(addHostVehicle!);
    List<String> imageUrl = [
      addHostVehicle!.vehicleImageComplete,
      addHostVehicle!.vehicleImageInterior,
      addHostVehicle!.vehicleImageRear,
      addHostVehicle!.vehicleImageNumberPlate,
      addHostVehicle!.vehicleImageRightSide,
      ...addHostVehicle!.imagesUrl
    ];
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder(
        future: getUser(addHostVehicle!.hostId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.appPrimaryColor,
            ));
          }
          var user = snapshot.data!;

          return FutureBuilder(
            future: getCategory(addHostVehicle!.vehicleCategory),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: AppColors.appPrimaryColor,
                ));
              }
              var category = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ConstrainedBox(
                            child: Swiper(
                              outer: false,
                              itemBuilder: (c, i) {
                                return GestureDetector(
                                  onTap: (){
                                    Get.to(FullImageView(imageUrl: imageUrl[i],));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(imageUrl[i]),
                                            fit: BoxFit.cover)),
                                    child: Container(
                                      height: 145.h,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(.0),
                                          Colors.black
                                        ],
                                        begin: Alignment.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                      )),
                                    ),
                                  ),
                                );
                              },
                              pagination: SwiperPagination(
                                  margin: EdgeInsets.symmetric(vertical: 15.h)),
                              itemCount: imageUrl.length,
                            ),
                            constraints:
                                BoxConstraints.loose(Size(Get.width, 231.0.h))),
                        Positioned(
                          left: 20.w,
                          top: 20.h,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 29.h,
                              width: 29.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Icon(
                                Icons.navigate_before_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10.h,
                          left: 20.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 35.w),
                                padding: EdgeInsets.all(2.r),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2, color: Colors.white)),
                                child: CircleAvatar(
                                  radius: 35.r,
                                  backgroundImage: NetworkImage(user.imageUrl),
                                ),
                              ),
                              Text(
                                user.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Urbanist",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.sp),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Color(0xffFBC017),
                                  ),
                                  Text(
                                    addHostVehicle!.rating.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontFamily: "UrbanistBold",
                                        fontWeight: FontWeight.w600),
                                  ),
                                  FutureBuilder(
                                      future: addVehicleRef
                                          .doc(addHostVehicle!.vehicleId)
                                          .collection("views")
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: Text("...",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .appPrimaryColor)));
                                        }
                                        var views = snapshot.data!.docs
                                            .map((e) => addVehicleRef
                                                .doc(addHostVehicle!.vehicleId)
                                                .collection("views"))
                                            .toList();
                                        return Text(
                                          "${views == null ? "(0)" : "(${views.length})"}",
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(.8),
                                              fontSize: 13.sp,
                                              fontFamily: "Urbanist",
                                              fontWeight: FontWeight.w600),
                                        );
                                      }).marginOnly(left: 4.w),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 20.w,
                          bottom: 20.h,
                          child: RichText(
                            text: TextSpan(
                              text: '${currencyUnit}${addHostVehicle!.vehiclePerDayRent}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "UrbanistBold",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22.sp),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '/per day',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Urbanist",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp),
                                ),
                              ],
                            ),
                          ).marginOnly(bottom: 5.h),
                        ),
                      ],
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            // Shadow color
                            spreadRadius: 1,
                            // Spread radius
                            blurRadius: 3,
                            // Blur radius
                            offset: Offset(0, 3), // Offset of the shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            addHostVehicle!.vehicleModel,
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: "UrbanistBold"),
                          ).marginOnly(bottom: 4.h, top: 4.h),
                          Row(
                            children: [
                              Text(
                                "Location: ",
                                style: TextStyle(
                                    color: Color(0xff616161),
                                    fontFamily: "Urbanist",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.sp),
                              ),
                              Expanded(
                                  child: Text(
                                addHostVehicle!.address,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: "Urbanist",
                                    fontSize: 13.sp,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600),
                              ))
                            ],
                          ).marginOnly(bottom: 8.h),
                          TextWidget("Year", addHostVehicle!.vehicleYear,
                              "Type", category.name),
                          TextWidget("Color", addHostVehicle!.vehicleColor,
                              "Seats", addHostVehicle!.vehicleSeats),
                          TextWidget("Transmission", "Automatic", "Fuel Type",
                              addHostVehicle!.vehicleFuelType),
                          Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Urbanist"),
                          ).marginOnly(bottom: 4.h, top: 4.h),
                          Text(
                            addHostVehicle!.vehicleDescription,
                            style: TextStyle(
                                color: Color(0xff616161).withOpacity(.8),
                                fontFamily: "Urbanist",
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                  width: 150.w,
                                  title: "Book Now",
                                  onPressed: () {
                                    Get.to(ScreenBooking(
                                      addHostVehicle: addHostVehicle!,
                                    ));
                                  }),
                              CustomButton(
                                  width: 150.w,
                                  title: "Message",
                                  onPressed: () {
                                    Get.to(ScreenUserChat(
                                      user: user!,
                                    ));
                                  }).marginSymmetric(vertical: 5.h),
                            ],
                          ).marginSymmetric(vertical: 4.h),
                        ],
                      ).marginSymmetric(horizontal: 10.w),
                    ).marginOnly(
                        left: 10.w, right: 10.w, top: 8.h, bottom: 12.h),
                    StreamBuilder<QuerySnapshot>(
                        stream: reviewRef.where("vehicleId", isEqualTo: addHostVehicle!.vehicleId).snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox();
                          }

                          List<Rating> ratings = snapshot.data!.docs
                              .map((doc) => Rating.fromMap(
                                  doc.data() as Map<String, dynamic>))
                              .toList();
                          return ratings.isNotEmpty
                              ? Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        // Shadow color
                                        spreadRadius: 1,
                                        // Spread radius
                                        blurRadius: 3,
                                        // Blur radius
                                        offset: Offset(
                                            0, 3), // Offset of the shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "(${Get.find<HomeController>().getReviewCount(Get.find<HomeController>().ratedVehicleList.value, addHostVehicle!.vehicleId).toString()}) Reviews",
                                            style: TextStyle(
                                                fontFamily: "UrbanistBold",
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(ScreenAllReviews(ratingList: ratings, addHostVehicle: addHostVehicle!,));
                                            },
                                            child: Text(
                                              "See all ",
                                              style: TextStyle(
                                                  fontFamily: "Urbanist",
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: primaryColor),
                                            ).marginSymmetric(horizontal: 2.w),
                                          ),
                                        ],
                                      ),
                                      ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: ratings.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ItemVehicleReview(rating:ratings[index]);
                                        },
                                      )
                                    ],
                                  ).marginSymmetric(horizontal: 10.w),
                                ).marginSymmetric(horizontal: 10.w)
                              : SizedBox(
                                  height: Get.height * .3,
                                  child: Center(
                                    child: Text(
                                      "No reviews yet",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.sp,
                                          fontFamily: "UrbanistBold",
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                );
                        })
                  ],
                ),
              );
            },
          );
        },
      ),
    ));
  }

  ScreenCarDetails({
    this.addHostVehicle,
  });
}

Widget TextWidget(
    String title, description, String title2, String description2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        flex: 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${title}: ",
              style: TextStyle(
                  color: Color(0xff828282),
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp),
            ),
            Text(
              "${description}",
              style: TextStyle(
                  color: Color(0xff616161).withOpacity(.8),
                  fontFamily: "Urbanist",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${title2}: ",
              style: TextStyle(
                  color: Color(0xff828282),
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp),
            ),
            Text(
              "${description2}",
              style: TextStyle(
                  color: Color(0xff616161).withOpacity(.8),
                  fontFamily: "Urbanist",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      )
    ],
  ).marginOnly(bottom: 6.h);
}
