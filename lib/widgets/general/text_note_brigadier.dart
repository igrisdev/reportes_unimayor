import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextNoteBrigadier extends StatelessWidget {
  final String title;
  final String description;
  final bool isImportant;

  const TextNoteBrigadier({
    super.key,
    this.title = '',
    required this.description,
    this.isImportant = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Color colorBackground = Colors.transparent;

    if (description == 'Sin nota') {
      return Container();
    }

    if (isImportant) {
      colorBackground = scheme.error.withValues(alpha: 0.15);
    }

    if (isImportant && title == 'Nota Brigadista') {
      colorBackground = scheme.primary.withValues(alpha: 0.15);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: isImportant ? const EdgeInsets.all(10) : null,
      child: descriptionText(scheme),
    );
  }

  Column descriptionText(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Text(
          description,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
