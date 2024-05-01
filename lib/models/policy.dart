class Policy{
  String id,title,description;

//<editor-fold desc="Data Methods">
  Policy({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Policy &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description);

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ description.hashCode;

  @override
  String toString() {
    return 'Policy{' +
        ' id: $id,' +
        ' title: $title,' +
        ' description: $description,' +
        '}';
  }

  Policy copyWith({
    String? id,
    String? title,
    String? description,
  }) {
    return Policy(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
    };
  }

  factory Policy.fromMap(Map<String, dynamic> map) {
    return Policy(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

//</editor-fold>
}