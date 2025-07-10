import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

/// Base authentication response
@JsonSerializable()
class AuthResponse {

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @JsonKey(name: 'user_id')
  final String userId;

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

/// Wallet connect request
@JsonSerializable()
class WalletConnectRequest {

  const WalletConnectRequest({
    required this.walletAddress,
    required this.signature,
    required this.message,
    required this.walletType,
  });

  factory WalletConnectRequest.fromJson(Map<String, dynamic> json) =>
      _$WalletConnectRequestFromJson(json);
  final String walletAddress;
  final String signature;
  final String message;
  final String walletType;

  Map<String, dynamic> toJson() => _$WalletConnectRequestToJson(this);
}

/// Discord authentication request
@JsonSerializable()
class DiscordAuthRequest {

  const DiscordAuthRequest({
    required this.code,
    required this.redirectUri,
    this.guildId,
  });

  factory DiscordAuthRequest.fromJson(Map<String, dynamic> json) =>
      _$DiscordAuthRequestFromJson(json);
  final String code;
  final String redirectUri;
  final String? guildId;

  Map<String, dynamic> toJson() => _$DiscordAuthRequestToJson(this);
}

/// Guest session request
@JsonSerializable()
class GuestSessionRequest {

  const GuestSessionRequest({
    required this.deviceId,
    this.username,
    this.metadata,
  });

  factory GuestSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$GuestSessionRequestFromJson(json);
  final String deviceId;
  final String? username;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$GuestSessionRequestToJson(this);
}

/// Refresh token request
@JsonSerializable()
class RefreshTokenRequest {

  const RefreshTokenRequest({required this.refreshToken});

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
  final String refreshToken;

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}

/// Wallet verification request
@JsonSerializable()
class WalletVerificationRequest {

  const WalletVerificationRequest({
    required this.walletAddress,
    required this.signature,
    required this.message,
    required this.challenge,
  });

  factory WalletVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$WalletVerificationRequestFromJson(json);
  final String walletAddress;
  final String signature;
  final String message;
  final String challenge;

  Map<String, dynamic> toJson() => _$WalletVerificationRequestToJson(this);
}

/// Wallet verification response
@JsonSerializable()
class WalletVerificationResponse {

  const WalletVerificationResponse({
    required this.verified,
    this.error,
    this.metadata,
  });

  factory WalletVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletVerificationResponseFromJson(json);
  final bool verified;
  final String? error;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$WalletVerificationResponseToJson(this);
}
