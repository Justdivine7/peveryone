const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatNotification = onDocumentUpdated("chats/{chatId}/messages/{messageId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();

  // Only proceed if status changed from 'sending' to 'sent'
  if (before.status === 'sending' && after.status === 'sent') {
    const receiverId = after.receiverId;
    const senderId = after.senderId;
    const messageType = after.type;

    const db = getFirestore();
    const receiverDoc = await db.collection('users').doc(receiverId).get();
    const receiverData = receiverDoc.data();

    if (!receiverData?.fcmToken) {
      console.log("No FCM token for user", receiverId);
      return;
    }

    const fcmToken = receiverData.fcmToken;
    const firstName = receiverData.firstName || 'Someone';

    // Determine body based on message type
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
        title: firstName,
        body: body,
      },
      data: {
        senderId,
        receiverId,
        firstName,
        messageId: event.params.messageId,
        chatId: event.params.chatId,
        type: messageType,
      },
      android:{
        notification: {
          icon: 'ic_launcher'
         }
      },
      token: fcmToken,
    };

    try {
      await getMessaging().send(payload);
      console.log("Notification sent successfully to", receiverId);
    } catch (err) {
      console.error("Error sending notification:", err);
    }
  }

  return;
});
