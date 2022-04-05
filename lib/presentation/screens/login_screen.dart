import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lucis/constants.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/login_viewmodel.dart';
import 'package:lucis/widgets/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:lucis/presentation/screens/base_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<LoginViewModel>(
      builder: (context, viewModel, child) => Scaffold(
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
          inAsyncCall: viewModel.status == Status.busy,
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
                  onChanged: (text) {
                    _email = text;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                    errorText: viewModel.isEmailError()
                        ? viewModel.message.description
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (text) {
                    _password = text;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                    errorText: viewModel.isPasswordError()
                        ? viewModel.message.description
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    color: kLoginButtonBackgroundColor,
                    text: 'Log In',
                    onPressed: () async {
                      if (_email != null && _password != null) {
                        await viewModel.login(
                          email: _email!,
                          password: _password!,
                        );
                        if (viewModel.status == Status.ready) {
                          await Navigator.pushNamed(
                            context,
                            '/splash',
                          );
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
