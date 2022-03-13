import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:lucis/widgets/rounded_button.dart';
import 'package:lucis/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const route = 'welcome-screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'MapLogo',
              child: SizedBox(
                child: Image.asset('assets/images/map.png'),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: kLoginButtonBackgroundColor,
              text: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.route);
              },
            ),
            RoundedButton(
              color: kRegisterButtonBackgroundColor,
              text: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.route);
              },
            ),
          ],
        ),
      ),
    );
  }
}
