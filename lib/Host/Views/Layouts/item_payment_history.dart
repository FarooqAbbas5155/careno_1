import 'package:careno/constant/colors.dart';
import 'package:careno/models/payment_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/helpers.dart';

class ItemPaymentHistory extends StatelessWidget {
PaymentHistoryModel paymentHistory;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            Text(paymentHistory.vehicleName!.isNotEmpty ? "${paymentHistory.senderName} || ${paymentHistory.vehicleName}":"${paymentHistory.senderName}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14.sp),),
            SizedBox(height: 5.h,),
            Row(
              children: [
                Text(DateFormat("yyyy-MM-dd . h:mm a").format(DateTime.parse(paymentHistory.paymentDate!)),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.sp,color: Color(0xFF969696)),),
                SizedBox(width: 20,),
                paymentHistory.senderName == 'Withdraw'? Row(
                  children: [
                    Text('Status:',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12.sp,color: Color(0xFF969696)),),
                    SizedBox(width: 6,),
                    Text('${paymentHistory.paymentMethod}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12.sp,color: Colors.red)),
                  ],
                ):SizedBox()
              ],
            ),

          ],)),
            Text("${paymentHistory.currency}${paymentHistory.paymentAmount}",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w700,color: AppColors.appPrimaryColor),)
           ],
        ).marginOnly(bottom: 6.h),
        Divider(color: Color(0xFFBBBBBB).withOpacity(.5),thickness: .5
          ,)
      ],
    ).marginSymmetric(horizontal: 13.w,vertical: 4.h);
  }

ItemPaymentHistory({
    required this.paymentHistory,
  });
}
