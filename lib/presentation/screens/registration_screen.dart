import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lucis/presentation/components/rounded_button.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/registration_viewmodel.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:lucis/constants.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'package:lucis/presentation/routes.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? _email;
  String? _password;
  String? _userID;
  String? _userName;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<RegistrationViewModel>(
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
                  height: 24.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (text) {
                    _userName = text;
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
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Tag already exists!',
                    errorText: viewModel.isUserError()
                        ? viewModel.message.description
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
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
                    color: kRegisterButtonBackgroundColor,
                    text: 'Register',
                    onPressed: () async {
                      if (_email != null &&
                          _password != null &&
                          _userID != null &&
                          _userName != null) {
                        await viewModel.register(
                          userId: _userID!,
                          userName: _userName!,
                          email: _email!,
                          password: _password!,
                        );
                        if (viewModel.status == Status.ready) {
                          await Navigator.pushNamed(
                            context,
                            Routes.splashScreen,
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
