import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarBrigadier extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBrigadier({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Reportes UniMayor',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.change_circle),
          onPressed: () {
            print('Botón de perfil presionado');
          },
        ),
      ],
    );
  }
}
