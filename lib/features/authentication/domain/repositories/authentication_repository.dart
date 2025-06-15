import 'package:firebase_auth/firebase_auth.dart' show UserCredential;
import 'package:trepi_app/features/authentication/domain/entities/user_entity.dart';
import 'package:trepi_app/utils/result.dart';

abstract class AuthenticationRepository {
  Stream<Result<UserEntity>> getCurrentUser();
  
  Future<Result<UserCredential>> signInWithEmailAndPassword(String email, String password);
  Future<Result<void>> signUp(String email, String password, String? displayName, DateTime? dob);
  Future<Result<void>> signOut();
  Future<Result<void>> refreshCurrentUser();
  Future<Result<void>> verifyEmail();
  Future<Result<bool>> checkEmailVerificationStatus();
}