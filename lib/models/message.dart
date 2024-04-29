class Message {
  String id;
  int timestamp,counter;
  String text, sender_id, receiver_id;
  String message_type;

//<editor-fold desc="Data Methods">
  Message({
    required this.id,
    required this.timestamp,
    required this.counter,
    required this.text,
    required this.sender_id,
    required this.receiver_id,
    required this.message_type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timestamp == other.timestamp &&
          counter == other.counter &&
          text == other.text &&
          sender_id == other.sender_id &&
          receiver_id == other.receiver_id &&
          message_type == other.message_type);

  @override
  int get hashCode =>
      id.hashCode ^
      timestamp.hashCode ^
      counter.hashCode ^
      text.hashCode ^
      sender_id.hashCode ^
      receiver_id.hashCode ^
      message_type.hashCode;

  @override
  String toString() {
    return 'Message{' +
        ' id: $id,' +
        ' timestamp: $timestamp,' +
        ' counter: $counter,' +
        ' text: $text,' +
        ' sender_id: $sender_id,' +
        ' receiver_id: $receiver_id,' +
        ' message_type: $message_type,' +
        '}';
  }

  Message copyWith({
    String? id,
    int? timestamp,
    int? counter,
    String? text,
    String? sender_id,
    String? receiver_id,
    String? message_type,
  }) {
    return Message(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      counter: counter ?? this.counter,
      text: text ?? this.text,
      sender_id: sender_id ?? this.sender_id,
      receiver_id: receiver_id ?? this.receiver_id,
      message_type: message_type ?? this.message_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'timestamp': this.timestamp,
      'counter': this.counter,
      'text': this.text,
      'sender_id': this.sender_id,
      'receiver_id': this.receiver_id,
      'message_type': this.message_type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String? ?? '',
      timestamp: map['timestamp'] as int? ?? 0,
      counter: map['counter'] as int? ?? 0,
      text: map['text'] as String? ?? '',
      sender_id: map['sender_id'] as String? ?? '',
      receiver_id: map['receiver_id'] as String? ?? '',
      message_type: map['message_type'] as String? ?? '',
    );
  }

//</editor-fold>
}
