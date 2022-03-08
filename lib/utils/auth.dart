import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<GoogleSignInAccount?> getSignedInAccount(
    GoogleSignIn googleSignIn) async {
  // Is the user already signed in?
  GoogleSignInAccount? account = googleSignIn.currentUser;
  // Try to sign in the previous user:
  account ??= await googleSignIn.signInSilently();
  return account;
}

Future<User> signIntoFirebase(GoogleSignInAccount? googleSignInAccount) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
  final User user = userCredential.user!;
  return user;
}
