import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/screens/users/history_user_screen.dart';
import 'package:reportes_unimayor/screens/users/main_user_screen.dart';

class DrawerUser extends StatelessWidget {
  final BuildContext context;

  const DrawerUser({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainUserScreen()),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryUserScreen(),
                ),
              );
            },
          ),

          Expanded(child: Container(height: double.infinity)),

          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'Cerrar Sesión',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            onTap: () {},
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
