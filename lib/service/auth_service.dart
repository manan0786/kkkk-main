import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(
            (User user) => user?.uid,
      );

  // Email & Password Sign Up



  // Email & Password Sign In


  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }

  // Reset Password

  // Create Anonymous User
  Future singInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }



}

