import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void credentials;

  Future<void> storeUserDetails(String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection("users").doc(uid).set(userData);
    } catch (e) {
      print("Firestore Error: $e");
    }
  }
  /// **Create New User**
  Future<User?> createUserWithEmailAndPass(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      log("User created successfully: ${cred.user?.email}");
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Sign Up Error: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      log("Unexpected error in createUserWithEmailAndPass: ${e.toString()}");
      return null;
    }
  }

  /// **Login User**
  Future<User?> loginUserWithEmailAndPass(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      log("User logged in successfully: ${cred.user?.email}");
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log("Login Error: No user found with this email.");
      } else if (e.code == 'wrong-password') {
        log("Login Error: Incorrect password.");
      } else {
        log("FirebaseAuth Login Error: ${e.code} - ${e.message}");
      }
      return null;
    } catch (e) {
      log("Unexpected error in loginUserWithEmailAndPass: ${e.toString()}");
      return null;
    }
  }

  /// **Sign Out User**
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      log("User signed out successfully");
    } catch (e) {
      log("Sign Out Error: ${e.toString()}");
    }
  }
}
