import 'package:flutter/material.dart';
import 'rounded_button.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/team2background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Team Chat',
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
              const SizedBox(
                height: 48.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              RoundedButton(
                title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
