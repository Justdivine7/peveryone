import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/providers/general_providers/auth_loader.dart';
import 'package:peveryone/presentation/screens/auth/views/login_view.dart';
import 'package:peveryone/presentation/widgets/app_big_button.dart';
import 'package:peveryone/presentation/widgets/app_text_button.dart';
import 'package:peveryone/presentation/widgets/app_text_form_field.dart';
import 'package:peveryone/presentation/widgets/auth_logos.dart';
import 'package:peveryone/presentation/widgets/loading_overlay.dart';

class RegistrationView extends ConsumerStatefulWidget {
  static const routeName = '/registration-screen';
  const RegistrationView({super.key});

  @override
  ConsumerState<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends ConsumerState<RegistrationView> {
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = true;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  void passwordVisible() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void googleSignIn() async {
    final loading = ref.read(AuthLoader.registrationLoadingProvider.notifier);
    loading.state = true;
    final auth = ref.read(authRepositoryProvider);
    final userCredential = await auth.signInWithGoogle();
    loading.state = false;
    if (userCredential?.user != null && context.mounted) {
      Navigator.pushReplacementNamed(context, '/base-view');
    } else {
      return null;
    }
  }

  void register() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final loading = ref.read(AuthLoader.registrationLoadingProvider.notifier);
      loading.state = true;
      final auth = ref.read(authRepositoryProvider);
      final user = await auth.signUp(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      loading.state = false;
      if (user != null && context.mounted) {
        await auth.sendEmailVerification(user);
        Navigator.pushReplacementNamed(context, '/verify-email');
      }else{
        loading.state= false;
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.read(AuthLoader.registrationLoadingProvider);
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
                      'First name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    SizedBox(height: height(context, 0.01)),
                    AppTextFormField(
                      validator:
                          (value) => validateField(
                            value: value,
                            fieldName: 'First name',
                          ),
                      obscure: false,
                      hintText: 'First name',
                      textController: _firstNameController,
                    ),
                    Text(
                      'Last name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    SizedBox(height: height(context, 0.01)),
                    AppTextFormField(
                      validator:
                          (value) => validateField(
                            value: value,
                            fieldName: 'Last name',
                          ),
                      obscure: false,
                      hintText: 'Last name',
                      textController: _lastNameController,
                    ),

                    SizedBox(height: height(context, 0.01)),
                    Text(
                      'Email address',
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
                      hintText: 'Email address',
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
                      hintText: 'Password',
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
                      child: AuthLogos(
                        onTap: googleSignIn,

                        label: 'Sign up with',
                        image: 'assets/images/google.png',
                      ),
                    ),
                    SizedBox(height: height(context, 0.03)),
                    Center(
                      child: AppTextButton(
                        onTap: () {
                          Navigator.pushNamed(context, LoginView.routeName);
                        },
                        richLabel: TextSpan(
                          text: "Don't have an account?",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "  Sign up",
                              style: TextStyle(
                                color: Theme.of(context).hoverColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textColor: Theme.of(context).dividerColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: height(context, 0.03)),

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
