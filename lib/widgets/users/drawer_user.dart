import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/auth_notifier_provider.dart';
import 'package:reportes_unimayor/utils/list_menu_user.dart';

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
    final router = GoRouter.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final listTileStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: textTheme.bodyLarge?.color ?? colorScheme.onSurface,
    );

    return Stack(
      children: [
        Drawer(
          backgroundColor: colorScheme.surface,
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
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ROL: REPORTADOR',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ListTile(
                leading: Icon(Icons.home, color: colorScheme.primary),
                title: Text('Inicio', style: listTileStyle),
                onTap: () => router.push('/user'),
              ),

              ...listMenuItemsUser.map((item) {
                return ListTile(
                  leading: Icon(item.icon, color: colorScheme.primary),
                  title: Text(item.title, style: listTileStyle),
                  onTap: () => router.push(item.route),
                );
              }).toList(),

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

        if (_isLoading)
          Container(
            color: colorScheme.scrim.withValues(alpha: 0.5),
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: colorScheme.onPrimary),
          ),
      ],
    );
  }
}
