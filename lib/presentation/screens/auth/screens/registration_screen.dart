import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/core/constants/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/providers/general_providers/loading_providers/register_loading.dart';
 import 'package:peveryone/presentation/screens/auth/screens/login_screen.dart';
 import 'package:peveryone/presentation/widgets/app_big_button.dart';
import 'package:peveryone/presentation/widgets/app_text_button.dart';
import 'package:peveryone/presentation/widgets/app_text_form_field.dart';
import 'package:peveryone/presentation/widgets/auth_logos.dart';
import 'package:peveryone/presentation/widgets/loading_overlay.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  static const routeName = '/registration-screen';
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  void register() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final loading = ref.read(registrationLoadingProvider.notifier);
      loading.state = true;
      final auth = ref.read(authRepositoryProvider);
      final user = await auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      loading.state = false;
      if (user != null && context.mounted) {
        await auth.sendEmailVerification(user);
        Navigator.pushReplacementNamed(
          context,
          '/verify-email',
        );
      } else {
        loading.state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.read(registrationLoadingProvider);
    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height(context, 0.03)),
                    Center(
                      child: Text(
                        "Let's sign you up",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                    AppTextFormField(
                      validator: validateEmail,
                      obscure: false,
                      hintText: 'Enter your email address',
                      textController: _emailController,
                    ),

                    SizedBox(height: height(context, 0.01)),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    SizedBox(height: height(context, 0.01)),
                    AppTextFormField(
                      validator: validatePassword,
                      obscure: showPassword,
                      textController: _passwordController,
                      hintText: 'Enter your password',
                      suffixIcon: GestureDetector(
                        onTap: passwordVisible,
                        child: Icon(
                          showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: height(context, 0.02)),
                    AppBigButton(label: 'Sign up', onPressed: register),
                    SizedBox(height: height(context, 0.03)),
                    Center(
                      child: AppTextButton(
                        onTap: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        label: "Already have an account? Sign In",
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
                    SizedBox(height: height(context, 0.03)),
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
        ),
      ),
    );
  }
}
