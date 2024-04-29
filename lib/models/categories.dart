class Category{
  String id,name,image;

//<editor-fold desc="Data Methods">
  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Category &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              image == other.image);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ image.hashCode;

  @override
  String toString() {
    return 'Category{' +
        ' id: $id,' +
        ' name: $name,' +
        ' image: $image,' +
        '}';
  }

  Category copyWith({
    String? id,
    String? name,
    String? image,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'image': this.image,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
    );
  }

//</editor-fold>
}