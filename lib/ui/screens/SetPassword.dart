import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/Model/Email_Verification_Data_Model.dart';
import 'package:task_manager/ui/screens/Sign_in_screen.dart';
import 'package:task_manager/ui/utils/assets_path.dart';
import 'package:task_manager/widget/Center_circular_progress_bar.dart';

import '../../Network/network_caller.dart';
import '../../widget/ScreenBackground.dart';
import '../../widget/Snackbar_Messages.dart';
import '../utils/urls.dart';


class Setpassword extends StatefulWidget {
  const Setpassword({super.key});

  static const String name = '/setpassword';

  @override
  State<Setpassword> createState() => _SetpasswordState();
}

class _SetpasswordState extends State<Setpassword> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmpasswordController = TextEditingController();
  bool _resetPasswordInProgress = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 8),
                  Text(
                    Variables.notifypassword,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _ConfirmpasswordController,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }else if(_passwordController.text != _ConfirmpasswordController.text){
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _resetPasswordInProgress== false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          _resetPassword();
                        }
                      },
                      child: Text('Confirm'),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: Column(
                      children: [
                       

                        RichText(
                          text: TextSpan(
                            text: 'have an account? ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapSignUpButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignUpButton() {
  }


  Future<void> _resetPassword() async {
    _resetPasswordInProgress = true;
    if(mounted){
      setState(() {});
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> requestBody = {
      "email": prefs.getString('email') ?? '',
      "OTP": prefs.getString('UserOtp') ?? '',
      "password": _ConfirmpasswordController.text,
    };
    NetworkResponse response = await networkCaller.postRequest(
      url: urls.ResetPasswordUrl,
      body: requestBody,
      isFromLogin: false,
    );

    if (response.isSuccess) {
      EmailVerificationDataModel emailVerificationDataModel =
      EmailVerificationDataModel.fromJson(response.body!);

      String getStatus = emailVerificationDataModel.status ?? '';
      String getData = emailVerificationDataModel.data ?? '';

      if (getStatus == 'success') {
        _resetPasswordInProgress = false;
        if (mounted) {
          _passwordController.clear();
          _ConfirmpasswordController.clear();
          showSnackBarMessage(context, "$getStatus $getData");
          showSnackBarMessage(context, 'Please Sign In With New Password');
          await Future.delayed(Duration(seconds: 1));
          await Navigator.pushNamedAndRemoveUntil(
            context,
            SignInScreen.name,
                (predicate) => false,
          );
        }
      } else {
        if (mounted) {
          _resetPasswordInProgress = false;
          showSnackBarMessage(context, "$getStatus $getData");
        }
      }
    } else {
      if (mounted) {
        _resetPasswordInProgress = false;
        showSnackBarMessage(context, response.errorMessage!);
      }
    }

    _resetPasswordInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose(){
    _passwordController.dispose();
    super.dispose();
  }
}
