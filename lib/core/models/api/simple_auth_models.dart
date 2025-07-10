/// Simple authentication models without JSON serialization for initial testing
class AuthResponse {

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String,
      expiresIn: json['expiresIn'] as int,
      user: json['user'] as Map<String, dynamic>,
    );
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final Map<String, dynamic> user;

  Map<String, dynamic> toJson() => {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'user': user,
    };
}

class LoginRequest {

  const LoginRequest({required this.email, required this.password});
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RefreshTokenRequest {

  const RefreshTokenRequest({required this.refreshToken});
  final String refreshToken;

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}
