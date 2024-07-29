class ChatResponse {
  final int code;
  final String status;
  final List<ChatMessage> data;

  ChatResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      code: json['code'],
      status: json['status'],
      data: (json['data'] as List<dynamic>)
          .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChatMessage {
  final int senderId;
  final int receiverId;
  final String chatText;
  final String chatDate;
  final bool sent;

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.chatText,
    required this.chatDate,
    required this.sent,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      chatText: json['chatText'] ?? '',
      chatDate: json['chatDate'] ?? '',
      sent: json['sent'] ?? false,
    );
  }
}
