import 'package:careno/models/wallet_model.dart';
import 'host_identity.dart';

class User {
  String uid,
      userType,
      phoneNumber,
      imageUrl,
      address,
      name,
      email,
      profileDescription,
      gender,
      notificationToken,
      status;
  int dob, timeStamp;
  HostIdentity? hostIdentity;
  WalletModel? hostWallet;
  double lat, lng;
  bool notification, isVerified, isBlocked;

  User({
    required this.uid,
    required this.userType,
    required this.phoneNumber,
    required this.imageUrl,
    required this.address,
    required this.name,
    required this.email,
    this.hostWallet,
    required this.profileDescription,
    required this.gender,
    required this.notificationToken,
    required this.status,
    required this.dob,
    required this.timeStamp,
    this.hostIdentity,
    required this.lat,
    required this.lng,
    required this.notification,
    required this.isVerified,
    required this.isBlocked,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userType': userType,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'address': address,
      'name': name,
      'email': email,
      'profileDescription': profileDescription,
      'hostWallet': hostWallet?.toMap(),
      'gender': gender,
      'notificationToken': notificationToken,
      'status': status,
      'dob': dob,
      'timeStamp': timeStamp,
      'hostIdentity': hostIdentity?.toMap(),
      'lat': lat,
      'lng': lng,
      'notification': notification,
      'isVerified': isVerified,
      'isBlocked': isBlocked,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      throw ArgumentError('Map cannot be null');
    }

    return User(
      uid: map['uid'] as String,
      userType: map['userType'] as String,
      phoneNumber: map['phoneNumber'] as String,
      imageUrl: map['imageUrl'] as String,
      address: map['address'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      hostWallet: map['hostWallet'] != null
          ? WalletModel.fromMap(map['hostWallet'] as Map<String, dynamic>)
          : null,
      profileDescription: map['profileDescription'] as String,
      gender: map['gender'] as String,
      notificationToken: map['notificationToken'] as String,
      status: map['status'] as String,
      dob: map['dob'] as int,
      timeStamp: map['timeStamp'] as int,
      hostIdentity: map['hostIdentity'] != null
          ? HostIdentity.fromMap(map['hostIdentity'] as Map<String, dynamic>)
          : null,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
      notification: map['notification'] as bool,
      isVerified: map['isVerified'] as bool,
      isBlocked: map['isBlocked'] as bool,
    );
  }
}
