import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BigBadgeViewProgress extends StatelessWidget {
  final String text;
  const BigBadgeViewProgress({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    Color colorBackground = const Color(0x009E9E9E);
    Color colorText = const Color(0x009E9E9E);

    if (text == 'Pendiente') {
      colorBackground = const Color(0xFFFFCE00);
      colorText = const Color(0xFF000000);
    }
    if (text == 'Cancelado') {
      colorBackground = const Color(0xFFFF3737);
      colorText = const Color(0xFFFFFFFF);
    }
    if (text == 'Finalizado') {
      colorBackground = const Color(0xFF3882F1);
      colorText = const Color(0xFFFFFFFF);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: colorText,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
