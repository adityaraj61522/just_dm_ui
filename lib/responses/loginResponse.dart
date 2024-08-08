class LoginResponse {
  final int code;
  final String status;
  final String location; // Change from List<NewsItem> to NewsItem

  LoginResponse({
    required this.code,
    required this.status,
    required this.location,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'],
      status: json['status'],
      location: json['location'] ?? '',
    );
  }
}
