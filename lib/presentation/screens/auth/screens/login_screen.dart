import 'package:flutter/material.dart';
import 'package:peveryone/core/constants/ui_helpers.dart';
import 'package:peveryone/presentation/screens/auth/screens/account_type_screen.dart';
import 'package:peveryone/presentation/widgets/app_big_button.dart';
import 'package:peveryone/presentation/widgets/app_text_button.dart';
import 'package:peveryone/presentation/widgets/app_text_field.dart';
import 'package:peveryone/presentation/widgets/auth_logos.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = true;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void passwordVisible() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(context, 0.03)),

                Center(
                  child: Text(
                    "Let's sign you in",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),

                SizedBox(height: height(context, 0.03)),

                Text(
                  'Email Address',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                SizedBox(height: height(context, 0.01)),

                AppTextField(
                  obscure: false,
                  hintText: 'Enter your email address',
                  textController: _emailController,
                ),
                SizedBox(height: height(context, 0.01)),

                SizedBox(height: height(context, 0.01)),
                Text(
                  'Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                SizedBox(height: height(context, 0.01)),

                AppTextField(
                  obscure: showPassword,
                  textController: _passwordController,
                  hintText: 'Enter your password',
                  suffixIcon: GestureDetector(
                    onTap: passwordVisible,
                    child: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: height(context, 0.02)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: false,
                          onChanged: (value) {},
                          activeColor: Theme.of(context).focusColor,
                        ),
                        Text(
                          'Remember Me',
                          style: TextStyle(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ],
                    ),
                    AppTextButton(
                      label: 'Forgot Password',
                      textColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: height(context, 0.02)),
                AppBigButton(
                  label: 'Next',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AccountTypeScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: height(context, 0.03)),

                Center(
                  child: AppTextButton(
                    label: "Don't have an account? Sign Up",
                    textColor: Theme.of(context).dividerColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: height(context, 0.03)),
                Center(
                  child: Text(
                    'Or Sign in with',
                    style: TextStyle(color: Theme.of(context).dividerColor),
                  ),
                ),
                SizedBox(height: height(context, 0.02)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AuthLogos(image: 'assets/images/google.png'),
                    AuthLogos(image: 'assets/images/apple.png'),
                    AuthLogos(image: 'assets/images/facebook.png'),
                  ],
                ),
                SizedBox(height: height(context, 0.1)),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'By signing up you agree to our Terms and \nConditions of Use',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
