// // lib/services/fcm_service.dart
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';

// class FCMService {
//   // Create instances of Firebase services
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications = 
//       FlutterLocalNotificationsPlugin();

//   // Navigation key for handling notification taps
//   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   /// Initialize the entire FCM system
//   static Future<void> initialize() async {
//     debugPrint('🔥 Initializing FCM Service...');
    
//     // Step 1: Request notification permissions
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,     // Show notification alerts
//       badge: true,     // Update app badge count
//       sound: true,     // Play notification sound
//     );

//     // Check if user granted permission
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('✅ User granted notification permission');
      
//       // Step 2: Initialize local notifications (for foreground)
//       await _initializeLocalNotifications();
      
//       // Step 3: Get and store FCM token
//       await _storeFCMToken();
      
//       // Step 4: Listen for token refresh (when token changes)
//       _messaging.onTokenRefresh.listen(_updateFCMToken);
      
//       // Step 5: Handle different notification scenarios
//       _setupNotificationHandlers();
      
//     } else {
//       debugPrint('❌ User denied notification permission');
//     }
//   }

//   /// Initialize local notifications for when app is in foreground
//   static Future<void> _initializeLocalNotifications() async {
//     debugPrint('📱 Setting up local notifications...');
    
//     // Android settings
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
        
//     // iOS settings
//     const DarwinInitializationSettings iosSettings =
//         DarwinInitializationSettings(
//           requestSoundPermission: true,
//           requestBadgePermission: true,
//           requestAlertPermission: true,
//         );

//     // Combined settings
//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     // Initialize with settings and tap handler
//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: _onLocalNotificationTap,
//     );
    
//     debugPrint('✅ Local notifications initialized');
//   }

//   /// Get FCM token and store it in Firestore
//   static Future<void> _storeFCMToken() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         // Get the unique FCM token for this app installation
//         final token = await _messaging.getToken();
//         debugPrint('🔑 FCM Token: ${token?.substring(0, 20)}...');
        
//         if (token != null) {
//           // Store token in user's Firestore document
//           await _firestore.collection('users').doc(user.uid).update({
//             'fcmToken': token,
//             'lastSeen': FieldValue.serverTimestamp(),
//           });
//           debugPrint('✅ FCM Token stored in Firestore');
//         }
//       } catch (e) {
//         debugPrint('❌ Error storing FCM token: $e');
//       }
//     } else {
//       debugPrint('⚠️ No user logged in, cannot store FCM token');
//     }
//   }

//   /// Update FCM token when it refreshes
//   static Future<void> _updateFCMToken(String token) async {
//     debugPrint('🔄 FCM Token refreshed: ${token.substring(0, 20)}...');
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         await _firestore.collection('users').doc(user.uid).update({
//           'fcmToken': token,
//         });
//         debugPrint('✅ FCM Token updated in Firestore');
//       } catch (e) {
//         debugPrint('❌ Error updating FCM token: $e');
//       }
//     }
//   }

//   /// Setup handlers for different notification scenarios
//   static void _setupNotificationHandlers() {
//     debugPrint('🎯 Setting up notification handlers...');
    
//     // Handle messages when app is in FOREGROUND
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
//     // Handle notification taps when app is in BACKGROUND
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    
//     // Handle messages when app is in BACKGROUND
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
//     debugPrint('✅ Notification handlers setup complete');
//   }

//   /// Handle notifications when app is in foreground (app is open)
//   static Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     debugPrint('📨 Received foreground message: ${message.notification?.title}');
    
//     // Show local notification since system won't show it automatically
//     await _showLocalNotification(message);
//   }

//   /// Handle notification taps (when user taps notification)
//   static Future<void> _handleNotificationTap(RemoteMessage message) async {
//     debugPrint('👆 Notification tapped: ${message.data}');
    
//     // Navigate based on notification data
//     final data = message.data;
//     if (data['type'] == 'chat_message') {
//       _navigateToChat(data['chatId'], data['senderId']);
//     }
//   }

//   /// Show local notification when app is in foreground
//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     // Create notification channel for Android
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'chat_messages',              // Channel ID
//       'Chat Messages',              // Channel name (shown in settings)
//       channelDescription: 'Notifications for new chat messages',
//       importance: Importance.high,   // Make it priority notification
//       priority: Priority.high,
//       icon: '@mipmap/ic_launcher',   // Use app icon
//       sound: RawResourceAndroidNotificationSound('notification'), // Custom sound (optional)
//     );

//     // iOS notification settings
//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       sound: 'default',
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     // Combined notification details
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     // Show the notification
//     await _localNotifications.show(
//       message.hashCode,                           // Unique ID
//       message.notification?.title ?? 'New Message',   // Title
//       message.notification?.body ?? 'You have a new message',  // Body
//       notificationDetails,
//       payload: message.data.toString(),           // Data to pass when tapped
//     );
    
//     debugPrint('✅ Local notification shown');
//   }

//   /// Handle local notification taps
//   static void _onLocalNotificationTap(NotificationResponse response) {
//     debugPrint('👆 Local notification tapped: ${response.payload}');
//     // Parse payload and navigate
//     // You can add navigation logic here based on payload
//   }

//   /// Navigate to chat screen when notification is tapped
//   static void _navigateToChat(String? chatId, String? senderId) {
//     if (chatId != null && senderId != null) {
//       debugPrint('🧭 Navigating to chat: $chatId');
      
//       // Use the navigator key to navigate
//       navigatorKey.currentState?.pushNamed(
//         '/chat-room',
//         arguments: {
//           'chatId': chatId,
//           'senderId': senderId,
//         },
//       );
//     }
//   }

//   /// Clear FCM token when user logs out
//   static Future<void> clearToken() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         await _firestore.collection('users').doc(user.uid).update({
//           'fcmToken': FieldValue.delete(),
//         });
//         debugPrint('✅ FCM Token cleared from Firestore');
//       } catch (e) {
//         debugPrint('❌ Error clearing FCM token: $e');
//       }
//     }
//   }
// }

// /// Background message handler (must be top-level function)
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint('🔔 Background message received: ${message.notification?.title}');
//   // Handle background message processing here
//   // Keep this lightweight - you have limited time!
// }