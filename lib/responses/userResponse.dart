class UserResponse {
  final int code;
  final String status;
  final UserData userData;
  final String message;
  final bool isNew;

  UserResponse({
    required this.code,
    required this.status,
    required this.userData,
    required this.message,
    required this.isNew,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      code: json['code'],
      status: json['status'],
      userData: UserData.fromJson(json['userData']),
      message: json['message'],
      isNew: json['isNew'],
    );
  }
}

class UserData {
  final String sub;
  final bool emailVerified;
  final String name;
  final Locale locale;
  final String givenName;
  final String familyName;
  final String email;
  final String picture;

  UserData({
    required this.sub,
    required this.emailVerified,
    required this.name,
    required this.locale,
    required this.givenName,
    required this.familyName,
    required this.email,
    required this.picture,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      sub: json['sub'],
      emailVerified: json['email_verified'],
      name: json['name'],
      locale: Locale.fromJson(json['locale']),
      givenName: json['given_name'],
      familyName: json['family_name'],
      email: json['email'],
      picture: json['picture'],
    );
  }
}

class Locale {
  final String country;
  final String language;

  Locale({
    required this.country,
    required this.language,
  });

  factory Locale.fromJson(Map<String, dynamic> json) {
    return Locale(
      country: json['country'],
      language: json['language'],
    );
  }
}
