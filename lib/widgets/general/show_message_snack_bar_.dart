import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SnackBarType { success, error, normal }

/// Muestra un SnackBar personalizado en toda la aplicación.
///
/// [context]: El BuildContext del widget que llama.
/// [message]: El texto que se mostrará en el SnackBar.
/// [durationInSeconds]: (Opcional) Cuántos segundos se mostrará. Por defecto es 3.
/// [type]: (Opcional) El estilo del SnackBar (success, error, normal). Por defecto es normal.
void showMessageSnackBar(
  BuildContext context, {
  required String message,
  int durationInSeconds = 3,
  SnackBarType type = SnackBarType.normal,
}) {
  // Obtenemos los colores del tema actual para que sea consistente.
  final colors = Theme.of(context).colorScheme;

  // 2. Variables para definir el estilo según el tipo.
  Color backgroundColor;
  Color foregroundColor;
  IconData iconData;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = colors.tertiary;
      foregroundColor = colors.onTertiary;
      iconData = Icons.check_circle_outline;
      break;
    case SnackBarType.error:
      backgroundColor = colors.error;
      foregroundColor = colors.onError;
      iconData = Icons.error_outline;
      break;
    case SnackBarType.normal:
    default:
      backgroundColor = Colors.grey.shade800;
      foregroundColor = Colors.white;
      iconData = Icons.info_outline;
      break;
  }

  // 3. Ocultamos cualquier SnackBar que ya esté visible para evitar apilamiento.
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // 4. Mostramos el nuevo SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // El contenido ahora es una fila con un icono y el texto.
      content: Row(
        children: [
          Icon(iconData, color: foregroundColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                color: foregroundColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSeconds),
      elevation: 0,
      behavior: SnackBarBehavior
          .floating, // Un estilo más moderno que flota sobre el contenido.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
  );
}
