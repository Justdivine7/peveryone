
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendChatNotification = functions.firestore
  .document("chats/{chatId}/messages/{messageId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Only proceed if status changed from 'sending' to 'sent'
    if (before.status === 'sending' && after.status === 'sent') {
      const receiverId = after.receiverId;
      const senderId = after.senderId;
      const messageType = after.type;

      // Fetch the receiver's user document
      const receiverDoc = await admin.firestore()
        .collection('users')
        .doc(receiverId)
        .get();

      const fcmToken = receiverDoc.data()?.fcmToken;
      const firstName = receiverDoc.data()?.firstName || 'Someone';

      if (!fcmToken) {
        console.log("No FCM token for user", receiverId);
        return null;
      }

      // Construct the notification body based on message type
      let body;
      switch (messageType) {
        case 'text':
          body = after.content;
          break;
        case 'image':
          body = '📷 Image';
          break;
        case 'video':
          body = '🎥 Video';
          break;
        default:
          body = 'You have a new message!';
      }

      const payload = {
        notification: {
          title: `${firstName} sent you a message`,
          body: body,
        },
        data: {
          senderId: senderId,
          receiverId: receiverId,
          firstName: firstName,
          messageId: context.params.messageId,
          chatId: context.params.chatId,
          type: messageType,
        },
        token: fcmToken,
      };

      try {
        await admin.messaging().send(payload);
        console.log("Notification sent successfully to", receiverId);
      } catch (err) {
        console.error("Error sending notification:", err);
      }
    }

    return null;
  });
