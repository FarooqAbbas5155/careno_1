class NotificationModel {
  String id,receiverId, senderId;
  String title,subtitle,type;
  Map<String,dynamic>? data;
  bool read;
  int timestamp;

//<editor-fold desc="Data Methods">
  NotificationModel({
    required this.id,
    required this.receiverId,
    required this.senderId,
    required this.title,
    required this.subtitle,
    required this.type,
    this.data,
    required this.read,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          receiverId == other.receiverId &&
          senderId == other.senderId &&
          title == other.title &&
          subtitle == other.subtitle &&
          type == other.type &&
          data == other.data &&
          read == other.read &&
          timestamp == other.timestamp);

  @override
  int get hashCode =>
      id.hashCode ^
      receiverId.hashCode ^
      senderId.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      type.hashCode ^
      data.hashCode ^
      read.hashCode ^
      timestamp.hashCode;

  @override
  String toString() {
    return 'NotificationModel{' +
        ' id: $id,' +
        ' receiverId: $receiverId,' +
        ' senderId: $senderId,' +
        ' title: $title,' +
        ' subtitle: $subtitle,' +
        ' type: $type,' +
        ' data: $data,' +
        ' read: $read,' +
        ' timestamp: $timestamp,' +
        '}';
  }

  NotificationModel copyWith({
    String? id,
    String? receiverId,
    String? senderId,
    String? title,
    String? subtitle,
    String? type,
    Map<String, dynamic>? data,
    bool? read,
    int? timestamp,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
      senderId: senderId ?? this.senderId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      data: data ?? this.data,
      read: read ?? this.read,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'receiverId': this.receiverId,
      'senderId': this.senderId,
      'title': this.title,
      'subtitle': this.subtitle,
      'type': this.type,
      'data': this.data,
      'read': this.read,
      'timestamp': this.timestamp,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      receiverId: map['receiverId'] as String,
      senderId: map['senderId'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      type: map['type'] as String,
      data: map['data'] as Map<String, dynamic>,
      read: map['read'] as bool,
      timestamp: (map['timestamp'] as int?) ?? 0,
    );
  }

//</editor-fold>
}