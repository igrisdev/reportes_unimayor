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
    return AppBar(
      centerTitle: true,
      title: Text(
        'Reportes UniMayor',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      actions: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: Icon(Icons.engineering),
          onPressed: () {
            router.push('/user');
          },
        ),
      ],
    );
  }
}
