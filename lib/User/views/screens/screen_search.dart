import 'package:careno/User/views/layouts/item_search.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ScreenSearch extends StatelessWidget {
  const ScreenSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
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
          "Search",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            fontFamily: "Urbanist",
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
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
              child: TextField(
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
                    icon: SvgPicture.asset("assets/images/Group.svg"),
                    onPressed: () {
                    },
                  ),
                ),
              ),
            ).marginSymmetric(vertical: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search History", style: TextStyle(color: Colors.black,
                    fontFamily: "Urbanist",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600)),
                GestureDetector(
                  onTap: (){
                    Get.defaultDialog(
                      title: "",
                      content: Align(
                        alignment: Alignment.centerLeft,
                          child: Text("Clear History",style: TextStyle(fontFamily: "Urbanist",fontSize: 20.sp,fontWeight: FontWeight.w600,color: Colors.red),)),
                      actions: [
                        Text("Are you sure you want to clear your browsing history?",style: TextStyle(fontFamily: "Urbanist",fontWeight: FontWeight.w500,fontSize: 16.sp),),
                        Align(
                        alignment: Alignment.bottomRight,
                          child: Row(
                            children: [
                              CustomButton(
                                color:Color(0xff949494),
                                width: 100.w,
                                  title: "Cancel", onPressed: (){
                                  Get.back();
                              }).marginSymmetric(horizontal: 15.w,vertical: 6.h),
                              CustomButton(
                                color:Colors.red,
                                width: 100.w,
                                  title: "Yes", onPressed: (){}),
                            ],
                          ).marginOnly(left: 40.w),
                        )
                      ]
                    );
                  },
                  child: Text("Clear History", style: TextStyle(color: Colors.red,
                      fontFamily: "Urbanist",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
              return ItemSearch();
            },)
          ],
        ).marginSymmetric(horizontal: 14.w),
      ),
    ) );
  }
}
