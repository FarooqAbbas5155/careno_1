class WithdrawRequestModel {
  double? amount;
  String? hostId;
  String? hostName;
  String? profilePic;
  String? hostPhoneNumber;
  String? email;
  String? requestStatus;
  String? dateTime;
  String? paymentMethod;
  String? accountNumber;
  String? rejectionReason;

  WithdrawRequestModel({
    this.amount,
    this.hostId,
    this.hostName,
    this.hostPhoneNumber,
    this.profilePic,
    this.email,
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
      'rejectionReason':rejectionReason ?? '',
      'email': email,
      'profilePic':profilePic,
      'hostName': hostName,
      'hostPhoneNumber':hostPhoneNumber
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
        rejectionReason: map['rejectionReason'],
        email:map['email'],
        hostName: map['hostName'],
        profilePic: map['profilePic'],
        hostPhoneNumber : map['hostPhoneNumber']
    );
  }
}
