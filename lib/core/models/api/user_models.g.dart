// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserProfile',
      json,
      ($checkedConvert) {
        final val = UserProfile(
          id: $checkedConvert('id', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String?),
          email: $checkedConvert('email', (v) => v as String?),
          walletAddress: $checkedConvert('walletAddress', (v) => v as String?),
          discordId: $checkedConvert('discordId', (v) => v as String?),
          avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
          status: $checkedConvert('status', (v) => v as String),
          isGuest: $checkedConvert('isGuest', (v) => v as bool),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          updatedAt:
              $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
          metadata:
              $checkedConvert('metadata', (v) => v as Map<String, dynamic>?),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'walletAddress': instance.walletAddress,
      'discordId': instance.discordId,
      'avatarUrl': instance.avatarUrl,
      'status': instance.status,
      'isGuest': instance.isGuest,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

UpdateProfileRequest _$UpdateProfileRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateProfileRequest',
      json,
      ($checkedConvert) {
        final val = UpdateProfileRequest(
          username: $checkedConvert('username', (v) => v as String?),
          email: $checkedConvert('email', (v) => v as String?),
          avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
          status: $checkedConvert('status', (v) => v as String?),
          metadata:
              $checkedConvert('metadata', (v) => v as Map<String, dynamic>?),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdateProfileRequestToJson(
        UpdateProfileRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'status': instance.status,
      'metadata': instance.metadata,
    };
