import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';

class ViewLocation extends StatelessWidget {
  final Ubicacion location;
  final String? ubicacionTextOpcional;

  const ViewLocation({
    super.key,
    required this.location,
    this.ubicacionTextOpcional,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.location_on_outlined, size: 80, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (location.idUbicacion != 0) ...[
                  Text(
                    'Sede ${location.sede}',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    'Edificio ${location.edificio}, Piso ${location.piso}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    'Lugar ${location.lugar}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),
                  if (location.descripcion.isNotEmpty)
                    Text(
                      'Descripción: ${location.descripcion}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                ],
                if (ubicacionTextOpcional != null &&
                    ubicacionTextOpcional!.isNotEmpty)
                  Text(
                    'Ubicación Descrita por el Usuario: ${ubicacionTextOpcional}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
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
