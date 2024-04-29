import 'package:careno/models/payment_history.dart';

class WalletModel{
  double? currentBalance;
  String? date;
  List<PaymentHistoryModel>? paymentHistory;


  WalletModel({this.currentBalance, this.date, this.paymentHistory});

  Map<String, dynamic> toMap() {
    return {
      'currentBalance': currentBalance,
      'date': date,
      'paymentHistory': (paymentHistory != null)
          ? paymentHistory!
          .map((e) => e.toMap())
          .toList()
          : []
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
        currentBalance: map['currentBalance'] ,
        date: map['date'],
        paymentHistory: map.containsKey('paymentHistory')
            ? (map['paymentHistory'] as List<dynamic>).map((e) => PaymentHistoryModel.fromMap(e)).toList()
            : []
    );
  }

}