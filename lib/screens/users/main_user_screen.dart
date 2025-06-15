import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';

class MainUserScreen extends StatelessWidget {
  const MainUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: lightMode.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Reportes UniMayor',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      drawer: drawerUser(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reporte En Curso',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: lightMode.colorScheme.surfaceDim,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: lightMode.colorScheme.primaryFixedDim,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Sede Encarnación - Salón 202',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '6:20 PM',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 13),
                        Text(
                          "lorem fa ipsum r sit amet consectetur adipisicing elit. dolor sit amet consectetur adipisicing elit. Voluptate, quia lorem fa ipsum r sit amet consectetur adipisicing elit. dolor sit amet consectetur adipisicing elit. Voluptate, quia",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        SizedBox(height: 13),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: lightMode.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 5,
                                  bottom: 5,
                                ),
                                child: Text(
                                  'En Proceso',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              '23 - mayo - 2025',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBarMain(),
    );
  }

  BottomAppBar bottomAppBarMain() {
    return BottomAppBar(
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
    );
  }

  Container textNoReports(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Center(
        child: Text(
          "Sin Reporte",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 30),
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
