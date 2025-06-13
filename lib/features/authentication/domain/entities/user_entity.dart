class UserEntity {
  final String providerId;
  final String uid;
  final String displayName;
  final String email;
  final bool isEmailVerified;
  final String? photoUrl;

  UserEntity({
    required this.providerId,
    required this.uid,
    required this.displayName,
    required this.email,
    required this.isEmailVerified,
    this.photoUrl,
  });
}