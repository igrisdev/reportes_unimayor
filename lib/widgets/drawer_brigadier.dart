import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/token_provider.dart';
import 'package:reportes_unimayor/services/api_token_device_service.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';

class DrawerBrigadier extends ConsumerWidget {
  final BuildContext context;

  const DrawerBrigadier({super.key, required this.context});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Image.asset('assets/icons/logo_unimayor.png', width: 80),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              'Inicio',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            onTap: () {
              router.push('/brigadier');
            },
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'Historial',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            onTap: () {
              router.push('/brigadier/history');
            },
          ),
          Spacer(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'Cerrar Sesión',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            onTap: () async {
              String? deviceToken = await FirebaseMessaging.instance.getToken();
              String? token = ref.read(tokenProvider);

              if (deviceToken != null) {
                final res = await ApiTokenDeviceService().deleteTokenDevice(
                  deviceToken,
                  token!,
                );

                await deleteTokenStorage('token');

                ref.read(tokenProvider.notifier).removeToken();
                if (res) {
                  router.go('/auth');
                }
              }
            },
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
