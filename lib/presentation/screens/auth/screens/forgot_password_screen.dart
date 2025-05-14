import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/core/constants/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/widgets/app_big_button.dart';
import 'package:peveryone/presentation/widgets/app_text_form_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const routeName = '/forgot-password-screen';
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
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
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(height: height(context, 0.03)),

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
