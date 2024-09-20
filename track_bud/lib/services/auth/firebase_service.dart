import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/trackbud.dart';
import 'package:track_bud/views/at_signup/bank_account_info_screen.dart';
import 'package:track_bud/services/firestore_service.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService firestoreService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      debugPrint('firebase_service: signing in...');
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      debugPrint('firebase_service: successful sign in');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('firebase_service: signInWithEmailAndPassword sign in failed');
      throw Exception(e.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      debugPrint('firebase_service: try to sign up');
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      debugPrint('firebase_service: successful sign Up');

      // Erstellen Sie den Firestore-Datensatz für den neuen Benutzer
      await _createUserRecord(userCredential, name);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('firebase_service: signUpWithEmailAndPassword sign up failed');
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    debugPrint('firebase_service: signOut');
    return await _firebaseAuth.signOut();
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

      // Überprüfen Sie, ob der Benutzer neu ist und erstellen Sie gegebenenfalls einen Firestore-Datensatz
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _createUserRecord(
            userCredential, userCredential.user?.displayName ?? '');
      }

      if (context.mounted) await handlePostLogin(context, userCredential);
    } catch (error) {
      debugPrint('Error during Google sign in: $error');
      if (context.mounted) _showErrorSnackBar(context, error.toString());
    }
  }

  // Re-authenticate user
  Future<void> _reauthenticateUser(User user, String password) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);
    } catch (error) {
      debugPrint('Error during re-authentication: $error');
      rethrow;
    }
  }

  // Delete user from Firebase Authentication
  Future<void> _deleteUserFromAuth(User user) async {
    try {
      await user.delete();
    } catch (error) {
      debugPrint('Error deleting user: $error');
      rethrow;
    }
  }

  // Handle post-login actions
  Future<void> handlePostLogin(
      BuildContext context, UserCredential userCredential) async {
    String userId = userCredential.user!.uid;

    bool userExists = await checkUserExists(userId);
    if (!userExists) {
      await _createUserRecord(
          userCredential, userCredential.user?.displayName ?? '');
    }

    UserModel? userData = await firestoreService.getUserData(userId);

    if (userData != null) {
      if (userData.bankAccountBalance == -1 ||
          userData.monthlySpendingGoal == -1) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const BankAccountInfoScreen()));
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TrackBud()));
        }
      }
    } else {
      if (context.mounted) {
        _showErrorSnackBar(
            context, "Benutzerinformationen konnten nicht abgerufen werden.");
      }
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

  // Method to send a verification link for email update
  Future<void> sendEmailUpdateVerificationLink(
      String newEmail, String password) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      try {
        // Reauthenticate the user
        await _reauthenticateUser(user, password);

        // Temporarily store the new email in Firestore
        await firestoreService.storeNewEmail(user.uid, newEmail);

        // Create an action code settings to control the verification process
        ActionCodeSettings actionCodeSettings = ActionCodeSettings(
          url:
              'https://trackbud2.page.link/verify-email', // Replace with your dynamic link or app link
          handleCodeInApp: true,
          androidPackageName: 'com.example.track_bud',
          androidInstallApp: false,
          androidMinimumVersion: '12',
          iOSBundleId: 'com.example.trackBud',
        );

        // Send a verification email to the new email address
        await user.verifyBeforeUpdateEmail(newEmail, actionCodeSettings);

        debugPrint('Verification email sent to $newEmail.');
      } on FirebaseAuthException catch (e) {
        debugPrint('Error sending verification email: $e');
        rethrow;
      }
    } else {
      throw FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'User is not signed in.',
      );
    }
  }

  // After verification, update the user's email
  Future<void> updateEmailAfterVerification(
      String userId, String enteredPassword) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null && user.emailVerified) {
      try {
        // Retrieve the stored email from Firestore
        String? newEmail = await firestoreService.getPendingNewEmail(userId);

        if (newEmail != null) {
          // Re-authenticate the user before updating the email in Firebase Auth
          await _reauthenticateUser(user, enteredPassword);

          // Update the email in Firebase Auth
          await user.verifyBeforeUpdateEmail(newEmail);
          debugPrint('Email successfully updated to $newEmail.');

          // Update the email in Firestore
          await firestoreService.updateEmailInFirestore(userId, newEmail);
          debugPrint('Email successfully updated to $newEmail in Firestore.');

          // Clear the pending email in Firestore
          await firestoreService.clearPendingNewEmail(userId);
        } else {
          debugPrint('No pending email found.');
        }
      } on FirebaseAuthException catch (e) {
        debugPrint('Error updating email: $e');
        rethrow;
      }
    } else {
      debugPrint('User has not verified their email.');
    }
  }

  // Create user record in Firestore
  Future<void> _createUserRecord(
      UserCredential userCredential, String name) async {
    UserModel newUser = UserModel(
      userId: userCredential.user!.uid,
      email: userCredential.user!.email!,
      name: name,
      profilePictureUrl: userCredential.user!.photoURL ?? '',
      bankAccountBalance: -1,
      monthlySpendingGoal: -1,
      settings: {}, // Default settings oder vom Benutzer eingeben lassen
      friends: [],
    );

    await firestoreService.addUserIfNotExists(newUser);
  }

  Future<bool> checkUserExists(String userId) async {
    return await firestoreService.checkUserExists(userId);
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

      await firestoreService.addUserIfNotExists(newUser);
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
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Delete user account
  Future<void> deleteUserAccount(String password) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await _reauthenticateUser(user, password);
        await _deleteUserFromAuth(user);
        debugPrint('User account deleted successfully.');
      } catch (error) {
        debugPrint('Error deleting user account: $error');
        rethrow;
      }
    }
  }
}
