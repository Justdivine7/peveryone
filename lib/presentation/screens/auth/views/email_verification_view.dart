import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/providers/general_providers/auth_loader.dart';
import 'package:peveryone/presentation/providers/general_providers/global_providers.dart';
 import 'package:peveryone/presentation/widgets/app_big_button.dart';
import 'package:peveryone/presentation/widgets/app_text_button.dart';
import 'package:peveryone/presentation/widgets/loading_overlay.dart';
import 'package:toastification/toastification.dart';

class EmailVerificationView extends ConsumerStatefulWidget {
  static const routeName = '/verify-email';
  const EmailVerificationView({super.key});

  @override
  ConsumerState<EmailVerificationView> createState() =>
      _EmailVerificationViewState();
}

class _EmailVerificationViewState extends ConsumerState<EmailVerificationView> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (_) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        final verified = ref.read(AuthLoader.emailVerifiedProvider.notifier);
        verified.state = true;
        _timer.cancel();
      }
    });
  }

  Future<void> resendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    final auth = ref.read(authRepositoryProvider);
    final toast = ref.read(toastProvider);

    if (user != null && !user.emailVerified) {
      await auth.sendEmailVerification(user);
      toast.show(
        message: 'Verification email resent',
        type: ToastificationType.info,
      );
    } else {
      toast.show(
        message: 'Email already verified',
        type: ToastificationType.success,
      );
      debugPrint('verified');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void proceedToHome() {
    Navigator.pushReplacementNamed(context, '/base-view');
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(AuthLoader.verificationLoadingProvider);
    final isVerified = ref.watch(AuthLoader.emailVerifiedProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: LoadingOverlay(
            isLoading: loading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.mark_email_unread_outlined,

                  size: height(context, 0.1),
                  color: Theme.of(context).hoverColor,
                ),
                SizedBox(height: height(context, 0.02)),
                Text(
                  textAlign: TextAlign.center,
                  'A verification email has been sent to your email address. Please verify to continue.',
                ),
                SizedBox(height: height(context, 0.03)),
                AppBigButton(
                  label: isVerified ? 'Continue to Home' : 'Waiting...',
                  onPressed: isVerified ? proceedToHome : null,
                ),
                SizedBox(height: height(context, 0.03)),
                AppTextButton(
                  label: "Didn't get the link? Resend",
                  fontWeight: FontWeight.w500,
                  textColor: Theme.of(context).colorScheme.onSurface,
                  onTap: resendVerificationEmail,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
