import 'package:trepi_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:trepi_app/utils/result.dart';

class VerifyEmail {
  final AuthenticationRepository _authenticationRepository;

  VerifyEmail(this._authenticationRepository);

  Future<Result<void>> sendVerifyEmail() async {
    return _authenticationRepository.verifyEmail();
  }

  Future<Result<bool>> checkEmailVerificationStatus() async {
    return await _authenticationRepository.checkEmailVerificationStatus();
  }
}