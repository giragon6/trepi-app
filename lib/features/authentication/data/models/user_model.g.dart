// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  providerId: json['provider_id'] as String,
  uid: json['uid'] as String,
  displayName: json['display_name'] as String,
  email: json['email'] as String,
  isEmailVerified: json['is_email_verified'] as bool,
  photoUrl: json['photo_url'],
)..error = json['error'] as String?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'provider_id': instance.providerId,
  'uid': instance.uid,
  'display_name': instance.displayName,
  'email': instance.email,
  'is_email_verified': instance.isEmailVerified,
  'photo_url': instance.photoUrl,
  'error': instance.error,
};
