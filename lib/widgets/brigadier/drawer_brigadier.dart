import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/services/api_auth_with_google.dart';
import 'package:reportes_unimayor/services/api_token_device_service.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';

class DrawerBrigadier extends ConsumerStatefulWidget {
  final BuildContext context;

  const DrawerBrigadier({super.key, required this.context});

  @override
  ConsumerState<DrawerBrigadier> createState() => _DrawerBrigadierState();
}

class _DrawerBrigadierState extends ConsumerState<DrawerBrigadier> {
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

        if (res) {
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
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Drawer(
          backgroundColor: colors.surface,
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
                leading: Icon(Icons.home, color: colors.primary),
                title: Text(
                  'Inicio',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: colors.onSurface,
                  ),
                ),
                onTap: () {
                  context.push('/brigadier');
                },
              ),

              ListTile(
                leading: Icon(Icons.history, color: colors.primary),
                title: Text(
                  'Historial Finalizados',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: colors.onSurface,
                  ),
                ),
                onTap: () {
                  context.push('/brigadier/history');
                },
              ),

              const Spacer(),

              ListTile(
                leading: Icon(Icons.logout, color: colors.error),
                title: Text(
                  'Cerrar Sesión',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: colors.error,
                  ),
                ),
                onTap: () => _logout(context),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),

        if (_isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: colors.onPrimary),
          ),
      ],
    );
  }
}
