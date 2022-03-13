import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lucis/helpers/firebase_firestore_helper.dart';
import 'package:lucis/screens/splash_screen.dart';
import 'package:lucis/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:lucis/constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String route = 'registration-screen';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String? _email;
  String? _password;
  String? _userID;
  String? _userName;
  bool tagExists = false;

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
                height: 24.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _userName = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'User name'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _userID = value;
                },
                decoration: tagExists
                    ? kTextFieldDecoration.copyWith(
                        hintText: 'Tag already exists!',
                        hintStyle: const TextStyle(color: Colors.red),
                      )
                    : kTextFieldDecoration.copyWith(hintText: 'User tag'),
              ),
              const SizedBox(
                height: 8.0,
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
                color: kRegisterButtonBackgroundColor,
                text: 'Register',
                onPressed: () async {
                  if (_email != null &&
                      _password != null &&
                      _userID != null &&
                      _userName != null) {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      if (await FirebaseFirestoreHelper.userExists(_userID!)) {
                        tagExists = true;
                        return;
                      }
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: _email!, password: _password!);

                      await FirebaseFirestoreHelper.addAuth(
                          userID: _userID!, email: _email!);
                      await FirebaseFirestoreHelper.addNewUser(
                          userID: _userID!, userName: _userName!);

                      setState(() {
                        showSpinner = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SplashScreen(
                            userID: _userID!,
                          ),
                        ),
                      );
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      print(e);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
