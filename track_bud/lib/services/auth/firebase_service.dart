import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/trackbud.dart';
import 'package:track_bud/views/at_signup/bank_account_info_screen.dart';
import 'package:track_bud/views/at_signup/firestore_service.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //sign in
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      debugPrint('firebase_service: signing in...');
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      debugPrint('firebase_service: successful sign in');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('firebase_service: signInWithEmailAndPassword sign in failed');
      throw Exception(e.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      debugPrint('firebase_service: try to sign up');
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
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

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      await _handleNewGoogleUser(userCredential);
      await handlePostLogin(context, userCredential);
    } catch (error) {
      print('Error during Google sign in: $error');
      _showErrorSnackBar(context, error.toString());
    }
  }

  // Re-authenticate user
  Future<void> _reauthenticateUser(User user, String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: password);
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

  // Handle post-login actions
  Future<void> handlePostLogin(BuildContext context, UserCredential userCredential) async {
    String userId = userCredential.user!.uid;

    /*SyncService syncService = SyncService(
      SQLiteService(),
      FirestoreService(),
      CacheService(),
    ); //create instance of syncService

    await syncService.syncData(userId); //syncs data from firestore and local DB
*/
    UserModel? userData = await _firestoreService.getUserData(userId);

    if (userData != null) {
      if (userData.bankAccountBalance == -1 || userData.monthlySpendingGoal == -1) {
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
  Future<void> sendEmailUpdateVerificationLink(String newEmail, String password) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      try {
        // Reauthenticate the user
        await _reauthenticateUser(user, password);

        // Temporarily store the new email in Firestore
        await _firestoreService.storeNewEmail(user.uid, newEmail);

        // Create an action code settings to control the verification process
        ActionCodeSettings actionCodeSettings = ActionCodeSettings(
          url: 'https://yourapp.page.link/verify-email', // Replace with your dynamic link or app link
          handleCodeInApp: true,
          androidPackageName: 'com.yourapp.package',
          androidInstallApp: true,
          androidMinimumVersion: '12',
          iOSBundleId: 'com.yourapp.bundleid',
        );

        // Send a verification email to the new email address
        await user.verifyBeforeUpdateEmail(newEmail, actionCodeSettings);

        print('Verification email sent to $newEmail.');
      } on FirebaseAuthException catch (e) {
        print('Error sending verification email: $e');
        throw e;
      }
    } else {
      throw FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'User is not signed in.',
      );
    }
  }

  // After verification, update the user's email
  Future<void> updateEmailAfterVerification(String userId) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null && user.emailVerified) {
      try {
        // Retrieve the stored email from Firestore
        String? newEmail = await _firestoreService.getPendingNewEmail(userId);

        if (newEmail != null) {
          // Update the email in Firebase Auth
          await user.updateEmail(newEmail);
          print('Email successfully updated to $newEmail.');

          // Optionally, clear the pending email in Firestore
          await _firestoreService.clearPendingNewEmail(userId);
        } else {
          print('No pending email found.');
        }
      } on FirebaseAuthException catch (e) {
        print('Error updating email: $e');
        throw e;
      }
    } else {
      print('User has not verified their email.');
    }
  }

  // Create user record in Firestore
  Future<void> _createUserRecord(UserCredential userCredential, String name) async {
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

    await _firestoreService.addUserIfNotExists(newUser);
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

      await _firestoreService.addUserIfNotExists(newUser);
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
