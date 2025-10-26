import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextHealthAssistance extends StatelessWidget {
  final bool isForMy;

  const TextHealthAssistance({super.key, required this.isForMy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Color colorBackground = scheme.primary.withValues(alpha: 0.15);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(10),
      child: descriptionText(scheme),
    );
  }

  Column descriptionText(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isForMy) ...[
          Text(
            'La ayuda es para el REPORTADOR',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
        ] else ...[
          Text(
            'La ayuda es para OTRO',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
        ],
      ],
    );
  }
}
