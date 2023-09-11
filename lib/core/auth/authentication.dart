import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  Authentication._();

  static final Authentication _instance = Authentication._();

  factory Authentication() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> loginUser(String email, String password) async {
    try {
      final data = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return data;
    } catch (err) {
      log(err.toString());
      if (err is FirebaseAuthException) {
        log('Firebase Authentication Error: ${err.message}');
      } else {
        // Handle other unanticipated exceptions
        log('An unexpected error occurred: ${err.toString()}');
      }
      rethrow;
    }
  }
}
