import 'package:json_annotation/json_annotation.dart';

part 'dao_models.g.dart';

/// DAO information model
@JsonSerializable()
class DaoInfo {

  const DaoInfo({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.websiteUrl,
    this.discordUrl,
    required this.treasuryAddress,
    required this.memberCount,
    required this.isPublic,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory DaoInfo.fromJson(Map<String, dynamic> json) =>
      _$DaoInfoFromJson(json);
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? websiteUrl;
  final String? discordUrl;
  final String treasuryAddress;
  final int memberCount;
  final bool isPublic;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$DaoInfoToJson(this);
}

/// DAO member model
@JsonSerializable()
class DaoMember {

  const DaoMember({
    required this.id,
    required this.userId,
    required this.daoId,
    required this.role,
    required this.status,
    required this.joinedAt,
    this.permissions,
  });

  factory DaoMember.fromJson(Map<String, dynamic> json) =>
      _$DaoMemberFromJson(json);
  final String id;
  final String userId;
  final String daoId;
  final String role;
  final String status;
  final DateTime joinedAt;
  final Map<String, dynamic>? permissions;

  Map<String, dynamic> toJson() => _$DaoMemberToJson(this);
}
