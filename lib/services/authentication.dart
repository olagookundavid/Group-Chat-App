import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
final user = _auth.currentUser;

class Auth {
  final String email;
  final String password;

  Auth({required this.email, required this.password});

  Future<void> registerUser() async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    sendEmailVerification();
  }

  Future<void> sendEmailVerification() async {
    await user?.sendEmailVerification();
  }

  Future<void> logInUser() async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  bool isVerified() {
    if (user?.emailVerified ?? false) {
      return true;
    } else {
      return false;
    }
  }
}
