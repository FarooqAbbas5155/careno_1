import 'package:careno/models/wallet_model.dart';

import 'host_identity.dart';

class User{
   String uid,userType,phoneNumber,imageUrl,address,name,email,profileDescription,gender,notificationToken,status;
   int dob,timeStamp;
   HostIdentity?  hostIdentity;

   // wallet add by @callofcoding

   WalletModel? hostWallet;

   double lat,lng;
   bool notification,isVerified,isBlocked;

//<editor-fold desc="Data Methods">
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

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     (other is User &&
  //         runtimeType == other.runtimeType &&
  //         uid == other.uid &&
  //         userType == other.userType &&
  //         phoneNumber == other.phoneNumber &&
  //         imageUrl == other.imageUrl &&
  //         address == other.address &&
  //         name == other.name &&
  //         email == other.email &&
  //         profileDescription == other.profileDescription &&
  //         gender == other.gender &&
  //         notificationToken == other.notificationToken &&
  //         status == other.status &&
  //         dob == other.dob &&
  //         timeStamp == other.timeStamp &&
  //         hostIdentity == other.hostIdentity &&
  //         lat == other.lat &&
  //         lng == other.lng &&
  //         notification == other.notification &&
  //         isVerified == other.isVerified &&
  //         isBlocked == other.isBlocked);

  // @override
  // int get hashCode =>
  //     uid.hashCode ^
  //     userType.hashCode ^
  //     phoneNumber.hashCode ^
  //     imageUrl.hashCode ^
  //     address.hashCode ^
  //     name.hashCode ^
  //     email.hashCode ^
  //     profileDescription.hashCode ^
  //     gender.hashCode ^
  //     notificationToken.hashCode ^
  //     status.hashCode ^
  //     dob.hashCode ^
  //     timeStamp.hashCode ^
  //     hostIdentity.hashCode ^
  //     lat.hashCode ^
  //     lng.hashCode ^
  //     notification.hashCode ^
  //     isVerified.hashCode ^
  //     isBlocked.hashCode;

  // @override
  // String toString() {
  //   return 'User{' +
  //       ' uid: $uid,' +
  //       ' userType: $userType,' +
  //       ' phoneNumber: $phoneNumber,' +
  //       ' imageUrl: $imageUrl,' +
  //       ' address: $address,' +
  //       ' name: $name,' +
  //       ' email: $email,' +
  //       ' profileDescription: $profileDescription,' +
  //       ' gender: $gender,' +
  //       ' notificationToken: $notificationToken,' +
  //       ' status: $status,' +
  //       ' dob: $dob,' +
  //       ' timeStamp: $timeStamp,' +
  //       ' hostIdentity: $hostIdentity,' +
  //       ' lat: $lat,' +
  //       ' lng: $lng,' +
  //       ' notification: $notification,' +
  //       ' isVerified: $isVerified,' +
  //       ' isBlocked: $isBlocked,' +
  //       '}';
  // }

  // User copyWith({
  //   String? uid,
  //   String? userType,
  //   String? phoneNumber,
  //   String? imageUrl,
  //   String? address,
  //   String? name,
  //   String? email,
  //   String? profileDescription,
  //   String? gender,
  //   String? notificationToken,
  //   String? status,
  //   int? dob,
  //   int? timeStamp,
  //   HostIdentity? hostIdentity,
  //   double? lat,
  //   double? lng,
  //   bool? notification,
  //   bool? isVerified,
  //   bool? isBlocked,
  // }) {
  //   return User(
  //     uid: uid ?? this.uid,
  //     userType: userType ?? this.userType,
  //     phoneNumber: phoneNumber ?? this.phoneNumber,
  //     imageUrl: imageUrl ?? this.imageUrl,
  //     address: address ?? this.address,
  //     name: name ?? this.name,
  //     email: email ?? this.email,
  //     profileDescription: profileDescription ?? this.profileDescription,
  //     gender: gender ?? this.gender,
  //     notificationToken: notificationToken ?? this.notificationToken,
  //     status: status ?? this.status,
  //     dob: dob ?? this.dob,
  //     timeStamp: timeStamp ?? this.timeStamp,
  //     hostIdentity: hostIdentity ?? this.hostIdentity,
  //     lat: lat ?? this.lat,
  //     lng: lng ?? this.lng,
  //     notification: notification ?? this.notification,
  //     isVerified: isVerified ?? this.isVerified,
  //     isBlocked: isBlocked ?? this.isBlocked,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'userType': this.userType,
      'phoneNumber': this.phoneNumber,
      'imageUrl': this.imageUrl,
      'address': this.address,
      'name': this.name,
      'email': this.email,
      'profileDescription': this.profileDescription,
      'hostWallet': this.hostWallet != null ? this.hostWallet!.toMap():{},
      'gender': this.gender,
      'notificationToken': this.notificationToken,
      'status': this.status,
      'dob': this.dob,
      'timeStamp': this.timeStamp,
      'hostIdentity': this.hostIdentity,
      'lat': this.lat,
      'lng': this.lng,
      'notification': this.notification,
      'isVerified': this.isVerified,
      'isBlocked': this.isBlocked,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      userType: map['userType'] as String,
      phoneNumber: map['phoneNumber'] as String,
      imageUrl: map['imageUrl'] as String,
      address: map['address'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      hostWallet: map.containsKey('hostWallet') ? WalletModel.fromMap(map['hostWallet']) : null,
      profileDescription: map['profileDescription'] as String,
      gender: map['gender'] as String,
      notificationToken: map['notificationToken'] as String,
      status: map['status'] as String,
      dob: map['dob'] as int,
      timeStamp: map['timeStamp'] as int,
      hostIdentity: map['hostIdentity'] != null ? HostIdentity.fromMap(map['hostIdentity']) : null,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
      notification: map['notification'] as bool,
      isVerified: map['isVerified'] as bool,
      isBlocked: map['isBlocked'] as bool,
    );
  }

//</editor-fold>
}