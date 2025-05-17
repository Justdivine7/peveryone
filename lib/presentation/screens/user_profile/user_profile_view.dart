import 'package:flutter/material.dart';
 
class UserProfileView extends StatelessWidget {
  static const routeName = '/user-profile';
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Mark David',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Markdavid@gmail.com',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildListTile(Icons.person, 'Edit Profile', context),
                _buildListTile(Icons.settings, 'Settings', context),
                // _buildListTile(Icons.payment, 'Payment Methods', context),
                _buildListTile(Icons.notifications, 'Notifications', context),
                _buildListTile(Icons.help_outline, 'Help & Support', context),
                _buildListTile(Icons.privacy_tip, 'Privacy Policy', context),

                const SizedBox(height: 30),
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget _buildStat(String title, String value, BuildContext context) {
//   return Column(
//     children: [
//       Text(
//         value,
//         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 4),
//       Text(title, style: TextStyle(color: Theme.of(context).highlightColor)),
//     ],
//   );
// }

Widget _buildListTile(IconData icon, String title, BuildContext context) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 6),
    leading: Icon(icon, color: Theme.of(context).disabledColor),
    title: Text(title, style: const TextStyle(fontSize: 16)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {},
  );
}
