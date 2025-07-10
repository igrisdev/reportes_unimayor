import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextAndTitleContainer extends StatelessWidget {
  final String title;
  final String description;
  final bool isImportant;
  const TextAndTitleContainer({
    super.key,
    required this.title,
    required this.description,
    this.isImportant = true,
  });

  @override
  Widget build(BuildContext context) {
    Color colorBackground = Colors.transparent;

    if (isImportant) {
      colorBackground = const Color.fromARGB(41, 252, 6, 6);
    }

    if (isImportant && title == 'Nota Brigadista') {
      colorBackground = const Color.fromARGB(255, 223, 222, 222);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: isImportant ? const EdgeInsets.all(10) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
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
