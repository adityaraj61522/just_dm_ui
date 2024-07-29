class ChatListResponse {
  final int code;
  final String status;
  final List<ChatListUserData> data;

  ChatListResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      code: json['code'],
      status: json['status'],
      data: (json['data'] as List<dynamic>)
          .map(
              (item) => ChatListUserData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChatListUserData {
  final int roomId;
  final int userId;
  final String name;
  final String chatText;
  final String chatImg;
  final String chatDate;

  ChatListUserData({
    required this.roomId,
    required this.userId,
    required this.name,
    required this.chatText,
    required this.chatImg,
    required this.chatDate,
  });

  factory ChatListUserData.fromJson(Map<String, dynamic> json) {
    return ChatListUserData(
      roomId: json['roomId'],
      userId: json['userId'],
      name: json['name'],
      chatText: json['chatText'],
      chatImg: json['chatImg'],
      chatDate: json['chatDate'],
    );
  }
}
