import 'package:firebase_auth/firebase_auth.dart';
import 'package:trepi_app/features/authentication/data/datasources/authentication_data_source.dart';
import 'package:trepi_app/features/authentication/domain/entities/user_entity.dart';
import 'package:trepi_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:trepi_app/utils/result.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationDataSource _dataSource;

  AuthenticationRepositoryImpl(AuthenticationDataSource dataSource)
      : _dataSource = dataSource;

  @override
  Stream<Result<UserEntity>> getCurrentUser() {
    return _dataSource.retrieveCurrentUser();
  }

  @override
  Future<Result<void>> signOut() async {
    return _dataSource.signOut().then(
      (value) => Result.ok(null),
      onError: (error) => Result.error(Exception('Sign out failed: $error')),
    );
  }

  @override
  Future<Result<void>> signUp(String email, String password, String? displayName, DateTime? dob) async {
    final result = await _dataSource.signUp(email, password, displayName, dob);

    switch (result) {
      case Ok():
        return Result.ok(null);
      case Error():
        return Result.error(Exception('Sign up failed: ${result.error}'));
    }
  }
  
  @override
  Future<Result<UserCredential>> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _dataSource.signInWithEmailAndPassword(email, password);
    if (userCredential == null) {
      return Result.error(Exception('Sign in failed'));
    }
    return userCredential;
  }

  @override
  Future<Result<void>> verifyEmail() async {
    return await _dataSource.verifyEmail();
  }

  @override
  Future<Result<void>> refreshCurrentUser() async { // TODO: make datasource return Result
    try {
      await _dataSource.refreshCurrentUser();
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('User refresh failed: $e'));
    }
  }

  Future<Result<bool>> checkEmailVerificationStatus() async {
    return await _dataSource.checkEmailVerificationStatus();
  }
}