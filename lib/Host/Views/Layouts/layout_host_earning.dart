import 'dart:convert';
import 'dart:developer';

import 'package:careno/Host/Views/Layouts/item_payment_history.dart';
import 'package:careno/Host/Views/Screens/withdraw_money_screen.dart';
import 'package:careno/constant/my_helper_by_callofcoding.dart';
import 'package:careno/controllers/controller_host_home.dart';
import 'package:careno/models/payment_history.dart';
import 'package:careno/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mpesa/dart_mpesa.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:mpesa_flutter_plugin/payment_enums.dart';

import '../../../constant/colors.dart';
import '../../../constant/helpers.dart';

class LayoutHostEarning extends StatelessWidget {
  dynamic transactionInitialisation;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        child: StreamBuilder(stream: getWalletStream(), builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
          if(snapshot.hasData && !snapshot.hasError && snapshot.data!.data() != null){

            User userObject = User.fromMap(snapshot.data!.data()!);


            return Stack(
              children: [
                Container(
                  height: 100.h,
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                  decoration: BoxDecoration(color: AppColors.appPrimaryColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Earning Wallet",
                        style: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 80.h,
                    left: 0.w,
                    bottom: 0.h,
                    right: 0.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 13.w),
                          padding: EdgeInsets.all(10.r),
                          // height: 134.h,
                          width: Get.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.15),
                                    blurRadius: 20.r,
                                    offset: Offset(0, -2))
                              ]),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  "Wallet Balance",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                      color: Color(0xFF969696)),
                                ),
                                subtitle: Text(
                                  '${userObject.hostWallet?.currentBalance}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25.sp,
                                      color: AppColors.appPrimaryColor),
                                ),
                                trailing: GestureDetector(
                                  onTap: () async {
                                    Get.to(()=>WithdrawMoneyScreen(userObject: userObject));
                                  },
                                  child: Container(
                                    height: 38.h,
                                    width: 124.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.appPrimaryColor,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      "Withdraw",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "Note: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.sp),
                                      children: [
                                        TextSpan(
                                          text:
                                          "Payment transfer to your local bank account, conne-cted through Active Tutors Stripe Connect Account, may take 2-3 business days.",
                                          style: TextStyle(
                                              color: Color(0xFF969696),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.sp),
                                        )
                                      ]))
                            ],
                          ),
                        ).marginOnly(bottom: 10.h),
                        Divider(
                          color: Color(0xFFBBBBBB).withOpacity(.5),
                          thickness: .5,
                          height: 20.h,
                        ),
                        Text(
                          "Payment History",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.appPrimaryColor),
                        ).marginSymmetric(horizontal: 13.w, vertical: 5.h),
                        TextButton(onPressed: () async {



                          print('----key $key');


                          await sendMoneyFromMpesa();

                          // transactionInitialisation = await MpesaFlutterPlugin
                          //     .initializeMpesaSTKPush(
                          //     businessShortCode: "174379",
                          //     transactionType: TransactionType.CustomerPayBillOnline,
                          //     amount: 10,
                          //     partyA: "254729050401",
                          //     partyB: "174379",
                          //     callBackURL: Uri(
                          //         scheme: "https",
                          //         host: "1234.1234.co.ke",
                          //         path: "/1234.php"),
                          //     accountReference: "Test",
                          //     phoneNumber: "254729050401",
                          //     baseUri: Uri(
                          //         scheme: "https",
                          //         host: "sandbox.safaricom.co.ke"),
                          //     transactionDesc: "Test",
                          //     passKey: /*key*/
                          //     'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919');

                          try {

                          } catch (e) {
                            log(e.toString());
                          }

                          print('payment ------- $transactionInitialisation');
                        }, child: Text("Test")),
                        Expanded(
                          child: userObject.hostWallet!.paymentHistory!.isEmpty
                              ? Center(child: Text("No History Found"))
                              : ListView.builder(
                            shrinkWrap: true,
                            itemCount: userObject.hostWallet!.paymentHistory!.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return ItemPaymentHistory(
                                paymentHistory: userObject.hostWallet!.paymentHistory![index],
                              );
                            },
                          ),
                        )
                      ],
                    ))
              ],
            );
          }
          if(snapshot.hasError){
            return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Something went wrong...',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Poppins",color: Colors.red),),
              Text('${snapshot.error}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Poppins",color: Colors.red))
            ],
            );
          }

          return Container(color: Colors.red,);
        },),
      ),
    ));
  }
}



String password(String shortCode, String passKey) {
  final _codeKeyDt = shortCode + passKey + timestamp;
  final _bytes = utf8.encode(_codeKeyDt);
  return base64.encode(_bytes);
}


String get timestamp {
  final _now = DateTime.now();
  return _now.year.toString() +
      _now.month.toString().padLeft(2, '0') +
      _now.day.toString().padLeft(2, '0') +
      _now.hour.toString().padLeft(2, '0') +
      _now.minute.toString().padLeft(2, '0') +
      _now.second.toString().padLeft(2, '0');
}



Future<void> sendMoneyFromMpesa()async{



  Mpesa mpesa = Mpesa(
      shortCode: "601426",
      consumerKey: "VxSb94SoPku6ugjAAkwqDJoyTSWzXFQmsX8jtmrQsGpnI6rQ",
      consumerSecret: "3iHObDhr69hGXYYKi32aHP5zWztEEGG8rbtdPyEiTsZlShTxoYur0c7DrMg3kChE",
      initiatorName: "apitest361",
      securityCredential: "LLnW6FVFKl5sSkbRt2VT5z2vFyK6D2Wf/60t0SuE6s/TZwvPTftIJ5Tkgx+6FEbbMFf3gzCCm51WvXxszvdvW99winbpILVELw0gLK+s+8q8oH8n0MuD7BG9n9vOV0jCcEmW2hEr/ZgT9dstREh20dd6t8VBftUt+8lpeMtkuVdQVdpclteekIoRtt+C3ez+hsoLrZ4EgMl1kU5Mf721xi9f7058yaVTbObN3Y9NeqBUbSeGUfrEeDXgFjLaaActDA2y7tiC2j4LlrzOpS+V5zDZgfiUq+25DPj5Ct1eDtOPESMqwaYfIVRWivWH2mEeO3jG6W0ZoMll+3l8cEOk3Q==",
      passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
      identifierType: IdentifierType.OrganizationShortCode, // Type of organization, options, OrganizationShortCode, TillNumber, OrganizationShortCode
      applicationMode: ApplicationMode.test
  );



  MpesaResponse _res = await mpesa.b2cTransaction(
      phoneNumber: '254708374149',
      amount: 1000,
      remarks: 'please',
      occassion: 'work',
      queueTimeOutURL: 'https://peternjeru.co.ke/safdaraja/api/callback.php',
      resultURL: 'https://peternjeru.co.ke/safdaraja/api/callback.php'
  );

  print(_res.statusCode);
  print(_res.rawResponse);
  print(_res.responseDescription);


}