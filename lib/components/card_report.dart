import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';

class CardReport extends StatelessWidget {
  final GestureTapCallback? redirectTo;
  final String title;
  final String description;
  final String status;
  final String date;
  final String hour;
  final String location;

  const CardReport({
    super.key,
    this.redirectTo,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    required this.hour,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: redirectTo,
      child: Container(
        decoration: BoxDecoration(
          color: lightMode.colorScheme.surfaceDim,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: lightMode.colorScheme.primaryFixedDim),
        ),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(hour, style: GoogleFonts.poppins(fontSize: 16)),
                ],
              ),
              SizedBox(height: 13),
              Text(
                description.trim(),
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
                        status,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(date, style: GoogleFonts.poppins(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
