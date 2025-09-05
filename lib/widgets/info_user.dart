import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoUser extends StatelessWidget {
  final String name;
  final String email;

  const InfoUser({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 30, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name.isNotEmpty)
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),

                if (name.isEmpty)
                  Text(
                    'Invitado: $email',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
