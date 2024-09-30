import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/trackbud.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/views/at_signup/set_bank_account_screen.dart';
import 'package:track_bud/services/firestore_service.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; // Firebase authentication instance.
  final FirestoreService firestoreService = FirestoreService(); // Firestore service for database operations.
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Google Sign-In instance.

  // Sign in using email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      debugPrint('firebase_service: signing in...');
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      debugPrint('firebase_service: successful sign in');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('firebase_service: signInWithEmailAndPassword sign in failed');
      throw Exception(e.code); // Throw an exception with error code in case of failure.
    }
  }

  // Sign up using email and password
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      debugPrint('firebase_service: try to sign up');
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      debugPrint('firebase_service: successful sign up');

      // Create a Firestore record for the newly signed-up user.
      await _createUserRecord(userCredential, name);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('firebase_service: signUpWithEmailAndPassword sign up failed');
      throw Exception(e.code); // Throw an exception with error code in case of failure.
    }
  }

  // Sign out from Firebase authentication.
  Future<void> signOut() async {
    debugPrint('firebase_service: signOut');
    return await _firebaseAuth.signOut();
  }

  // Handle Google Sign-In.
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn(); // Trigger Google Sign-In.
      if (googleUser == null) {
        // If the user cancels the Google sign-in process, throw an error.
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

      // Sign in to Firebase using Google credentials.
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      // If the user is new, create a Firestore record for them.
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _createUserRecord(userCredential, userCredential.user?.displayName ?? '');
      }

      // Handle actions that should occur after logging in.
      if (context.mounted) await handlePostLogin(context, userCredential);
    } catch (error) {
      debugPrint('Error during Google sign in: $error');
      if (context.mounted) _showErrorSnackBar(context, error.toString()); // Display error message if sign-in fails.
    }
  }

  // Re-authenticate user
  /*Future<void> reauthenticateUser(String password) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        final credential = EmailAuthProvider.credential(email: user.email!, password: password);
        await user.reauthenticateWithCredential(credential);
      } catch (error) {
        debugPrint('Error during re-authentication: $error');
        rethrow;
      }
    } else {
      throw Exception('No user signed in');
    }
  }

   Future<void> deleteUserAccount() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        // Delete user data from Firestore
        await firestoreService.deleteUserData(user.uid);
        
        // Delete user from Firebase Authentication
        await user.delete();
        
        debugPrint('User account deleted successfully.');
      } catch (error) {
        debugPrint('Error deleting user account: $error');
        rethrow;
      }
    } else {
      throw Exception('No user signed in');
    }
  } */

  // Handle actions to take after the user successfully logs in.
  Future<void> handlePostLogin(BuildContext context, UserCredential userCredential) async {
    String userId = userCredential.user!.uid;

    // Check if the user already exists in Firestore.
    bool userExists = await checkUserExists(userId);
    if (!userExists) {
      // If user does not exist, create a Firestore record for the user.
      await _createUserRecord(userCredential, userCredential.user?.displayName ?? '');
    }

    // Fetch user data from Firestore.
    UserModel? userData = await firestoreService.getUserData(userId);

    if (userData != null) {
      // If the user has not set a bank account balance or spending goal, redirect to bank account setup screen.
      if (userData.bankAccountBalance == -1 || userData.monthlySpendingGoal == -1) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BankAccountInfoScreen()));
        }
      } else {
        // Otherwise, proceed to the main application screen.
        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const TrackBud()));
        }
      }
    } else {
      // If user data cannot be retrieved, show an error.
      if (context.mounted) {
        _showErrorSnackBar(context, "Benutzerinformationen konnten nicht abgerufen werden.");
      }
    }
  }

  /* // Check if email is verified
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
        await firestoreService.storeNewEmail(user.uid, newEmail);

        // Create an action code settings to control the verification process
        ActionCodeSettings actionCodeSettings = ActionCodeSettings(
          url: 'https://trackbud2.page.link/verify-email', // Replace with your dynamic link or app link
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
  Future<void> updateEmailAfterVerification(String userId, String enteredPassword) async {
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
  } */

  // Create a new Firestore record for the user.
  Future<void> _createUserRecord(UserCredential userCredential, String name) async {
    UserModel newUser = UserModel(
      userId: userCredential.user!.uid,
      email: userCredential.user!.email!,
      name: name,
      profilePictureUrl: userCredential.user!.photoURL ?? '',
      bankAccountBalance: -1, // Default value indicating the balance is not yet set.
      monthlySpendingGoal: -1, // Default value indicating the spending goal is not yet set.
      settings: {}, // Placeholder for future user settings.
      friends: [],
    );

    // Add the new user to Firestore if they don't already exist.
    await firestoreService.addUserIfNotExists(newUser);
  }

  // Check if the user exists in Firestore.
  Future<bool> checkUserExists(String userId) async {
    return await firestoreService.checkUserExists(userId);
  }

  // Display a snack bar with an error message.
  void _showErrorSnackBar(BuildContext context, String message) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
      ),
    );
  }

  /* // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  } */
}
