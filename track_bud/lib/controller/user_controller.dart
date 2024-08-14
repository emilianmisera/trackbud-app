import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController {
  static Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();

    if (googleAccount == null) {
      return null;
    }

    final googleAuth = await googleAccount.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return UserCredential.user;
  }
}
