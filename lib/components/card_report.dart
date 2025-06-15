import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';

class CardReport extends StatelessWidget {
  const CardReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightMode.colorScheme.surfaceDim,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: lightMode.colorScheme.primaryFixedDim),
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
                Text('6:20 PM', style: GoogleFonts.poppins(fontSize: 16)),
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
    );
  }
}
