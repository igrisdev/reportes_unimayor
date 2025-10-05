import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsUserScreen extends StatelessWidget {
  const SettingsUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final router = GoRouter.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuración',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: colors.onSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          // SizedBox(
          //   height: 80,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //     child: Row(
          //       children: [
          //         Image.asset('assets/icons/logo_unimayor.png', width: 30),
          //         const SizedBox(width: 10),
          //         Text(
          //           'Johan Manuel Alvarez Pinta',
          //           style: GoogleFonts.poppins(
          //             fontWeight: FontWeight.w600,
          //             fontSize: 20,
          //             color: colors.onSurface,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const Divider(),
          ListTile(
            leading: Icon(Icons.medical_information, color: colors.primary),
            title: Text(
              'Información Medica',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            onTap: () => router.push('/user/settings/medical_information'),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: colors.primary),
            title: Text(
              'Contactos de emergencia',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            onTap: () => router.push('/user/settings/emergency_contacts'),
          ),
        ],
      ),
    );
  }
}
