// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicResponse _$BasicResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BasicResponse',
      json,
      ($checkedConvert) {
        final val = BasicResponse(
          message: $checkedConvert('message', (v) => v as String),
          status: $checkedConvert('status', (v) => (v as num).toInt()),
        );
        return val;
      },
    );

Map<String, dynamic> _$BasicResponseToJson(BasicResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
    };
