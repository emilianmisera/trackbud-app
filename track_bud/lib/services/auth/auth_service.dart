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
      return userCredential; // Return the user credential on success
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code); // Throw an error if sign in fails
    }
  }

  // Method to create a new user account using email and password
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to create a new user with the provided email and password
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential; // Return the user credential on success
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code); // Throw an error if account creation fails
    }
  }

  // SignOut
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
