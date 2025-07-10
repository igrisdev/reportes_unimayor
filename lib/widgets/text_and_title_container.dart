import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextAndTitleContainer extends StatelessWidget {
  final String title;
  final String description;
  const TextAndTitleContainer({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Color colorBackground = Colors.transparent;

    switch (title) {
      case 'Descripción':
        colorBackground = const Color.fromARGB(41, 252, 6, 6);
        break;
      default:
        colorBackground = const Color.fromARGB(41, 6, 252, 252);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
