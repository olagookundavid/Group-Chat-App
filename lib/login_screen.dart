import 'package:chat_app/registration_screen.dart';
import 'package:flutter/material.dart';
import 'emailverify.dart';
import 'utilities/dialogues.dart';
import 'rounded_button.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/chat_screen.dart';

final _auth = FirebaseAuth.instance;
final user = _auth.currentUser;

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return Scaffold(
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
              child: Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset(
                    'images/bestteam.png',
                  ),
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
              title: 'Login',
              colour: Colors.lightBlueAccent,
              onPressed: () async {
                try {
                  final email = _email.text;
                  final password = _password.text;

                  await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  if (user?.emailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        ChatScreen.id, (route) => false);
                  } else {
                    await user?.sendEmailVerification();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      EmailVerificationScreen.id,
                      (route) => false,
                    );
                  }
                } catch (e) {
                  await showErrorDialog(context, e.toString());
                }
                // on FirebaseAuthException{
                //   switch (e) {
                //     case :

                //       break;
                //     default:
                //   }
                // }
              },
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RegistrationScreen.id),
              child: const Text(
                'Not Registered yet?,click here ',
              ),
            )
          ],
        ),
      ),
    );
  }
}
