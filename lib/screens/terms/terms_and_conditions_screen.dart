import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildParagraph(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: GoogleFonts.poppins(
        fontSize: 16,
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Términos y Condiciones',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Política de Privacidad y Tratamiento de Datos',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Última actualización: 24 de Mayo de 2024',
              style: GoogleFonts.poppins(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            _buildSectionTitle(context, '1. Nuestro Compromiso'),
            _buildParagraph(
              context,
              'Bienvenido/a a Reportes Unimayor. Su seguridad y privacidad son nuestra máxima prioridad. Este documento explica de manera transparente qué información personal recopilamos, cómo la utilizamos y cómo la protegemos, siempre bajo un marco de uso ético y responsable.',
            ),

            _buildSectionTitle(context, '2. Información que Recopilamos'),
            _buildParagraph(
              context,
              'Para facilitar una respuesta rápida y efectiva a las emergencias, la aplicación recopila la siguiente información que usted proporciona voluntariamente:',
            ),
            const SizedBox(height: 10),
            _buildParagraph(
              context,
              '• Detalles del Reporte: Descripción del incidente, ubicación (obtenida por QR, selección manual o texto) y grabaciones de audio.',
            ),
            _buildParagraph(
              context,
              '• Información Médica Opcional: Condiciones médicas, alergias o información relevante que decida compartir para facilitar la atención.',
            ),
            _buildParagraph(
              context,
              '• Contactos de Emergencia Opcionales: Nombres y números de teléfono de personas a contactar en caso de una emergencia.',
            ),

            _buildSectionTitle(context, '3. Uso Ético de su Información'),
            _buildParagraph(
              context,
              'La información recopilada se utilizará única y exclusivamente para los siguientes propósitos:',
            ),
            const SizedBox(height: 10),
            _buildParagraph(
              context,
              '• Facilitar la Asistencia: Compartir los detalles de su reporte con los brigadistas y personal de primera respuesta de la institución para que puedan localizarlo y brindarle la ayuda necesaria de manera eficiente.',
            ),
            _buildParagraph(
              context,
              '• Comunicación: Notificarle sobre el estado de su reporte (recibido, en proceso, finalizado).',
            ),
            _buildParagraph(
              context,
              '• Mejora del Servicio: Analizar datos de forma anónima y agregada para mejorar los tiempos de respuesta y la efectividad del sistema de emergencias de la institución. En ningún caso se utilizarán sus datos personales identificables para este fin.',
            ),

            _buildSectionTitle(context, '4. Seguridad y Protección de Datos'),
            _buildParagraph(
              context,
              'Nos comprometemos a proteger su información. Implementamos medidas de seguridad técnicas y organizativas para prevenir el acceso no autorizado, la alteración o la divulgación de sus datos. El acceso a la información de los reportes está estrictamente limitado al personal autorizado (brigadistas y administradores del sistema) que necesita conocerla para cumplir con sus funciones.',
            ),

            _buildSectionTitle(context, '5. Consentimiento'),
            _buildParagraph(
              context,
              'Al utilizar la aplicación y enviar un reporte, usted acepta la recopilación y el uso de su información personal tal como se describe en esta política. Entiende que, en una situación de emergencia, la prioridad es su bienestar, y la información proporcionada es vital para ello.',
            ),

            _buildSectionTitle(context, '6. Contacto'),
            _buildParagraph(
              context,
              'Si tiene alguna pregunta sobre el tratamiento de sus datos, por favor contacte a la administración del servicio de emergencias de la institución.',
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Gracias por confiar en Reportes Unimayor.',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
