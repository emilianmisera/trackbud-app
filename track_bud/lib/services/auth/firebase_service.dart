import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      debugPrint('firebase_service: signing in...');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      debugPrint('firebase_service: successful sign in');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('firebase_service: signInWithEmailAndPassword sign in failed');
      throw Exception(e.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      debugPrint('firebase_service: try to sign up');
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      debugPrint('firebase_service: successful sign Up');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('firebase_service: signUpWithEmailAndPassword sign up failed');
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    debugPrint('firebase_service: signOut');
    return await _auth.signOut();
  }
}
