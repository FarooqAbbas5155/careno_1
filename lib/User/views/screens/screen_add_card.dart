
import 'package:careno/User/views/screens/screen_user_home.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScreenAddCard extends StatefulWidget {
  const ScreenAddCard({Key? key}) : super(key: key);

  @override
  State<ScreenAddCard> createState() => _ScreenAddCardState();
}

class _ScreenAddCardState extends State<ScreenAddCard> {
  String countryCode = "IN";
  String countryName = "IN";

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
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
          "Add Card",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            fontFamily: "UrbanistBold",
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 2.w,right: 2.w,top: 12.h,bottom: 6.h),
              child: Text("Card Number",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w700,fontFamily: "UrbanistBold",),),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              height: 55.h,
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.withOpacity(.3)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/card2.png",width: 40,height: 40,).paddingSymmetric(horizontal: 6.w),
                      SizedBox(
                        width: 230.w,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:  EdgeInsets.only(right: 8.0),
                    child: Image.asset("assets/images/card_prefix.png",width: 30,height: 25),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("EXP.Date",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w700,fontFamily: "UrbanistBold",),),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 4.h),
                      height: 55.h,
                      width: 160.w,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.withOpacity(.3)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 110.w,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "MM/YY"
                              ),
                            ),
                          ),
                          Image.asset("assets/images/Q.png",width: 20,height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
        
                  children: [
                    Text("CVV",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w700,fontFamily: "UrbanistBold",),),
        
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 4.h),
                      height: 55.h,
                      width: 160.w,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.withOpacity(.3)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 110.w,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "123"
                              ),
                            ),
                          ),
                          Image.asset("assets/images/Q.png",width: 20,height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
        
        
              ],
            ),
            Padding(
              padding:  EdgeInsets.only(left: 2.w,right: 2.w,top: 20.h,bottom: 6.h),
              child: Text("Country",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w700,fontFamily: "UrbanistBold",),),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              height: 55.h,
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.withOpacity(.3)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height:40.h,
                        width: 40.w,
                        child:CircleFlag(countryCode),
        
                      ),
                      SizedBox(width: 6.w,),
                      Text(countryName),
                    ],
                  ),
                 Column(
                   children: [
                     SizedBox(
                       height: 18.h,
                       width: 40.w,
                       child:  CountryCodePicker(
                         // initialSelection: "IN",
                         onChanged: (value) {
                           countryCode = value.code ?? "";
                           countryName = value.name ?? "";
                           setState(() {});
                         },
                       ),
                     ),
                     Icon(Icons.expand_more,color: Colors.black,),

                   ],
                 )
                ],
              ),
        
            ),
        
            Padding(
              padding:  EdgeInsets.only(left: 2.w,right: 2.w,top: 20.h,bottom: 6.h),
              child: Text("Zip Code",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w700,fontFamily: "UrbanistBold",),),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              height: 55.h,
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.withOpacity(.3)
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "e.g 3200"
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 50.h),
              child: CustomButton(
                title: "Pay Now",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/successful_purchase.png",
                              width: 140,
                              height: 140,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "Congratulations!",
                              style: TextStyle(
                                fontSize: 20,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Your request has been sent to the driver. You will be notified once it is accepted.",
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 14.h),
                              child: CustomButton(title: "Back Home", onPressed: (){
                                Get.to(ScreenUserHome());
                              }),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )

          ],
        
        ).marginSymmetric(horizontal: 12.w),
      ),
    ));
  }

}