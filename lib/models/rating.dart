class Rating {
  String bookingId,vehicleId,userId,id,description,type;
  double avgRating;
  int timeStamp;

//<editor-fold desc="Data Methods">
  Rating({
    required this.bookingId,
    required this.vehicleId,
    required this.userId,
    required this.id,
    required this.description,
    required this.type,
    required this.avgRating,
    required this.timeStamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rating &&
          runtimeType == other.runtimeType &&
          bookingId == other.bookingId &&
          vehicleId == other.vehicleId &&
          userId == other.userId &&
          id == other.id &&
          description == other.description &&
          type == other.type &&
          avgRating == other.avgRating &&
          timeStamp == other.timeStamp);

  @override
  int get hashCode =>
      bookingId.hashCode ^
      vehicleId.hashCode ^
      userId.hashCode ^
      id.hashCode ^
      description.hashCode ^
      type.hashCode ^
      avgRating.hashCode ^
      timeStamp.hashCode;

  @override
  String toString() {
    return 'Rating{' +
        ' bookingId: $bookingId,' +
        ' vehicleId: $vehicleId,' +
        ' userId: $userId,' +
        ' id: $id,' +
        ' description: $description,' +
        ' type: $type,' +
        ' avgRating: $avgRating,' +
        ' timeStamp: $timeStamp,' +
        '}';
  }

  Rating copyWith({
    String? bookingId,
    String? vehicleId,
    String? userId,
    String? id,
    String? description,
    String? type,
    double? avgRating,
    int? timeStamp,
  }) {
    return Rating(
      bookingId: bookingId ?? this.bookingId,
      vehicleId: vehicleId ?? this.vehicleId,
      userId: userId ?? this.userId,
      id: id ?? this.id,
      description: description ?? this.description,
      type: type ?? this.type,
      avgRating: avgRating ?? this.avgRating,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': this.bookingId,
      'vehicleId': this.vehicleId,
      'userId': this.userId,
      'id': this.id,
      'description': this.description,
      'type': this.type,
      'avgRating': this.avgRating,
      'timeStamp': this.timeStamp,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      bookingId: map['bookingId'] as String,
      vehicleId: map['vehicleId'] as String,
      userId: map['userId'] as String,
      id: map['id'] as String,
      description: map['description'] as String,
      type: map['type'] as String,
      avgRating: map['avgRating'] as double,
      timeStamp: map['timeStamp'] as int,
    );
  }

//</editor-fold>
}