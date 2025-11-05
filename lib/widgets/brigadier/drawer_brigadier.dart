import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/auth_notifier_provider.dart';

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
      await ref.read(authNotifierProvider.notifier).logout();
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
              SizedBox(
                width: double.infinity,
                height: 270,
                child: DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset('assets/icons/logo_unimayor.png', width: 80),
                      const SizedBox(height: 20),
                      Text(
                        'REPORTES UNIMAYOR',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ROL: BRIGADISTA',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: colors.onSecondary,
                        ),
                      ),
                    ],
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
