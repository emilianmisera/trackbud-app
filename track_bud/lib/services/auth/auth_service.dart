import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/trackbud.dart';
import 'package:track_bud/views/at_signup/bank_account_info_screen.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      await _checkEmailVerification(userCredential);
      await handlePostLogin(context, userCredential);
    } on FirebaseAuthException catch (error) {
      _showErrorSnackBar(context, error.message ?? error.code);
    }
  }

  // Create a new user with email and password
  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _sendEmailVerification(userCredential);
      await _createUserRecord(userCredential, name);
      // Handle post login actions
      await handlePostLogin(context, userCredential);
    } on FirebaseAuthException catch (error) {
      _showErrorSnackBar(context, error.message ?? error.code);
    }
  }

  // Handle sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      await _handleNewGoogleUser(userCredential);
      await handlePostLogin(context, userCredential);
    } catch (error) {
      print('Error during Google sign in: $error');
      _showErrorSnackBar(context, error.toString());
    }
  }

  // Handle post-login actions
  Future<void> handlePostLogin(BuildContext context, UserCredential userCredential) async {
    String userId = userCredential.user!.uid;

    UserModel? userData = await _firestoreService.getUserData(userId);

    if (userData != null) {
      if (userData.bankAccountBalance == -1 ||
          userData.monthlySpendingGoal == -1) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BankAccountInfoScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TrackBud()),
        );
      }
    } else {
      _showErrorSnackBar(context, "Benutzerinformationen konnten nicht abgerufen werden.");
    }
  }

  // Re-authenticate user
  Future<void> _reauthenticateUser(User user, String password) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);
    } catch (error) {
      print('Error during re-authentication: $error');
      throw error;
    }
  }

  // Delete user from Firebase Authentication
  Future<void> _deleteUserFromAuth(User user) async {
    try {
      await user.delete();
    } catch (error) {
      print('Error deleting user: $error');
      throw error;
    }
  }

  // Check if email is verified
  Future<void> _checkEmailVerification(UserCredential userCredential) async {
    if (userCredential.user?.emailVerified ?? false) {
      return;
    } else {
      await signOut();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email address before signing in.',
      );
    }
  }

  // Send email verification
  Future<void> _sendEmailVerification(UserCredential userCredential) async {
    await userCredential.user?.sendEmailVerification();
  }

  // Create user record in Firestore
  Future<void> _createUserRecord(
      UserCredential userCredential, String name) async {
    UserModel newUser = UserModel(
      userId: userCredential.user!.uid,
      email: userCredential.user!.email!,
      name: name,
      profilePictureUrl: '', // Initial value, could be updated later
      bankAccountBalance: -1,
      monthlySpendingGoal: -1,
      settings: {}, // Default settings or get from user input
      friends: [],
    );

    await _firestoreService.addUser(newUser);
  }

  // Handle new Google user
  Future<void> _handleNewGoogleUser(UserCredential userCredential) async {
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      UserModel newUser = UserModel(
        userId: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName ?? '',
        profilePictureUrl: userCredential.user!.photoURL ?? '',
        bankAccountBalance: -1,
        monthlySpendingGoal: -1,
        settings: {}, // Default settings
        friends: [],
      );

      await _firestoreService.addUser(newUser);
    }
  }

  // Show error snackbar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw error;
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Delete user account
  Future<void> deleteUserAccount(String password) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await _reauthenticateUser(user, password);
        await _deleteUserFromAuth(user);
        print('User account deleted successfully.');
      } catch (error) {
        print('Error deleting user account: $error');
        throw error;
      }
    }
  }
}