// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AuthResponse',
      json,
      ($checkedConvert) {
        final val = AuthResponse(
          accessToken: $checkedConvert('access_token', (v) => v as String),
          refreshToken: $checkedConvert('refresh_token', (v) => v as String),
          tokenType: $checkedConvert('token_type', (v) => v as String),
          expiresIn: $checkedConvert('expires_in', (v) => (v as num).toInt()),
          userId: $checkedConvert('user_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'accessToken': 'access_token',
        'refreshToken': 'refresh_token',
        'tokenType': 'token_type',
        'expiresIn': 'expires_in',
        'userId': 'user_id'
      },
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'user_id': instance.userId,
    };

WalletConnectRequest _$WalletConnectRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'WalletConnectRequest',
      json,
      ($checkedConvert) {
        final val = WalletConnectRequest(
          walletAddress: $checkedConvert('walletAddress', (v) => v as String),
          signature: $checkedConvert('signature', (v) => v as String),
          message: $checkedConvert('message', (v) => v as String),
          walletType: $checkedConvert('walletType', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$WalletConnectRequestToJson(
        WalletConnectRequest instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'signature': instance.signature,
      'message': instance.message,
      'walletType': instance.walletType,
    };

DiscordAuthRequest _$DiscordAuthRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DiscordAuthRequest',
      json,
      ($checkedConvert) {
        final val = DiscordAuthRequest(
          code: $checkedConvert('code', (v) => v as String),
          redirectUri: $checkedConvert('redirectUri', (v) => v as String),
          guildId: $checkedConvert('guildId', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$DiscordAuthRequestToJson(DiscordAuthRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'redirectUri': instance.redirectUri,
      'guildId': instance.guildId,
    };

GuestSessionRequest _$GuestSessionRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GuestSessionRequest',
      json,
      ($checkedConvert) {
        final val = GuestSessionRequest(
          deviceId: $checkedConvert('deviceId', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String?),
          metadata:
              $checkedConvert('metadata', (v) => v as Map<String, dynamic>?),
        );
        return val;
      },
    );

Map<String, dynamic> _$GuestSessionRequestToJson(
        GuestSessionRequest instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'username': instance.username,
      'metadata': instance.metadata,
    };

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RefreshTokenRequest',
      json,
      ($checkedConvert) {
        final val = RefreshTokenRequest(
          refreshToken: $checkedConvert('refreshToken', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$RefreshTokenRequestToJson(
        RefreshTokenRequest instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
    };

WalletVerificationRequest _$WalletVerificationRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'WalletVerificationRequest',
      json,
      ($checkedConvert) {
        final val = WalletVerificationRequest(
          walletAddress: $checkedConvert('walletAddress', (v) => v as String),
          signature: $checkedConvert('signature', (v) => v as String),
          message: $checkedConvert('message', (v) => v as String),
          challenge: $checkedConvert('challenge', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$WalletVerificationRequestToJson(
        WalletVerificationRequest instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'signature': instance.signature,
      'message': instance.message,
      'challenge': instance.challenge,
    };

WalletVerificationResponse _$WalletVerificationResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'WalletVerificationResponse',
      json,
      ($checkedConvert) {
        final val = WalletVerificationResponse(
          verified: $checkedConvert('verified', (v) => v as bool),
          error: $checkedConvert('error', (v) => v as String?),
          metadata:
              $checkedConvert('metadata', (v) => v as Map<String, dynamic>?),
        );
        return val;
      },
    );

Map<String, dynamic> _$WalletVerificationResponseToJson(
        WalletVerificationResponse instance) =>
    <String, dynamic>{
      'verified': instance.verified,
      'error': instance.error,
      'metadata': instance.metadata,
    };
