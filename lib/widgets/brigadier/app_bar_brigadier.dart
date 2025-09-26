import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarBrigadier extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBrigadier({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface, // Fondo del AppBar
      centerTitle: true,
      title: Text(
        'Reportes UniMayor',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: colorScheme.onSurface, // Texto adaptado al tema
        ),
      ),
      actions: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primary, // Fondo del botón
            foregroundColor: colorScheme.onPrimary, // Color del ícono
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.engineering),
          onPressed: () {
            router.pushReplacement('/user');
          },
        ),
      ],
    );
  }
}
