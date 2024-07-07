import 'dart:ffi';

class PaymentHistoryModel {
  String? id;
  String? paymentMethod;
  double? paymentAmount;
  String? senderName;
  String? vehicleName;
  String? paymentDate;
  String? currency;

//<editor-fold desc="Data Methods">
  PaymentHistoryModel({
    this.id,
    this.paymentMethod,
    this.paymentAmount,
    this.senderName,
    this.vehicleName,
    this.paymentDate,
    this.currency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentHistoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          paymentMethod == other.paymentMethod &&
          paymentAmount == other.paymentAmount &&
          senderName == other.senderName &&
          vehicleName == other.vehicleName &&
          paymentDate == other.paymentDate &&
          currency == other.currency);

  @override
  int get hashCode =>
      id.hashCode ^
      paymentMethod.hashCode ^
      paymentAmount.hashCode ^
      senderName.hashCode ^
      vehicleName.hashCode ^
      paymentDate.hashCode ^
      currency.hashCode;

  @override
  String toString() {
    return 'PaymentHistoryModel{' +
        ' id: $id,' +
        ' paymentMethod: $paymentMethod,' +
        ' paymentAmount: $paymentAmount,' +
        ' senderName: $senderName,' +
        ' vehicleName: $vehicleName,' +
        ' paymentDate: $paymentDate,' +
        ' currency: $currency,' +
        '}';
  }

  PaymentHistoryModel copyWith({
    String? id,
    String? paymentMethod,
    double? paymentAmount,
    String? senderName,
    String? vehicleName,
    String? paymentDate,
    String? currency,
  }) {
    return PaymentHistoryModel(
      id: id ?? this.id,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      senderName: senderName ?? this.senderName,
      vehicleName: vehicleName ?? this.vehicleName,
      paymentDate: paymentDate ?? this.paymentDate,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'paymentMethod': this.paymentMethod,
      'paymentAmount': this.paymentAmount,
      'senderName': this.senderName,
      'vehicleName': this.vehicleName,
      'paymentDate': this.paymentDate,
      'currency': this.currency,
    };
  }

  factory PaymentHistoryModel.fromMap(Map<String, dynamic> map) {
    return PaymentHistoryModel(
      id: map['id'] as String,
      paymentMethod: map['paymentMethod'] as String,
      paymentAmount: double.parse(map['paymentAmount'].toString()) as double,
      senderName: map['senderName'] as String,
      vehicleName: map['vehicleName'] as String,
      paymentDate: map['paymentDate'] as String,
      currency: map['currency'] as String,
    );
  }

//</editor-fold>
}