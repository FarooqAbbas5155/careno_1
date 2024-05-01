class PromotionBanner{
  String vehiceId,vehicleModel,description;
  List<String> imageList;

//<editor-fold desc="Data Methods">
  PromotionBanner({
    required this.vehiceId,
    required this.vehicleModel,
    required this.description,
    required this.imageList,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromotionBanner &&
          runtimeType == other.runtimeType &&
          vehiceId == other.vehiceId &&
          vehicleModel == other.vehicleModel &&
          description == other.description &&
          imageList == other.imageList);

  @override
  int get hashCode =>
      vehiceId.hashCode ^
      vehicleModel.hashCode ^
      description.hashCode ^
      imageList.hashCode;

  @override
  String toString() {
    return 'PromotionBanner{' +
        ' vehiceId: $vehiceId,' +
        ' vehicleModel: $vehicleModel,' +
        ' description: $description,' +
        ' imageList: $imageList,' +
        '}';
  }

  PromotionBanner copyWith({
    String? vehiceId,
    String? vehicleModel,
    String? description,
    List<String>? imageList,
  }) {
    return PromotionBanner(
      vehiceId: vehiceId ?? this.vehiceId,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      description: description ?? this.description,
      imageList: imageList ?? this.imageList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehiceId': this.vehiceId,
      'vehicleModel': this.vehicleModel,
      'description': this.description,
      'imageList': this.imageList,
    };
  }

  factory PromotionBanner.fromMap(Map<String, dynamic> map) {
    return PromotionBanner(
      vehiceId: map['vehiceId'] as String,
      vehicleModel: map['vehicleModel'] as String,
      description: map['description'] as String,
      imageList: (map['imageList']as List<dynamic>).cast<String>(),
    );
  }

//</editor-fold>
}