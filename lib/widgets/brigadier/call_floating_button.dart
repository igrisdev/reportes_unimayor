import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/widgets/general/show_message_snack_bar_.dart';
import 'package:url_launcher/url_launcher.dart';

class CallFloatingButton extends StatelessWidget {
  final String? phoneNumber;
  final Color primaryColor;
  final Color onPrimaryColor;

  const CallFloatingButton({
    super.key,
    required this.phoneNumber,
    required this.primaryColor,
    required this.onPrimaryColor,
  });

  void _makeCall(BuildContext context) async {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      showMessageSnackBar(
        context,
        message: 'Número de teléfono no disponible',
        type: SnackBarType.error,
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        showMessageSnackBar(
          context,
          message:
              'No se pudo abrir la aplicación de teléfono para llamar a $phoneNumber',
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      showMessageSnackBar(
        context,
        message: 'Error de conexión con el servidor',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: FloatingActionButton.extended(
        onPressed: () => _makeCall(context),
        backgroundColor: primaryColor,
        heroTag: 'llamarButtonTag',
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        icon: Icon(Icons.phone, color: onPrimaryColor, size: 24),
        label: Text(
          "Llamar",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: onPrimaryColor,
          ),
        ),
      ),
    );
  }
}
