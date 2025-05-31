import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static const _notifyKey = 'notification_count';
  static Future<void> saveNotificationCount(int count) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_notifyKey, count);
  }

  static Future<int> getNotificationCount()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_notifyKey) ?? 0;
  }
  static Future<void> clearNotificationCount()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notifyKey);
  }
}