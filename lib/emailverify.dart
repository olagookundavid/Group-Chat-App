import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

final _auth = FirebaseAuth.instance;
final user = _auth.currentUser;

class EmailVerificationScreen extends StatelessWidget {
  static const id = 'verifyemail';
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        title: const Text('Team Chat'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email Verification',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Just One More Step',
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(
                      color: Colors.black45,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                    speed: const Duration(milliseconds: 250),
                  ),
                ],
                totalRepeatCount: 100,
                pause: const Duration(milliseconds: 50),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Please verify your email : ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'We have sent a verification link to your email! \nclick on it to verify your email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await user?.sendEmailVerification();
                  },
                  child: const Text(
                    'Didn\'t receive any mail, click here to resend ',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Center(
                child: RoundedButton(
                  title: 'Go to chat dashboard',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
