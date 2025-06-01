import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/providers/general_providers/auth_loader.dart';
import 'package:peveryone/presentation/screens/auth/views/registration_view.dart';
import 'package:peveryone/presentation/widgets/app_big_button.dart';
import 'package:peveryone/presentation/widgets/app_text_button.dart';
import 'package:peveryone/presentation/widgets/app_text_form_field.dart';
import 'package:peveryone/presentation/widgets/auth_logos.dart';
import 'package:peveryone/presentation/widgets/loading_overlay.dart';

class LoginView extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
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

  void login() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final loading = ref.read(AuthLoader.loginLoadingProvider.notifier);
      loading.state = true;
      final auth = ref.read(authRepositoryProvider);
      final user = await auth.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      loading.state = false;
      if (user != null) {
        // Case 1: User exists, check email verification
        if (!user.emailVerified) {
          // If the user has not verified their email, send verification email and navigate to the verification screen
          await auth.sendEmailVerification(user);
          Navigator.pushReplacementNamed(context, '/verify-email');
        } else {
          // If the user has verified their email, navigate to the main view
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/base-view',
            (route) => false,
          );
        }
      } else {
        loading.state = false;
        return;
      }
    }
  }

  void googleSignIn() async {
    final loading = ref.read(AuthLoader.registrationLoadingProvider.notifier);
    loading.state = true;
    final auth = ref.read(authRepositoryProvider);
    final user = await auth.signInWithGoogle();
    loading.state = false;
    if (user != null && context.mounted) {
      Navigator.pushReplacementNamed(context, '/base-view');
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(AuthLoader.loginLoadingProvider);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height(context, 0.03)),

                    Center(
                      child: Text(
                        "Let's sign you in",
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
                      validator:
                          (value) =>
                              validateField(value: value, fieldName: 'Email'),
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
                      validator:
                          (value) => validatePassword(
                            value: value,
                            fieldName: 'Password',
                          ),
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
                    AppTextButton(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      label: 'Forgot Password?',
                      textColor: Colors.black,
                    ),
                    SizedBox(height: height(context, 0.03)),
                    AppBigButton(label: 'Login', onPressed: login),
                    SizedBox(height: height(context, 0.03)),

                    AuthLogos(
                      onTap: googleSignIn,
                      label: 'Log in with',
                      image: 'assets/images/google.png',
                    ),
                    SizedBox(height: height(context, 0.02)),

                    Center(
                      child: AppTextButton(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RegistrationView.routeName,
                          );
                        },
                        richLabel: TextSpan(
                          text: "Don't have an account?",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "  Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hoverColor,
                              ),
                            ),
                          ],
                        ),
                        textColor: Theme.of(context).dividerColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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
