import 'package:json_annotation/json_annotation.dart';

part 'user_models.g.dart';

/// User profile model
@JsonSerializable()
class UserProfile {

  const UserProfile({
    required this.id,
    this.username,
    this.email,
    this.walletAddress,
    this.discordId,
    this.avatarUrl,
    required this.status,
    required this.isGuest,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  final String id;
  final String? username;
  final String? email;
  final String? walletAddress;
  final String? discordId;
  final String? avatarUrl;
  final String status;
  final bool isGuest;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

/// Update profile request
@JsonSerializable()
class UpdateProfileRequest {

  const UpdateProfileRequest({
    this.username,
    this.email,
    this.avatarUrl,
    this.status,
    this.metadata,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
  final String? username;
  final String? email;
  final String? avatarUrl;
  final String? status;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
