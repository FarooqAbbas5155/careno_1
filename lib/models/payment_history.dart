import 'dart:ffi';

class PaymentHistoryModel {
  String? id;
  String? paymentMethod;
  double? paymentAmount;
  String? senderName;
  String? vehicleName;
  String? paymentDate;

//<editor-fold desc="Data Methods">
  PaymentHistoryModel({
     this.id,
     this.vehicleName,
     this.paymentMethod,
     this.paymentAmount,
     this.senderName,
     this.paymentDate,
  });



  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'senderName': this.senderName,
      'vehicleName': this.vehicleName,
      'paymentMethod': this.paymentMethod,
      'paymentAmount': this.paymentAmount,
      'paymentDate': this.paymentDate,
    };
  }

  factory PaymentHistoryModel.fromMap(Map<String, dynamic> map) {
    return PaymentHistoryModel(
      id: map['id'] as String,
      vehicleName: map['vehicleName'] as String,
      paymentMethod: map['paymentMethod'] as String,
      paymentAmount: double.parse(map['paymentAmount'].toString()) as double,
      senderName: map['senderName'] as String,
      paymentDate: map['paymentDate'] as String,
    );
  }

//</editor-fold>
}