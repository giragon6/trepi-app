import 'package:firebase_auth/firebase_auth.dart';
import 'package:trepi_app/features/authentication/data/models/user_model.dart';
import 'package:trepi_app/utils/result.dart';

class AuthenticationDataSource {
  AuthenticationDataSource();
  
  FirebaseAuth auth = FirebaseAuth.instance;
  
  Stream<Result<UserModel>> retrieveCurrentUser() {
    return auth.authStateChanges().map((User? user) {
      if (user != null) {
        return Result<UserModel>.ok(UserModel(
          providerId: user.providerData.isNotEmpty
              ? user.providerData[0].providerId
              : '',
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'Anonymous',
          photoUrl: user.photoURL,
        ));
      } else {
        return Result<UserModel>.error(Exception('No user signed in'));
      }
    });
  }
 
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
          verifyEmail();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }
 
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }
 
  Future<void> verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      return await user.sendEmailVerification();
    }
  }
 
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}