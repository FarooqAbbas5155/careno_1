import 'package:careno/constant/colors.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/models/policy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScreenPrivacyPolicy extends StatelessWidget {
  const ScreenPrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(

          title: Text("Privacy Policy"),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: policyCollection.snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator.adaptive(backgroundColor: AppColors.appPrimaryColor,),);
            }
            var policys = snapshot.data!.docs.map((e) => Policy.fromMap(e.data() as Map<String,dynamic>)).toList();
            return policys.isNotEmpty?ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: policys.length,
            itemBuilder: (BuildContext context, int index) {
                var policy = policys[index];
            return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //   child: Text("Last Update on 24 March, 2024",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 15.sp,
                  //           color: Color(0xFF767676)
                  //       )
                  //   ),
                  // ),

                  Text(policy.title,style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800
                    ),
                  ).marginSymmetric(horizontal: 18.w,vertical: 10.h),
                  Text(policy.description,style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400
                    ),
                  ).marginSymmetric(horizontal: 18.w),
                ],);
            },
            ):Center(child: Text("Nothing Found Yet",style: TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.w600,),),);
          }
        ),
      ),
    );
  }
}
