import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin local_notifications =
      FlutterLocalNotificationsPlugin();

  static final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'foreground_notification_channel',
    'Foreground Notifications',
    description: 'This channel is used for foreground notifications.',
    importance: Importance.max,
  );

  Future<void> initNotifications() async {
    await messaging.requestPermission();
    final fcmToken = await getFcmToken();
    print(fcmToken);
    FirebaseMessaging.onBackgroundMessage(await handleBackgroundMessage);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await local_notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        local_notifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
  }

  Future<String?> getFcmToken() async {
    try {
      String? token = await messaging.getToken();
      User currentUser = auth.currentUser!;
      await firestore.collection('users').doc(currentUser.uid).get();
      await firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({'fcmToken': token});
      return token;
    } catch (err) {
      print(err);
      return null;
    }
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
}
