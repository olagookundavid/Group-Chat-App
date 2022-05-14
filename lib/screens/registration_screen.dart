import 'package:chat_app/screens/emailverify.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/authentication.dart';
import '../utilities/dialogues.dart';
import '../utilities/rounded_button.dart';
import '../utilities/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  late final TextEditingController _email;
  late final TextEditingController _password;

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
            horizontal: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset(
                    'images/download.png',
                  ),
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
                title: 'Register',
                colour: Colors.greenAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    Auth auth = Auth(email: email, password: password);
                    await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    auth.sendEmailVerification();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      EmailVerificationScreen.id,
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case 'email-already-in-use':
                        await showErrorDialog(
                            context, 'Account Already Exists');
                        break;
                      case 'invalid-email':
                        await showErrorDialog(
                            context, 'This Email Doesn\'t Exist');
                        break;
                      case 'weak-password':
                        await showErrorDialog(context, 'Password Is Weak');
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
                        await showErrorDialog(
                            context, 'An Error Occured, Please Try Again');
                    }
                  }
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
                child: const Text(
                  'Already Registered?,click here ',
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
