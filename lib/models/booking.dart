class Booking {
  String bookingId,
      vehicleId,
      userId,
      hostId,
      bookingStatus,
      cancelBY,
      cancelDetail;
  String paymentStatus;
  String bookingType;
  int bookingStartDate, bookingEndDate;
  bool completed,isRated;
  int startTime, EndTime;
  double price;

  bool? withdrawn;

//<editor-fold desc="Data Methods">
  Booking({
    required this.bookingId,
    required this.vehicleId,
    required this.userId,
    required this.hostId,
    required this.bookingStatus,
    required this.cancelBY,
    required this.cancelDetail,
    required this.paymentStatus,
    required this.bookingType,
    required this.bookingStartDate,
    required this.bookingEndDate,
    required this.completed,
    required this.isRated,
    required this.startTime,
    required this.EndTime,
    required this.price,
    this.withdrawn,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Booking &&
          runtimeType == other.runtimeType &&
          bookingId == other.bookingId &&
          vehicleId == other.vehicleId &&
          userId == other.userId &&
          hostId == other.hostId &&
          bookingStatus == other.bookingStatus &&
          cancelBY == other.cancelBY &&
          cancelDetail == other.cancelDetail &&
          paymentStatus == other.paymentStatus &&
          bookingType == other.bookingType &&
          bookingStartDate == other.bookingStartDate &&
          bookingEndDate == other.bookingEndDate &&
          completed == other.completed &&
          isRated == other.isRated &&
          startTime == other.startTime &&
          EndTime == other.EndTime &&
          price == other.price &&
          withdrawn == other.withdrawn);

  @override
  int get hashCode =>
      bookingId.hashCode ^
      vehicleId.hashCode ^
      userId.hashCode ^
      hostId.hashCode ^
      bookingStatus.hashCode ^
      cancelBY.hashCode ^
      cancelDetail.hashCode ^
      paymentStatus.hashCode ^
      bookingType.hashCode ^
      bookingStartDate.hashCode ^
      bookingEndDate.hashCode ^
      completed.hashCode ^
      isRated.hashCode ^
      startTime.hashCode ^
      EndTime.hashCode ^
      price.hashCode ^
      withdrawn.hashCode;

  @override
  String toString() {
    return 'Booking{' +
        ' bookingId: $bookingId,' +
        ' vehicleId: $vehicleId,' +
        ' userId: $userId,' +
        ' hostId: $hostId,' +
        ' bookingStatus: $bookingStatus,' +
        ' cancelBY: $cancelBY,' +
        ' cancelDetail: $cancelDetail,' +
        ' paymentStatus: $paymentStatus,' +
        ' bookingType: $bookingType,' +
        ' bookingStartDate: $bookingStartDate,' +
        ' bookingEndDate: $bookingEndDate,' +
        ' completed: $completed,' +
        ' isRated: $isRated,' +
        ' startTime: $startTime,' +
        ' EndTime: $EndTime,' +
        ' price: $price,' +
        ' withdrawn: $withdrawn,' +
        '}';
  }

  Booking copyWith({
    String? bookingId,
    String? vehicleId,
    String? userId,
    String? hostId,
    String? bookingStatus,
    String? cancelBY,
    String? cancelDetail,
    String? paymentStatus,
    String? bookingType,
    int? bookingStartDate,
    int? bookingEndDate,
    bool? completed,
    bool? isRated,
    int? startTime,
    int? EndTime,
    double? price,
    bool? withdrawn,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      vehicleId: vehicleId ?? this.vehicleId,
      userId: userId ?? this.userId,
      hostId: hostId ?? this.hostId,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      cancelBY: cancelBY ?? this.cancelBY,
      cancelDetail: cancelDetail ?? this.cancelDetail,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      bookingType: bookingType ?? this.bookingType,
      bookingStartDate: bookingStartDate ?? this.bookingStartDate,
      bookingEndDate: bookingEndDate ?? this.bookingEndDate,
      completed: completed ?? this.completed,
      isRated: isRated ?? this.isRated,
      startTime: startTime ?? this.startTime,
      EndTime: EndTime ?? this.EndTime,
      price: price ?? this.price,
      withdrawn: withdrawn ?? this.withdrawn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': this.bookingId,
      'vehicleId': this.vehicleId,
      'userId': this.userId,
      'hostId': this.hostId,
      'bookingStatus': this.bookingStatus,
      'cancelBY': this.cancelBY,
      'cancelDetail': this.cancelDetail,
      'paymentStatus': this.paymentStatus,
      'bookingType': this.bookingType,
      'bookingStartDate': this.bookingStartDate,
      'bookingEndDate': this.bookingEndDate,
      'completed': this.completed,
      'isRated': this.isRated,
      'startTime': this.startTime,
      'EndTime': this.EndTime,
      'price': this.price,
      'withdrawn': this.withdrawn,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      bookingId: map['bookingId'] as String? ?? '',
      vehicleId: map['vehicleId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      hostId: map['hostId'] as String? ?? '',
      cancelBY: map['cancelBY'] as String,
      cancelDetail: map['cancelDetail'] as String,
      bookingStatus: map['bookingStatus'] as String? ?? '',
      paymentStatus: map['paymentStatus'] as String? ?? '',
      bookingType: map['bookingType'] as String? ?? '',
      bookingStartDate: map['bookingStartDate'] as int? ?? 0,
      bookingEndDate: map['bookingEndDate'] as int? ?? 0,
      completed: map['completed'] as bool? ?? false,
      isRated: map['isRated'] as bool? ?? false,
      startTime: map['startTime'] as int? ?? 0,
      EndTime: map['EndTime'] as int? ?? 0,
      price: map['price'] as double? ?? 0.0,
      withdrawn: map['withdrawn'] as bool? ?? false,
    );
  }

//</editor-fold>
}
