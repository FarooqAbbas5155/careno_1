import 'package:careno/User/views/screens/screen_car_details.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/interfaces/like_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../../models/add_host_vehicle.dart';

class ItemLayoutExplorePopular extends StatefulWidget {
  AddHostVehicle? addHostVehicle;

  @override
  State<ItemLayoutExplorePopular> createState() => _ItemLayoutExplorePopularState();

ItemLayoutExplorePopular({
    this.addHostVehicle,
  });
}

class _ItemLayoutExplorePopularState extends State<ItemLayoutExplorePopular> implements LikeListener{

  RxList<String> likedUsers = <String>[].obs;
  RxBool alreadyLiked = false.obs;
  @override
  void initState() {
    checkForLikes(widget.addHostVehicle!.vehicleId, this);
    super.initState();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(ScreenCarDetails(addHostVehicle: widget.addHostVehicle!));
      },
      child: Container(
        // height: 81.h,
        width: 345.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w,vertical:6.h),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 3, // Blur radius
              offset: Offset(0, 3), // Offset of the shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
             Row(
               children: [
                 Container(
                   height: 72.h,
                   width: 56.w,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(5.r),
                       image: DecorationImage(
                           image: NetworkImage(widget.addHostVehicle!.vehicleImageComplete),
                           fit: BoxFit.fill
                       )
                   ),
                 ),
                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(widget.addHostVehicle!.vehicleModel,style: TextStyle(color: Colors.black,fontSize: 14.sp,fontFamily:"Urbanist" ,fontWeight: FontWeight.w700),),
                     Text(widget.addHostVehicle!.vehicleTransmission,style: TextStyle(color: Color(0xffAAAAAA),fontSize: 10.sp,fontFamily:"Urbanist" ,fontWeight: FontWeight.w500),).marginOnly(bottom: 2.h),
                     Row(
                       children: [
                         Icon(Icons.star,color: AppColors.starColor,),
                         Text(widget.addHostVehicle!.rating.toString(),style: TextStyle(color: Colors.black,fontSize: 11.sp,fontFamily:"UrbanistBold" ,fontWeight: FontWeight.w600),),

                         Text(

                           "(${Get.find<HomeController>().getReviewCount(Get.find<HomeController>().ratedVehicleList.value, widget.addHostVehicle!.vehicleId).toString()})",style: TextStyle(color: Color(0xffAAAAAA),fontSize: 11.sp,fontFamily:"Urbanist" ,fontWeight: FontWeight.w600),)
                         // FutureBuilder(
                         //     future: addVehicleRef.doc(widget.addHostVehicle!.vehicleId).collection("views").get(),
                         //     builder: (context, snapshot) {
                         //       if (snapshot.connectionState == ConnectionState.waiting) {
                         //         return Center(child: Text("...",style: TextStyle(color: AppColors.appPrimaryColor)));
                         //       }
                         //       var views = snapshot.data!.docs.map((e) => addVehicleRef.doc(widget.addHostVehicle!.vehicleId).collection("views")).toList();
                         //     return Text(
                         //
                         //       "${views == null?"(0)":"(${views.length})"}",style: TextStyle(color: Color(0xffAAAAAA),fontSize: 11.sp,fontFamily:"Urbanist" ,fontWeight: FontWeight.w600),).marginOnly(left: 4.w);
                         //   }
                         // ),
                       ],
                     ),
                   ],
                 ).marginOnly(left: 8.w),
               ],
             ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    alreadyLiked.value != alreadyLiked.value;
                    if (!alreadyLiked.value) {
                      await addVehicleRef
                          .doc(widget.addHostVehicle!.vehicleId)
                          .collection("likes")
                          .doc(getUid())
                          .set({"uid": getUid()});
                      await usersRef
                          .doc(getUid())
                          .collection("isLiked")
                          .doc(widget.addHostVehicle!.vehicleId)
                          .set(
                          widget.addHostVehicle!.toMap());
                    } else {
                      await addVehicleRef
                          .doc(widget.addHostVehicle!.vehicleId)
                          .collection("likes")
                          .doc(getUid())
                          .delete();
                      await usersRef
                          .doc(getUid())
                          .collection("isLiked")
                          .doc(widget.addHostVehicle!.vehicleId)
                          .delete();
                    }
                  },
                  child: Container(
                    height: 36.h,
                    width: 40.w,
                    margin: EdgeInsets.only(left: 12.w),
                    decoration: BoxDecoration(
                      color: Color(0xffAAAAAA).withOpacity(.2),
                      shape: BoxShape.circle
                    ),
                    child: Icon(Icons.favorite,color: alreadyLiked.value ? AppColors.appPrimaryColor : Color(0xff949494),),
                  ).marginOnly(left: 18.w),
                ),
                RichText(
                  text: TextSpan(
                    text: '${widget.addHostVehicle!.currency}${widget.addHostVehicle!.vehiclePerDayRent}',
                    style: TextStyle(color: primaryColor,fontFamily: "Urbanist",fontWeight: FontWeight.w700,fontSize: 14.sp),
                    children: <TextSpan>[
                      TextSpan(
                        text: '/per day',
                        style: TextStyle(color: primaryColor,fontFamily: "Urbanist",fontWeight: FontWeight.w500,fontSize: 12.sp),

                      ),
                    ],
                  ),
                ).marginOnly(bottom: 2.h)

              ],
            )

          ],
        ),
      ),
    );
  }

  @override
  void onLikesUpdated(List<String> likedUsers) {
    setState(() {
      if (mounted) {

        this.likedUsers.value = likedUsers;
        this.alreadyLiked.value = likedUsers.contains(getUid());
      }
    });

  }
}
