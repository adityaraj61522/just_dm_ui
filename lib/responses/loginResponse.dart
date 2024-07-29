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
      location:json['location'], // Treat data as a single object
    );
  }
}

class LoginResponseData {
  final String location;
  final String authorName;
  final String title;
  final String shortenedUrl;
  final String imageUrl;
  final String sourceUrl;
  final String content;
  final List<String> categoryNames;
  final String regeneratedResponse;
  final String answer;

  LoginResponseData({
    required this.location,
    required this.authorName,
    required this.title,
    required this.shortenedUrl,
    required this.imageUrl,
    required this.sourceUrl,
    required this.content,
    required this.categoryNames,
    required this.regeneratedResponse,
    required this.answer,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) {
    return LoginResponseData(
      location: json['location'] ?? '',
      authorName: json['author_name'] ?? '',
      title: json['title'] ?? '',
      shortenedUrl: json['shortened_url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      sourceUrl: json['source_url'] ?? '',
      content: json['content'] ?? '',
      categoryNames: List<String>.from(json['category_names']),
      regeneratedResponse: json['regeneratedResponse'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}
