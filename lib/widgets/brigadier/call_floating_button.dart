import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reportes_unimayor/utils/show_message.dart';

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
      showMessage(
        context,
        'Número de teléfono no disponible.',
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        showMessage(
          context,
          'No se pudo abrir la aplicación de teléfono para llamar a $phoneNumber.',
          Theme.of(context).colorScheme.error,
        );
      }
    } catch (e) {
      showMessage(
        context,
        'Error al intentar realizar la llamada: $e',
        Theme.of(context).colorScheme.error,
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
