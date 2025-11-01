import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationTextOptionalField extends StatelessWidget {
  final String? formUbicacionTextOpcional;
  final ValueChanged<String> onChanged;

  const LocationTextOptionalField({
    super.key,
    required this.formUbicacionTextOpcional,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextFormField(
      initialValue: formUbicacionTextOpcional,
      onChanged: (value) {
        onChanged(value);
        // setState(() {
        //   formUbicacionTextOpcional = value;
        // });
      },
      textCapitalization: TextCapitalization.sentences,
      style: GoogleFonts.poppins(fontSize: 20),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        labelText: 'Ultima forma de mandar la ubicación',
        labelStyle: GoogleFonts.poppins(
          color: colors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        hintText: "Ejemplo: Bicentenario, Piso 2, Salon 202",
        hintStyle: GoogleFonts.poppins(fontSize: 15),
      ),
    );
  }
}
