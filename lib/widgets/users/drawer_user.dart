import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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

      if (deviceToken != null) {
        final res = await ApiTokenDeviceService().deleteTokenDevice(
          deviceToken,
        );

        await deleteStorage('token');
        await deleteStorage('refresh_token');

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Drawer(
          backgroundColor: colorScheme.surface, // Fondo del drawer
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
                leading: Icon(Icons.home, color: colorScheme.primary),
                title: Text(
                  'Inicio',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: textTheme.bodyLarge?.color ?? colorScheme.onSurface,
                  ),
                ),
                onTap: () => router.push('/user'),
              ),

              ListTile(
                leading: Icon(Icons.history, color: colorScheme.primary),
                title: Text(
                  'Historial',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: textTheme.bodyLarge?.color ?? colorScheme.onSurface,
                  ),
                ),
                onTap: () => router.push('/user/history'),
              ),

              // ListTile(
              //   leading: Icon(Icons.settings, color: colorScheme.primary),
              //   title: Text(
              //     'Configuración',
              //     style: GoogleFonts.poppins(
              //       fontWeight: FontWeight.w500,
              //       fontSize: 18,
              //       color: textTheme.bodyLarge?.color ?? colorScheme.onSurface,
              //     ),
              //   ),
              //   onTap: () => router.push('/user/settings'),
              // ),
              ListTile(
                leading: Icon(
                  Icons.medical_information,
                  color: colorScheme.primary,
                ),
                title: Text(
                  'Información Medica',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                onTap: () => router.push('/user/settings/medical_information'),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: colorScheme.primary),
                title: Text(
                  'Contactos de emergencia',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                onTap: () => router.push('/user/settings/emergency_contacts'),
              ),

              const Spacer(),

              ListTile(
                leading: Icon(Icons.logout, color: colorScheme.error),
                title: Text(
                  'Cerrar Sesión',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: colorScheme.error,
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
            color: colorScheme.scrim.withValues(
              alpha: 0.5,
            ), // Overlay adaptado al tema
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: colorScheme.onPrimary, // color dinámico del loader
            ),
          ),
      ],
    );
  }
}
