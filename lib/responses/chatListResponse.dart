class ChatListResponse {
  final int code;
  final String status;
  final List<ChatListUserData> data;

  ChatListResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory ChatListResponse.fromMap(Map<String, dynamic> json) {
    return ChatListResponse(
      code: json['code'],
      status: json['status'],
      data: (json['data'] as List<dynamic>)
          .map((item) => ChatListUserData.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChatListUserData {
  final String roomId;
  final String userId;
  final String name;
  final String userName;
  final String chatText;
  final String chatImg;
  final String chatDate;
  final int unreadCount;

  ChatListUserData({
    required this.roomId,
    required this.userId,
    required this.name,
    required this.userName,
    required this.chatText,
    required this.chatImg,
    required this.chatDate,
    required this.unreadCount,
  });

  factory ChatListUserData.fromMap(Map<String, dynamic> json) {
    return ChatListUserData(
      roomId: json['roomId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      userName: json['userName'] ?? '',
      chatText: json['chatText'] ?? '',
      chatImg: json['chatImg'] ?? '',
      chatDate: json['chatDate'] ?? '',
      unreadCount: json['unreadCount'] ?? 1,
    );
  }
}
