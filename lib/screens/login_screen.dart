import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lucis/constants.dart';
import 'package:lucis/helpers/firebase_firestore_helper.dart';
import 'package:lucis/screens/home_screen.dart';
import 'package:lucis/screens/splash_screen.dart';
import 'package:lucis/widgets/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const route = 'login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String? _email;
  String? _password;
  String? _userID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        progressIndicator: const SpinKitPumpingHeart(
          color: Colors.deepOrangeAccent,
        ),
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'MapLogo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('assets/images/map.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  color: kLoginButtonBackgroundColor,
                  text: 'Log In',
                  onPressed: () async {
                    if (_email != null && _password != null) {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        _userID = await FirebaseFirestoreHelper.getAuth(
                            email: _email!);

                        final userCredential =
                            await _auth.signInWithEmailAndPassword(
                                email: _email!, password: _password!);
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pushNamed(context, SplashScreen.route,
                            arguments: _userID);
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        print(e);
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
