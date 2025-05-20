import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/core/constants/extensions.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/widgets/app_alert_dialog.dart';

class UserProfileView extends ConsumerWidget {
  static const routeName = '/user-profile';
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).focusColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).focusColor,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: appUser.when(
              data: (user) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        backgroundImage:
                            (user!.photoUrl != null &&
                                    user.photoUrl!.isNotEmpty)
                                ? NetworkImage(user.photoUrl!) as ImageProvider
                                : const AssetImage('assets/images/dummy.png'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.firstName.capitalize(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email.capitalize(),
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                );
              },
              error:
                  (e, stackTrace) => Column(
                    children: [Center(child: Text('Something went wrong'))],
                  ),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildListTile(
                  icon: Icons.person,
                  title: 'Edit Profile',
                  context: context,
                  onTap: () {
                    Navigator.pushNamed(context, '/edit-profile');
                  },
                ),

                _buildListTile(
                  icon: Icons.logout_rounded,
                  title: 'Log out',
                  context: context,
                  onTap: () {
                    appAlertDialog(
                      context: context,
                      title: 'Sign out',
                      content: 'Are you sure you want to sign out',
                      confirmText: 'Yes',
                      cancelText: 'Cancel',
                      onConfirm: () async {
                        final auth = ref.read(authRepositoryProvider);
                        await auth.signOut();
                        Navigator.pushReplacementNamed(
                          context,
                          '/login-screen',
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildListTile({
  required IconData icon,
  required String title,
  required BuildContext context,
  void Function()? onTap,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 6),
    leading: Icon(icon, color: Theme.of(context).disabledColor),
    title: Text(title, style: const TextStyle(fontSize: 16)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
  );
}
