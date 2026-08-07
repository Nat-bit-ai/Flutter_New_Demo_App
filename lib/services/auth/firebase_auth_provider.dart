import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_app/services/auth/auth_provider.dart';
import 'package:flutter_app/services/auth/auth_user.dart';
import 'package:flutter_app/services/auth/auth_exceptions.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

@override
Future<AuthUser> logIn({
  required String email,
  required String password,
}) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = currentUser;
    if (user != null) {
      return user;
    } else {
      throw UserNotLoggedInAuthException();
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw UserNotFoundAuthException();
    } else if (e.code == 'wrong-password') {
      throw WrongPasswordAuthException();
    } else if (e.code == 'invalid-credential' ||
        e.code == 'invalid-login-credentials') {
      // Newer Firebase Auth versions merge "no such user" and
      // "wrong password" into this single code for security reasons.
      throw UserNotFoundAuthException();
    } else if (e.code == 'invalid-email') {
      throw InvalidEmailAuthException();
    } else if (e.code == 'network-request-failed') {
      // ignore: avoid_print
      print(
        'network-request-failed details -> message: ${e.message}, '
        'plugin: ${e.plugin}, stackTrace: ${e.stackTrace}',
      );
      throw GenericAuthException(
        'Network error (network-request-failed). Check your internet '
        'connection / emulator DNS settings.',
      );
    } else {
      // ignore: avoid_print
      print('Unhandled FirebaseAuthException code: ${e.code} - ${e.message}');
      throw GenericAuthException('${e.code}: ${e.message}');
    }
  } catch (e) {
    // ignore: avoid_print
    print('Unhandled login error: $e');
    throw GenericAuthException(e.toString());
  }
}

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        // ignore: avoid_print
        print('Unhandled FirebaseAuthException code: ${e.code} - ${e.message}');
        throw GenericAuthException('${e.code}: ${e.message}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Unhandled sign-up error: $e');
      throw GenericAuthException(e.toString());
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}