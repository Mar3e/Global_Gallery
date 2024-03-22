import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_gallery/state/auth/models/auth_state.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:global_gallery/state/posts/typedefs/user_id.dart';

class Authenticator {
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> logOut() async {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    FacebookAuth.instance.logOut();
  }

Future<AuthState>

}
