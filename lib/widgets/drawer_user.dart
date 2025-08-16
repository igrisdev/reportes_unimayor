import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/token_provider.dart';
import 'package:reportes_unimayor/services/api_auth_with_google.dart';
import 'package:reportes_unimayor/services/api_token_device_service.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';

class DrawerUser extends ConsumerStatefulWidget {
  final BuildContext context;

  const DrawerUser({super.key, required this.context});

  @override
  ConsumerState<DrawerUser> createState() => _DrawerUserState();
}

class _DrawerUserState extends ConsumerState<DrawerUser> {
  bool _isLoading = false;

  Future<void> _logout(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      await ApiAuthWithGoogle().googleSingOut();

      String? deviceToken = await FirebaseMessaging.instance.getToken();
      String? token = ref.read(tokenProvider);

      if (deviceToken != null && token != null) {
        final res = await ApiTokenDeviceService().deleteTokenDevice(
          deviceToken,
          token,
        );

        await deleteTokenStorage('token');
        ref.read(tokenProvider.notifier).removeToken();

        if (res && mounted) {
          GoRouter.of(context).go('/auth');
        }
      }
    } catch (e) {
      debugPrint("Error al cerrar sesión: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    return Stack(
      children: [
        Drawer(
          child: Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Image.asset(
                    'assets/icons/logo_unimayor.png',
                    width: 80,
                  ),
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
                  router.push('/user');
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
                  router.push('/user/history');
                },
              ),

              const Spacer(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  'Cerrar Sesión',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                onTap: () => _logout(context),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),

        // Overlay loader
        if (_isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: Colors.white),
          ),
      ],
    );
  }
}
