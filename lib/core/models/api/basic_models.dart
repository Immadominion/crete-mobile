import 'package:json_annotation/json_annotation.dart';

part 'basic_models.g.dart';

@JsonSerializable()
class BasicResponse {

  BasicResponse({required this.message, required this.status});

  factory BasicResponse.fromJson(Map<String, dynamic> json) =>
      _$BasicResponseFromJson(json);
  final String message;
  final int status;

  Map<String, dynamic> toJson() => _$BasicResponseToJson(this);
}
