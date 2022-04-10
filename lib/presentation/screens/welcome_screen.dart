import 'package:flutter/material.dart';
import 'package:lucis/presentation/components/rounded_button.dart';
import 'package:lucis/utils/constants.dart';
import 'package:lucis/presentation/routes.dart';

class WelcomeScreen extends StatefulWidget {
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
                Navigator.pushNamed(
                  context,
                  Routes.loginScreen,
                );
              },
            ),
            RoundedButton(
              color: kRegisterButtonBackgroundColor,
              text: 'Register',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.registrationScreen,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
