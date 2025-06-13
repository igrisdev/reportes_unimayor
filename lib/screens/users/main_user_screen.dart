import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';

class MainUserScreen extends StatelessWidget {
  const MainUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Reportes UniMayor',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      drawer: drawerUser(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
        child: Center(
          child: Text(
            "Sin Reporte",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        height: 90,
        child: Container(
          decoration: BoxDecoration(
            color: lightMode.colorScheme.secondary,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Realizar Reporte",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Drawer drawerUser() {
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
            onTap: () {},
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
            onTap: () {},
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
