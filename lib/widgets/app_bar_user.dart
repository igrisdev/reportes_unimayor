import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/is_brigadier_provider.dart';

class AppBarUser extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarUser({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final isBrigadier = ref.watch(isBrigadierProvider);

    final colors = Theme.of(context).colorScheme;

    return AppBar(
      centerTitle: true,
      backgroundColor: colors.primary, // color de fondo del AppBar
      title: Text(
        'Reportes UniMayor',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: colors.onPrimary, // texto sobre el primary
        ),
      ),
      actions: [
        if (isBrigadier)
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: colors.secondary, // fondo del botón
              foregroundColor: colors.onSecondary, // icono dentro del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.person),
            onPressed: () {
              router.go('/brigadier');
            },
          ),
      ],
    );
  }
}
