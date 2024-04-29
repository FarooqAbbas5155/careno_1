class WithdrawRequestModel {
  double? amount;
  String? hostId;
  String? requestStatus;
  String? dateTime;
  String? paymentMethod;
  String? accountNumber;
  String? rejectionReason;

  WithdrawRequestModel({
    this.amount,
    this.hostId,
    this.requestStatus,
    this.dateTime,
    this.paymentMethod,
    this.accountNumber,
    this.rejectionReason
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'hostId': hostId,
      'requestStatus': requestStatus,
      'dateTime': dateTime,
      'paymentMethod': paymentMethod,
      'accountNumber': accountNumber,
      'rejectionReason':rejectionReason ?? ''
    };
  }

  factory WithdrawRequestModel.fromMap(Map<String, dynamic> map) {
    return WithdrawRequestModel(
      amount: map['amount'],
      hostId: map['hostId'],
      requestStatus: map['requestStatus'],
      dateTime: map['dateTime'],
      paymentMethod: map['paymentMethod'],
      accountNumber: map['accountNumber'],
        rejectionReason: map['rejectionReason']
    );
  }
}
