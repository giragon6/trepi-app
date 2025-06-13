class UserEntity {
  final String providerId;
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;

  UserEntity({
    required this.providerId,
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });
}