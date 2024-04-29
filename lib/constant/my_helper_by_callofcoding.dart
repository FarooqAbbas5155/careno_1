


// this file is create by @callofcoding for development purpose.


import 'package:careno/constant/helpers.dart';
import 'package:careno/models/payment_history.dart';
import 'package:careno/models/user.dart';
import 'package:careno/models/wallet_model.dart';
import 'package:careno/models/withdraw_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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


Future<double> calculateAmountForUser(double totalAmount) async {
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
