import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/components/app_bar_user.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';

class ViewReportUserScreen extends StatelessWidget {
  const ViewReportUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUser(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Sede Encarnación - Salón 202',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                Spacer(),
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
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('6:20 pm', style: GoogleFonts.poppins(fontSize: 16)),
                Text('  |  ', style: GoogleFonts.poppins(fontSize: 16)),
                Text(
                  '23 - mayo - 2025',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 13),
            Column(
              children: [
                Text(
                  "lorem fa ipsum r sit amet consectetur adipisicing elit. dolor sit amet consectetur adipisicing elit. Voluptate, quia lorem fa ipsum r sit amet consectetur adipisicing elit. dolor sit amet consectetur adipisicing elit. Voluptate, quia",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
