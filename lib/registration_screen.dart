import 'package:chat_app/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'utilities/dialogues.dart';
import 'rounded_button.dart';
import 'constants.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
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
          horizontal: 24,
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
                    'images/logo.png',
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
              title: 'Register',
              colour: Colors.blueAccent,
              onPressed: () async {
                // setState(() {
                //   showSpinner = true;
                // });
                try {
                  final email = _email.text;
                  final password = _password.text;

                  await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    ChatScreen.id,
                    (route) => false,
                  );
                }

                // setState(() {
                //   showSpinner = false;
                // });
                // } catch (e) {
                //   await showErrorDialog(context, e.toString());
                catch (e) {
                  await showErrorDialog(context, e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
