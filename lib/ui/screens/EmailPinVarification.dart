import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/ui/screens/SetPassword.dart';

import '../../widget/ScreenBackground.dart';
import '../utils/assets_path.dart';


class Emailpinvarification extends StatefulWidget {
  const Emailpinvarification({super.key});

  @override
  State<Emailpinvarification> createState() => _EmailpinvarificationState();
}

class _EmailpinvarificationState extends State<Emailpinvarification> {

  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(25),
            child: Form(
              key: _key,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'PIN Verification',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                   Text(Variables.notifyemail,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                   ),

                  const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        obscureText: true, // make it false to show digits
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                    ),
                          ),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) => _onChanged(value, index),
                      ),
                    );
                  }),
                ),

                  const SizedBox(height: 16),

                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              // Handle email verification logic here
                              // For example, send a verification code to the email
                              await ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Verification email sent!')),
                              );
                              await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Setpassword()));
                            }
                          },
                          child: Text('Verify'),
                        ),

                        const SizedBox(height: 8),

                        RichText(
                          text: TextSpan(
                            text: 'Have account? ',
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
                                  ..onTap = _onTapSignInButton,
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

  void _onTapSignInButton() {
  }

  void _onChanged(String value, int index) {

  }
}
