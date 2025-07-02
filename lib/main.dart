import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reportes_unimayor/routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Reportes Unimayor',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
