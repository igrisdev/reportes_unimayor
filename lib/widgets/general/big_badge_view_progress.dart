import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BigBadgeViewProgress extends StatelessWidget {
  final String text;
  const BigBadgeViewProgress({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 🎨 Colores dinámicos basados en el estado
    Color bgColor = colorScheme.surfaceContainerHighest;
    Color textColor = colorScheme.onSurface;

    switch (text) {
      case 'Pendiente':
        bgColor = colorScheme.secondaryContainer; // amarillo o acento
        textColor = colorScheme.onSecondaryContainer;
        break;
      case 'En proceso':
        bgColor = colorScheme.tertiary; // verde = éxito
        textColor = colorScheme.onTertiary;
        break;
      case 'Cancelado':
        bgColor = colorScheme.error; // rojo = error
        textColor = colorScheme.onError;
        break;
      case 'Finalizado':
        bgColor = colorScheme.tertiary; // azul = principal
        textColor = colorScheme.onPrimary;
        break;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
