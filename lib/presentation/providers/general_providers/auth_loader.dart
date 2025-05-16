import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthLoader {
  static final registrationLoadingProvider = StateProvider<bool>(
    (ref) => false,
  );
  static final loginLoadingProvider = StateProvider<bool>((ref) => false);
  static final verificationLoadingProvider = StateProvider<bool>(
    (ref) => false,
  );
  static final emailVerifiedProvider = StateProvider<bool>((ref) => false);

  static final selectedIndexProvider = StateProvider<int>((ref) => 0);
}
