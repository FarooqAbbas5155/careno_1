


// this file is create by @callofcoding for development purpose.


import 'package:careno/constant/helpers.dart';
import 'package:careno/models/payment_history.dart';
import 'package:careno/models/user.dart';
import 'package:careno/models/wallet_model.dart';
import 'package:careno/models/withdraw_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

Future<void> updateHostWallet({
  required String? senderName,
  required String? paymentMethod,
  required String? vehicleName,
  required double newAmount,
  required String hostId,  
})async{

  final userCollection = FirebaseFirestore.instance.collection('users');

  // getting host data
 User hostObject = await userCollection.doc(hostId).get().then((value) => User.fromMap(value.data()!));

 DateTime currentDateTime = DateTime.now();

 List<PaymentHistoryModel> previousPaymentHistory = hostObject.hostWallet!.paymentHistory!;

 // initialize new payment history
 PaymentHistoryModel newPaymentHistory = PaymentHistoryModel(
   id: currentDateTime.millisecondsSinceEpoch.toString(),
   paymentAmount: newAmount,
   paymentDate: currentDateTime.toString(),
   paymentMethod: paymentMethod,
   senderName: senderName,
   vehicleName: vehicleName
 );



 // add newPaymentHistory in previousPaymentHistory List
 previousPaymentHistory.add(newPaymentHistory);


 // initialize new wallet object
 WalletModel updatedWallet = WalletModel(
   currentBalance: hostObject.hostWallet!.currentBalance! + newAmount,
   date: currentDateTime.toString(),
   paymentHistory: previousPaymentHistory,
 );


 // update on database
  await userCollection.doc(hostId).update({'hostWallet': updatedWallet.toMap()});

  
}


Stream<DocumentSnapshot<Map<String, dynamic>>> getWalletStream(){
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getWithdrawStream(){
  return FirebaseFirestore.instance.collection('withdrawRequests').doc(uid).snapshots();
}


double calculateAmountForUser(double totalAmount) {
 if(adminPercentage == null){
   return throw Exception('admin percentage null');

 }else{
   double amountToAdd = (totalAmount * adminPercentage!) / 100;

   // Add the calculated amount to the total
   double newTotalAmount = totalAmount + amountToAdd;

   // Return the new total amount
   return newTotalAmount;
 }
}


double calculateAmountForHost(double totalAmount) {
  if(adminPercentage == null){
   return throw Exception('admin percentage null');
  }else{
    double amountToSubtract = (totalAmount * adminPercentage!) / 100;

    // Add the calculated amount to the total
    double newTotalAmount = totalAmount - amountToSubtract;

    // Return the new total amount
    return newTotalAmount;
  }
}



Future<void> makeWithdrawRequest(
    {required User userObject, required WithdrawRequestModel withdrawRequest})async{

  // make withdraw and cut money form wallet and add in payment history its like escrow
  // TODO: REMEMBER TO GIVE PAYMENT BACK IF ADMIN DECLINE, IF ACCEPT CHANGE STATUS TO APPROVED


  List<PaymentHistoryModel> newPaymentHistoryList = userObject.hostWallet!.paymentHistory!;
  newPaymentHistoryList.add(PaymentHistoryModel(id: withdrawRequest.dateTime,paymentAmount: withdrawRequest.amount,paymentDate: withdrawRequest.dateTime,senderName: 'Withdraw',paymentMethod: 'PENDING',vehicleName: ''));

  WalletModel updatedWallet = WalletModel(currentBalance: userObject.hostWallet!.currentBalance! - withdrawRequest.amount!,date: withdrawRequest.dateTime,paymentHistory: newPaymentHistoryList);

await  dbInstance.collection('withdrawRequests').doc(withdrawRequest.hostId).set(withdrawRequest.toMap());
await dbInstance.collection('users').doc(userObject.uid).update({"hostWallet" :updatedWallet.toMap() });

}


Future<double> getAdminPercentage()async{
 return dbInstance.collection('adminSettings').doc('percentage').get().then((value) => double.parse(value.data()!['percentage']));
}


 InputBorder inputBorder(
{double? radiusOfInputBorder,
bool enableBorder = false,
color = Colors.black}) {
return OutlineInputBorder(
borderRadius: BorderRadius.circular(radiusOfInputBorder ?? 5),
borderSide: BorderSide(
style: enableBorder == false ? BorderStyle.none : BorderStyle.solid,
color: color));
}




Widget customTextFieldWithHeading({required String heading,required String errorMsg,bool addValidationForNumber = false,required IconData iconData,void Function(String?)? onSaved,String? hintText,TextInputType? keyboardType,int maxLine = 1}){
  bool isNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final numericRegex = RegExp(r'^\d+$');
    return numericRegex.hasMatch(value);
  }
  return Column(
    children: [
      Row(
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          Text(heading,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight
                      .bold))
        ],
      ),
      SizedBox(
        height: 4,
      ),
      Row(
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          SizedBox(
            // height: 70,
            width: 240,
            child: TextFormField(
              maxLines: maxLine,
              autovalidateMode:
              AutovalidateMode
                  .onUserInteraction,
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return errorMsg;
                }
                    if(addValidationForNumber){
                  if (!isNumeric(
                      value)) {
                    return 'Please enter values between 0-9';
                  }
                }

                return null;
              },
              onTapOutside: (event) {
                FocusManager.instance
                    .primaryFocus
                    ?.unfocus();
              },
              onSaved: onSaved,

              keyboardType: keyboardType,
              decoration:
              InputDecoration(
                  prefixIcon:
                  Icon(
                    iconData,
                    color: AppColors.appPrimaryColor,
                  ),

                  contentPadding:
                  EdgeInsets.symmetric(
                      vertical:
                      13,
                      horizontal:
                      18),
                  hintText:
                  hintText,
                  border: inputBorder(
                      enableBorder:
                      true),
                  focusedBorder: inputBorder(
                      enableBorder:
                      true),
                  enabledBorder: inputBorder(
                      enableBorder:
                      true),
                  errorBorder: inputBorder(
                    enableBorder:
                    true,
                    color: Colors
                        .red,
                  )),
            ),
          ),
        ],
      ),
    ],
  );
}