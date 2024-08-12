import "package:firebase_auth/firebase_auth.dart";

// for handling authentication with Firebase
class AuthService {
  // Create an instance of FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Method to sign in a user using email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to sign in the user with the provided email and password
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if the email is verified
      if (userCredential.user?.emailVerified ?? false) {
        // If email is verified, return the user credential
        return userCredential;
      } else {
        // If email is not verified, sign out the user and throw an error
        await signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email address before signing in.',
        );
      }
    } on FirebaseAuthException catch (error) {
      // Re-throw the FirebaseAuthException to handle it elsewhere
      throw error;
    }
  }

  // Method to create a new user account using email and password
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to create a new user with the provided email and password
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Send email verification after account creation
      await userCredential.user?.sendEmailVerification();
      return userCredential; // Return the user credential on success
    } on FirebaseAuthException catch (error) {
      throw error; // Throw an error if account creation fails
    }
  }

  // Method to send a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Send a password reset email
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      // Handle errors such as invalid email
      throw error;
    }
  }

  // SignOut
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
