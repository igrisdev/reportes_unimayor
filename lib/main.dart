import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reportes_unimayor/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📥 [Background] Notificación recibida:');
  print('🔔 Título: ${message.notification?.title}');
  print('📄 Cuerpo: ${message.notification?.body}');
  print('📦 Datos: ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

    // 🔔 Handler cuando la app está abierta (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📥 [Foreground] Notificación recibida:');
      print('🔔 Título: ${message.notification?.title}');
      print('📄 Cuerpo: ${message.notification?.body}');
      print('📦 Datos: ${message.data}');
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

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reportes_unimayor/routes/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runApp(ProviderScope(child: MainApp()));
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Reportes Unimayor',
//       debugShowCheckedModeBanner: false,
//       routerConfig: router,
//     );
//   }
// }
