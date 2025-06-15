import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
import 'package:trepi_app/features/authentication/data/models/user_model.dart';
import 'package:trepi_app/utils/result.dart';

class AuthenticationDataSource {
  AuthenticationDataSource();
  
  // TODO: decouple these
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
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
        scheduleMicrotask(() => sink.add(user));
      },
      handleError: (error, stackTrace, EventSink<User?> sink) {
        scheduleMicrotask(() => sink.addError(error, stackTrace));
      },
    );
  }
 
  Future<Result<UserCredential>> signUp(String email, String password, String? displayName, DateTime? dob) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (displayName != null && user != null) await user.updateDisplayName(displayName);
      await _firestore.collection('users').doc(user?.uid).set({
        'email': email,
        'displayName': displayName ?? 'Anonymous',
        'dob': dob,
      });
      return Result.ok(userCredential);
    } on PlatformException catch (e) {
      return Result.error(Exception('Firebase error during sign up: $e'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Result.error(Exception('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        return Result.error(Exception('The account already exists for that email.'));
      } else {
        return Result.error(Exception('Sign up failed: ${e.message}'));
      }

    } catch (e) {
      return Result.error(Exception('Sign up failed: $e'));
    }
  }
  Future<Result<UserCredential>> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return Result.ok(userCredential);
    } catch (e) {
      return Result.error(Exception('Sign in failed: $e'));
    }
  }
 
  Future<Result<void>> verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return Result.ok(null);
      }
    } catch (e) {
      return Result.error(Exception('Failed to send verification email: $e'));
    }
    return Result.error(Exception('No user signed in or email already verified'));
  }

  Future<void> refreshCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
    }
  }

  Future<Result<bool>> checkEmailVerificationStatus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        return Result.ok(user.emailVerified);
      }
      return Result.error(Exception('No user signed in'));
    } catch (e) {
      return Result.error(Exception('Failed to check email verification: $e'));
    }
  }
 
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}