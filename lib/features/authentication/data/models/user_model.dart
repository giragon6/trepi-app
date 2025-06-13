import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trepi_app/features/authentication/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends UserEntity {
  UserModel({
    required String providerId,
    required String uid,
    required String displayName,
    required String email,
    photoUrl,
  }) : super(
          providerId: providerId,
          uid: uid,
          displayName: displayName,
          email: email,
          photoUrl: photoUrl,
        );

  String? error;

  UserModel.withError(String errorMessage)
  : super(
      providerId: '',
      uid: '',
      displayName: '',
      email: '',
      photoUrl: null,
    );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
    _$UserModelFromJson(json);

  factory UserModel.fromFirestore(Map<String, dynamic> data) => 
    UserModel.fromJson(data);

  factory UserModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }
    return UserModel.fromJson(data);
  }

  Map<String, dynamic> toJson() => 
    _$UserModelToJson(this);

  Map<String, dynamic> toFirestore() => 
    toJson();

}