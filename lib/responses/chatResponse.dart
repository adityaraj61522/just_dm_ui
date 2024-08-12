class ChatResponse {
  final int code;
  final String status;
  final List<ChatMessage> data;

  ChatResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory ChatResponse.fromMap(Map<String, dynamic> json) {
    return ChatResponse(
      code: json['code'],
      status: json['status'],
      data: (json['data'] as List<dynamic>)
          .map((item) => ChatMessage.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChatMessage {
  final String senderId;
  final String receiverId;
  final String chatText;
  final String chatImg;
  final String chatDate;
  final bool sent;

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.chatText,
    required this.chatImg,
    required this.chatDate,
    required this.sent,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['sender_id'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      chatText: json['chatText'] ?? '',
      chatImg: json['chatImg'] ?? '',
      chatDate: json['chatDate'] ?? '',
      sent: json['sent'] ?? false,
    );
  }
}
