import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
import 'package:trepi_app/features/authentication/data/models/user_model.dart';
import 'package:trepi_app/utils/result.dart';

class AuthenticationDataSource {
  AuthenticationDataSource();
  
  FirebaseAuth auth = FirebaseAuth.instance;
  
  Stream<Result<UserModel>> retrieveCurrentUser() {
    return auth.authStateChanges()
        .transform(_mainThreadTransformer())
        .map((User? user) {
          if (user != null) {
            return Result<UserModel>.ok(UserModel(
              providerId: user.providerData.isNotEmpty
                  ? user.providerData[0].providerId
                  : '',
              uid: user.uid,
              email: user.email ?? '',
              displayName: user.displayName ?? 'Anonymous',
              isEmailVerified: user.emailVerified,
              photoUrl: user.photoURL,
            ));
          } else {
            return Result<UserModel>.error(Exception('No user signed in'));
          }
        });
  }

  StreamTransformer<User?, User?> _mainThreadTransformer() {
    return StreamTransformer<User?, User?>.fromHandlers(
      handleData: (User? user, EventSink<User?> sink) {
        // Ensure we're on the main thread
        scheduleMicrotask(() => sink.add(user));
      },
      handleError: (error, stackTrace, EventSink<User?> sink) {
        scheduleMicrotask(() => sink.addError(error, stackTrace));
      },
    );
  }
 
  Future<Result<UserCredential>> signUp(String email, String password, String? displayName, DateTime? dob) async {
    // TODO: Store date of birth
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
          verifyEmail();
      User? user = userCredential.user;
      if (displayName != null && user != null) user.updateDisplayName(displayName);
      return Result.ok(userCredential);
    } on FirebaseAuthException catch (e) {
      return Result.error(FirebaseAuthException(code: e.code, message: e.message));
    } catch (e) {
      return Result.error(Exception('Sign up failed: $e'));
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
    // debugPrint('User is verified?: ${user != null ? user.emailVerified : 'No user'}');
    if (user != null && !user.emailVerified) {
      return await user.sendEmailVerification();
    }
  }

  Future<void> refreshCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
    }
  }
 
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}