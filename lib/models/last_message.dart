class LastMessage {
  String sender, lastMessage;
  int timestamp,counter;
  String chatRoomId;
  bool isBlocked;

//<editor-fold desc="Data Methods">
  LastMessage({
    required this.sender,
    required this.lastMessage,
    required this.timestamp,
    required this.counter,
    required this.chatRoomId,
    required this.isBlocked,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LastMessage &&
          runtimeType == other.runtimeType &&
          sender == other.sender &&
          lastMessage == other.lastMessage &&
          timestamp == other.timestamp &&
          counter == other.counter &&
          chatRoomId == other.chatRoomId &&
          isBlocked == other.isBlocked);

  @override
  int get hashCode =>
      sender.hashCode ^
      lastMessage.hashCode ^
      timestamp.hashCode ^
      counter.hashCode ^
      chatRoomId.hashCode ^
      isBlocked.hashCode;

  @override
  String toString() {
    return 'LastMessage{' +
        ' sender: $sender,' +
        ' lastMessage: $lastMessage,' +
        ' timestamp: $timestamp,' +
        ' counter: $counter,' +
        ' chatRoomId: $chatRoomId,' +
        ' isBlocked: $isBlocked,' +
        '}';
  }

  LastMessage copyWith({
    String? sender,
    String? lastMessage,
    int? timestamp,
    int? counter,
    String? chatRoomId,
    bool? isBlocked,
  }) {
    return LastMessage(
      sender: sender ?? this.sender,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      counter: counter ?? this.counter,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': this.sender,
      'lastMessage': this.lastMessage,
      'timestamp': this.timestamp,
      'counter': this.counter,
      'chatRoomId': this.chatRoomId,
      'isBlocked': this.isBlocked,
    };
  }

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      sender: map['sender'] as String,
      lastMessage: map['lastMessage'] as String,
      timestamp: map['timestamp'] as int,
      counter: map['counter'] as int,
      chatRoomId: map['chatRoomId'] as String,
      isBlocked: map['isBlocked'] as bool,
    );
  }

//</editor-fold>
}