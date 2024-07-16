import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/core/external/firebase.dart';
import 'package:crypto_app/core/failure/failure.dart';
import 'package:crypto_app/core/logger/custom_logger.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authService = Provider<AuthService>(AuthServiceImpl.fromRef);

abstract class AuthService {
  Future<User?> getAuth();
  Stream<User?> authStateChanges();
  Future<void> register(RegisterModel model);
  Future<void> updateUser(UpdateUser user);
  Future<UserModel> getUser();
}

class AuthServiceImpl implements AuthService {
  const AuthServiceImpl({required this.userRef, required this.auth});
  static const logger = Logger(name: 'AuthService');

  factory AuthServiceImpl.fromRef(Ref ref) {
    return AuthServiceImpl(
      auth: ref.read(firebaseAuthProvider),
      userRef: ref.read(userRefFirestore),
    );
  }

  final FirebaseAuth auth;
  final DocumentReference<UserModel> userRef;

  @override
  Future<User?> getAuth() async => auth.currentUser;

  @override
  Stream<User?> authStateChanges() => auth.authStateChanges();

  @override
  Future<void> register(RegisterModel model) async {
    try {
      // Register user FirebaseAuth
      final authRes = await _createUserFirebase(model);
      logger.info('User using firebase: $authRes');
      // Add user to firestore
      await userRef.set(model);
      logger.info('User registered: ${authRes.user?.email}');
    } catch (e, s) {
      logger.error('Error registering user', e, s);
      throw const Failure('An error occurred while registering');
    }
  }

  Future<UserCredential> _createUserFirebase(RegisterModel model) async {
    try {
      // Register user FirebaseAuth
      final authRes = await auth.createUserWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );
      logger.info('User registered using firebase: ${authRes.user?.email}');
      await authRes.user?.updateDisplayName(model.name);
      return authRes;
    } on FirebaseAuthException catch (e, s) {
      logger.error('Error registering user: ${e.code}', e, s);
      log('Error registering user: ${e.code}');
      late String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = 'An error occurred while registering';
      }
      throw Failure(message);
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final user = await userRef.get();
      return user.data()!;
    } catch (e, s) {
      logger.error('Error getting user', e, s);
      throw const Failure('An error occurred while getting user');
    }
  }

  @override
  Future<void> updateUser(UpdateUser user) async {
    try {
      if (user.password != null) await auth.currentUser?.updatePassword(user.password!);
      await userRef.update(user.toMap());
    } catch (e, s) {
      logger.error('Error updating user', e, s);
      throw const Failure('An error occurred while updating user');
    }
  }
}
