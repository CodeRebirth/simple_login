import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreOperations {
  FireStoreOperations._();

  static final FireStoreOperations _instance = FireStoreOperations._();

  factory FireStoreOperations() {
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(Map<String, dynamic> userData) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: userData["password"],
      );

      final User user = userCredential.user!;
      userData.addAll({'id': user.uid});
      _firestore.collection('users').doc(user.uid).set(userData);
    } catch (err) {
      if (err is FirebaseAuthException) {
        log('Firebase Authentication Error: ${err.message}');
      } else {
        log('An unexpected error occurred: ${err.toString()}');
      }
      rethrow;
    }
  }
}
