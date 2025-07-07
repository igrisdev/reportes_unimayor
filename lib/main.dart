import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reportes_unimayor/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await _showNotification(message);
}

void requestNotificationPermission() async {
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('✅ Permiso concedido');
  } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print('🚫 Permiso denegado');
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.notDetermined) {
    print('❓ Permiso no determinado');
  }
}

Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'default_channel',
        'General',
        channelDescription: 'Canal de notificaciones de la app',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    message.notification.hashCode,
    message.notification?.title ?? 'Notificación',
    message.notification?.body ?? '',
    platformChannelSpecifics,
    payload: 'default',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(
        const AndroidNotificationChannel(
          'default_channel',
          'General',
          description: 'Canal de notificaciones de la app',
          importance: Importance.high,
        ),
      );

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Reportes Unimayor',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
