import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/widgets/app_big_button.dart';
import 'package:peveryone/presentation/widgets/app_text_form_field.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  static const routeName = '/forgot-password';
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    return null;
  }

  void forgotPassword() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final auth = ref.read(authRepositoryProvider);
      final success = await auth.sendPasswordResetEmail(
        _emailController.text.trim(),
      );
      if (success && context.mounted) {
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // SizedBox(height: height(context, 0.03)),
                  Center(
                    child: Text(
                      "Reset your password",
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
                  SizedBox(height: height(context, 0.02)),
                  Text('A password reset link will be sent to your mail'),
                  SizedBox(height: height(context, 0.03)),

                  AppBigButton(label: 'Proceed', onPressed: forgotPassword),
                  SizedBox(height: height(context, 0.03)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
