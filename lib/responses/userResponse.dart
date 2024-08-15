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

  factory UserResponse.fromMap(Map<String, dynamic> map) {
    return UserResponse(
      code: map['code'] ?? 201,
      status: map['status'],
      userData: UserData.fromMap(map['userData']),
      message: map['message'],
      isNew: map['isNew'],
    );
  }
}

class UserData {
  final String id;
  final String sub;
  final bool emailVerified;
  final String name;
  final String localeCountry;
  final String localeLanguage;
  final String givenName;
  final String familyName;
  final String email;
  final String picture;
  final int rate;
  final int balance;
  final String userName;

  UserData(
      {required this.id,
      required this.sub,
      required this.emailVerified,
      required this.name,
      required this.localeCountry,
      required this.localeLanguage,
      required this.givenName,
      required this.familyName,
      required this.email,
      required this.picture,
      required this.rate,
      required this.balance,
      required this.userName});

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      sub: map['sub'] ?? '',
      emailVerified: map['emailVerified'] ?? false,
      name: map['name'] ?? '',
      localeCountry: map['localeCountry'] ?? '',
      localeLanguage: map['localeLanguage'] ?? '',
      givenName: map['givenName'] ?? '',
      familyName: map['familyName'] ?? '',
      email: map['email'] ?? '',
      picture: map['picture'] ?? '',
      rate: map['rate'] ?? 0,
      balance: map['balance'] ?? 0,
      userName: map['userName'] ?? '',
    );
  }
}
