import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'emailverify.dart';
import '../services/authentication.dart';
import '../utilities/dialogues.dart';
import '../utilities/rounded_button.dart';
import '../utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/screens/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool showSpinner = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        color: Colors.black45,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                      speed: const Duration(milliseconds: 250),
                    ),
                  ],
                  totalRepeatCount: 100,
                  pause: const Duration(milliseconds: 500),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Email',
                  )),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  controller: _password,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Password',
                  )),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Login',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final email = _email.text;
                    final password = _password.text;
                    Auth auth = Auth(email: email, password: password);
                    await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    if (auth.isVerified()) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          ChatScreen.id, (route) => false);
                    } else {
                      auth.sendEmailVerification();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        EmailVerificationScreen.id,
                        (route) => false,
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case 'invalid-email':
                      case 'wrong-password':
                        await showErrorDialog(
                            context, 'Wrong Credentials, Please Try Again');
                        break;
                      case 'user-disabled':
                      case 'user-not-found':
                        await showErrorDialog(context, 'User Doesn\'t Exist');
                        break;
                      case 'unknown':
                        await showErrorDialog(context,
                            'Email And Password Fields Can\'t Be Empty');
                        break;
                      case 'too-many-requests':
                        await showErrorDialog(context,
                            'You Have Pressed The Button Too Many Times, Try again Later');
                        break;
                      default:
                        await showErrorDialog(context, 'An Error Occured');
                    }
                  }
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, RegistrationScreen.id),
                child: const Text(
                  'Not Registered yet?,click here ',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
