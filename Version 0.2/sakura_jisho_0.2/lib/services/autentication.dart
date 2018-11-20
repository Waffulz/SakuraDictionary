import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuth {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn googleSignIn = new GoogleSignIn();

  FirebaseUser firebaseUser;

  UserAuth(FirebaseUser user) {
    this.firebaseUser = user;
  }


  static Future<UserAuth> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return new UserAuth(user);
  }


}