class AddHostVehicle{
  String hostId, vehicleId, address;
  String vehicleImageComplete, vehicleImageNumberPlate, vehicleImageRightSide, vehicleImageRear, vehicleImageInterior;
  String vehicleModel, vehicleCategory, vehicleYear, vehicleSeats, vehicleTransmission, vehicleFuelType, vehicleNumberPlate, vehicleColor, vehicleLicenseExpiryDate, vehiclePerDayRent, vehiclePerHourRent, vehicleRegistrationImage;
  String status, vehicleDescription, currency;
  double rating;
  double latitude, longitude;
  List<String> imagesUrl;
  bool isVerified;

  //<editor-fold desc="Data Methods">
  AddHostVehicle({
    required this.hostId,
    required this.vehicleId,
    required this.address,
    required this.vehicleImageComplete,
    required this.vehicleImageNumberPlate,
    required this.vehicleImageRightSide,
    required this.vehicleImageRear,
    required this.vehicleImageInterior,
    required this.vehicleModel,
    required this.vehicleCategory,
    required this.vehicleYear,
    required this.vehicleSeats,
    required this.vehicleTransmission,
    required this.vehicleFuelType,
    required this.vehicleNumberPlate,
    required this.vehicleColor,
    required this.vehicleLicenseExpiryDate,
    required this.vehiclePerDayRent,
    required this.vehiclePerHourRent,
    required this.vehicleRegistrationImage,
    required this.status,
    required this.vehicleDescription,
    required this.currency,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.imagesUrl,
    required this.isVerified,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AddHostVehicle &&
              runtimeType == other.runtimeType &&
              hostId == other.hostId &&
              vehicleId == other.vehicleId &&
              address == other.address &&
              vehicleImageComplete == other.vehicleImageComplete &&
              vehicleImageNumberPlate == other.vehicleImageNumberPlate &&
              vehicleImageRightSide == other.vehicleImageRightSide &&
              vehicleImageRear == other.vehicleImageRear &&
              vehicleImageInterior == other.vehicleImageInterior &&
              vehicleModel == other.vehicleModel &&
              vehicleCategory == other.vehicleCategory &&
              vehicleYear == other.vehicleYear &&
              vehicleSeats == other.vehicleSeats &&
              vehicleTransmission == other.vehicleTransmission &&
              vehicleFuelType == other.vehicleFuelType &&
              vehicleNumberPlate == other.vehicleNumberPlate &&
              vehicleColor == other.vehicleColor &&
              vehicleLicenseExpiryDate == other.vehicleLicenseExpiryDate &&
              vehiclePerDayRent == other.vehiclePerDayRent &&
              vehiclePerHourRent == other.vehiclePerHourRent &&
              vehicleRegistrationImage == other.vehicleRegistrationImage &&
              status == other.status &&
              vehicleDescription == other.vehicleDescription &&
              currency == other.currency &&
              rating == other.rating &&
              latitude == other.latitude &&
              longitude == other.longitude &&
              imagesUrl == other.imagesUrl &&
              isVerified == other.isVerified);

  @override
  int get hashCode =>
      hostId.hashCode ^
      vehicleId.hashCode ^
      address.hashCode ^
      vehicleImageComplete.hashCode ^
      vehicleImageNumberPlate.hashCode ^
      vehicleImageRightSide.hashCode ^
      vehicleImageRear.hashCode ^
      vehicleImageInterior.hashCode ^
      vehicleModel.hashCode ^
      vehicleCategory.hashCode ^
      vehicleYear.hashCode ^
      vehicleSeats.hashCode ^
      vehicleTransmission.hashCode ^
      vehicleFuelType.hashCode ^
      vehicleNumberPlate.hashCode ^
      vehicleColor.hashCode ^
      vehicleLicenseExpiryDate.hashCode ^
      vehiclePerDayRent.hashCode ^
      vehiclePerHourRent.hashCode ^
      vehicleRegistrationImage.hashCode ^
      status.hashCode ^
      vehicleDescription.hashCode ^
      currency.hashCode ^
      rating.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      imagesUrl.hashCode ^
      isVerified.hashCode;

  @override
  String toString() {
    return 'AddHostVehicle{' +
        ' hostId: $hostId,' +
        ' vehicleId: $vehicleId,' +
        ' address: $address,' +
        ' vehicleImageComplete: $vehicleImageComplete,' +
        ' vehicleImageNumberPlate: $vehicleImageNumberPlate,' +
        ' vehicleImageRightSide: $vehicleImageRightSide,' +
        ' vehicleImageRear: $vehicleImageRear,' +
        ' vehicleImageInterior: $vehicleImageInterior,' +
        ' vehicleModel: $vehicleModel,' +
        ' vehicleCategory: $vehicleCategory,' +
        ' vehicleYear: $vehicleYear,' +
        ' vehicleSeats: $vehicleSeats,' +
        ' vehicleTransmission: $vehicleTransmission,' +
        ' vehicleFuelType: $vehicleFuelType,' +
        ' vehicleNumberPlate: $vehicleNumberPlate,' +
        ' vehicleColor: $vehicleColor,' +
        ' vehicleLicenseExpiryDate: $vehicleLicenseExpiryDate,' +
        ' vehiclePerDayRent: $vehiclePerDayRent,' +
        ' vehiclePerHourRent: $vehiclePerHourRent,' +
        ' vehicleRegistrationImage: $vehicleRegistrationImage,' +
        ' status: $status,' +
        ' vehicleDescription: $vehicleDescription,' +
        ' currency: $currency,' +
        ' rating: $rating,' +
        ' latitude: $latitude,' +
        ' longitude: $longitude,' +
        ' imagesUrl: $imagesUrl,' +
        ' isVerified: $isVerified,' +
        '}';
  }

  AddHostVehicle copyWith({
    String? hostId,
    String? vehicleId,
    String? address,
    String? vehicleImageComplete,
    String? vehicleImageNumberPlate,
    String? vehicleImageRightSide,
    String? vehicleImageRear,
    String? vehicleImageInterior,
    String? vehicleModel,
    String? vehicleCategory,
    String? vehicleYear,
    String? vehicleSeats,
    String? vehicleTransmission,
    String? vehicleFuelType,
    String? vehicleNumberPlate,
    String? vehicleColor,
    String? vehicleLicenseExpiryDate,
    String? vehiclePerDayRent,
    String? vehiclePerHourRent,
    String? vehicleRegistrationImage,
    String? status,
    String? vehicleDescription,
    String? currency,
    double? rating,
    double? latitude,
    double? longitude,
    List<String>? imagesUrl,
    bool? isVerified,
  }) {
    return AddHostVehicle(
      hostId: hostId ?? this.hostId,
      vehicleId: vehicleId ?? this.vehicleId,
      address: address ?? this.address,
      vehicleImageComplete: vehicleImageComplete ?? this.vehicleImageComplete,
      vehicleImageNumberPlate: vehicleImageNumberPlate ?? this.vehicleImageNumberPlate,
      vehicleImageRightSide: vehicleImageRightSide ?? this.vehicleImageRightSide,
      vehicleImageRear: vehicleImageRear ?? this.vehicleImageRear,
      vehicleImageInterior: vehicleImageInterior ?? this.vehicleImageInterior,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      vehicleSeats: vehicleSeats ?? this.vehicleSeats,
      vehicleTransmission: vehicleTransmission ?? this.vehicleTransmission,
      vehicleFuelType: vehicleFuelType ?? this.vehicleFuelType,
      vehicleNumberPlate: vehicleNumberPlate ?? this.vehicleNumberPlate,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleLicenseExpiryDate: vehicleLicenseExpiryDate ?? this.vehicleLicenseExpiryDate,
      vehiclePerDayRent: vehiclePerDayRent ?? this.vehiclePerDayRent,
      vehiclePerHourRent: vehiclePerHourRent ?? this.vehiclePerHourRent,
      vehicleRegistrationImage: vehicleRegistrationImage ?? this.vehicleRegistrationImage,
      status: status ?? this.status,
      vehicleDescription: vehicleDescription ?? this.vehicleDescription,
      currency: currency ?? this.currency,
      rating: rating ?? this.rating,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hostId': this.hostId,
      'vehicleId': this.vehicleId,
      'address': this.address,
      'vehicleImageComplete': this.vehicleImageComplete,
      'vehicleImageNumberPlate': this.vehicleImageNumberPlate,
      'vehicleImageRightSide': this.vehicleImageRightSide,
      'vehicleImageRear': this.vehicleImageRear,
      'vehicleImageInterior': this.vehicleImageInterior,
      'vehicleModel': this.vehicleModel,
      'vehicleCategory': this.vehicleCategory,
      'vehicleYear': this.vehicleYear,
      'vehicleSeats': this.vehicleSeats,
      'vehicleTransmission': this.vehicleTransmission,
      'vehicleFuelType': this.vehicleFuelType,
      'vehicleNumberPlate': this.vehicleNumberPlate,
      'vehicleColor': this.vehicleColor,
      'vehicleLicenseExpiryDate': this.vehicleLicenseExpiryDate,
      'vehiclePerDayRent': this.vehiclePerDayRent,
      'vehiclePerHourRent': this.vehiclePerHourRent,
      'vehicleRegistrationImage': this.vehicleRegistrationImage,
      'status': this.status,
      'vehicleDescription': this.vehicleDescription,
      'currency': this.currency,
      'rating': this.rating,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'imagesUrl': this.imagesUrl,
      'isVerified': this.isVerified,
    };
  }

  factory AddHostVehicle.fromMap(Map<String, dynamic> map) {
    return AddHostVehicle(
      hostId: map['hostId'] as String,
      vehicleId: map['vehicleId'] as String,
      address: map['address'] as String,
      vehicleImageComplete: map['vehicleImageComplete'] as String,
      vehicleImageNumberPlate: map['vehicleImageNumberPlate'] as String,
      vehicleImageRightSide: map['vehicleImageRightSide'] as String,
      vehicleImageRear: map['vehicleImageRear'] as String,
      vehicleImageInterior: map['vehicleImageInterior'] as String,
      vehicleModel: map['vehicleModel'] as String,
      vehicleCategory: map['vehicleCategory'] as String,
      vehicleYear: map['vehicleYear'] as String,
      vehicleSeats: map['vehicleSeats'] as String,
      vehicleTransmission: map['vehicleTransmission'] as String,
      vehicleFuelType: map['vehicleFuelType'] as String,
      vehicleNumberPlate: map['vehicleNumberPlate'] as String,
      vehicleColor: map['vehicleColor'] as String,
      vehicleLicenseExpiryDate: map['vehicleLicenseExpiryDate'] as String,
      vehiclePerDayRent: map['vehiclePerDayRent'] as String,
      vehiclePerHourRent: map['vehiclePerHourRent'] as String,
      vehicleRegistrationImage: map['vehicleRegistrationImage'] as String,
      status: map['status'] as String,
      vehicleDescription: map['vehicleDescription'] as String,
      currency: map['currency'] as String,
      rating: map['rating'] as double,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      imagesUrl: (map['imagesUrl'] as List<dynamic>).cast<String>(),
      isVerified: map['isVerified'] as bool,
    );
  }

//</editor-fold>
}
