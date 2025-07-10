// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dao_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DaoInfo _$DaoInfoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DaoInfo',
      json,
      ($checkedConvert) {
        final val = DaoInfo(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          imageUrl: $checkedConvert('imageUrl', (v) => v as String?),
          websiteUrl: $checkedConvert('websiteUrl', (v) => v as String?),
          discordUrl: $checkedConvert('discordUrl', (v) => v as String?),
          treasuryAddress:
              $checkedConvert('treasuryAddress', (v) => v as String),
          memberCount:
              $checkedConvert('memberCount', (v) => (v as num).toInt()),
          isPublic: $checkedConvert('isPublic', (v) => v as bool),
          status: $checkedConvert('status', (v) => v as String),
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

Map<String, dynamic> _$DaoInfoToJson(DaoInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'websiteUrl': instance.websiteUrl,
      'discordUrl': instance.discordUrl,
      'treasuryAddress': instance.treasuryAddress,
      'memberCount': instance.memberCount,
      'isPublic': instance.isPublic,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

DaoMember _$DaoMemberFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DaoMember',
      json,
      ($checkedConvert) {
        final val = DaoMember(
          id: $checkedConvert('id', (v) => v as String),
          userId: $checkedConvert('userId', (v) => v as String),
          daoId: $checkedConvert('daoId', (v) => v as String),
          role: $checkedConvert('role', (v) => v as String),
          status: $checkedConvert('status', (v) => v as String),
          joinedAt:
              $checkedConvert('joinedAt', (v) => DateTime.parse(v as String)),
          permissions:
              $checkedConvert('permissions', (v) => v as Map<String, dynamic>?),
        );
        return val;
      },
    );

Map<String, dynamic> _$DaoMemberToJson(DaoMember instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'daoId': instance.daoId,
      'role': instance.role,
      'status': instance.status,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'permissions': instance.permissions,
    };
