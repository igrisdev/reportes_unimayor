import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/person_model.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/services/api_reports_service.dart';
import 'package:reportes_unimayor/utils/show_message.dart';

class PersonDetailsDisplay extends ConsumerStatefulWidget {
  final bool paraMi;
  final Usuario usuario;

  const PersonDetailsDisplay({
    super.key,
    required this.paraMi,
    required this.usuario,
  });

  @override
  ConsumerState<PersonDetailsDisplay> createState() =>
      _PersonDetailsDisplayState();
}

class _PersonDetailsDisplayState extends ConsumerState<PersonDetailsDisplay> {
  bool _isLoading = false;
  PersonModel? _person;

  @override
  void initState() {
    super.initState();
    // Ejecuta la búsqueda automáticamente si 'paraMi' es true
    if (widget.paraMi) {
      _searchPersonDetails();
    }
  }

  // Método de búsqueda automática (adaptado de SearchPerson)
  void _searchPersonDetails() async {
    setState(() {
      _isLoading = true;
      _person = null;
    });

    try {
      final email = widget.usuario.correo.trim();

      // NOTA: Asumo que ApiReportsService().searchPerson(email) devuelve PersonModel
      // si es necesario adaptarlo al nuevo modelo, avísame.
      final person = await ApiReportsService().searchPerson(email);

      if (!mounted) return;

      setState(() {
        _person = person;
      });
    } catch (e) {
      if (!mounted) return;
      print(e);
      showMessage(
        context,
        'Error al cargar la información detallada del usuario.',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.paraMi) {
      // ------------------------------------------------
      // LÓGICA 1: Si paraMi es FALSE (como InfoUser)
      // ------------------------------------------------
      return _buildInfoUser(context);
    }

    // ------------------------------------------------
    // LÓGICA 2: Si paraMi es TRUE (como SearchPerson, pero automático)
    // ------------------------------------------------
    if (_isLoading) {
      return Center(
        child: Column(
          children: [
            const Text('Cargando detalles del paciente...'),
            const SizedBox(height: 10),
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      );
    }

    if (_person == null) {
      // Muestra un mensaje si la búsqueda fue automática pero no encontró datos
      return const Center(
        child: Text(
          'No se pudo obtener la información detallada del paciente.',
          textAlign: TextAlign.center,
        ),
      );
    }

    // Muestra los detalles de la persona
    return _buildPersonDetails(context);
  }

  // Diseño para 'paraMi = false' (Informante)
  Widget _buildInfoUser(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final name = widget.usuario.nombre ?? '';
    final email = widget.usuario.correo;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 30, color: colors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informante:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
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
                      'Invitado ${email.split('@').first}',
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
      ),
    );
  }

  // Diseño para 'paraMi = true' (Detalles del Paciente)
  Widget _buildPersonDetails(BuildContext context) {
    final theme = Theme.of(context);

    // **********************************************
    // Este contenido es el mismo que la sección de resultados en SearchPerson
    // **********************************************
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 30),
        Text(
          'Detalles Medicos y de Contacto',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 15),
        // Información del usuario
        _buildDetailSection(
          context,
          Icons.person,
          "Información del usuario",
          theme.colorScheme.primary,
          [
            Text("Nombre: ${_person!.infoUsuario.nombre}"),
            Text("Correo: ${_person!.infoUsuario.correo}"),
          ],
        ),

        const Divider(height: 30),

        // Contactos de emergencia
        _buildDetailSection(
          context,
          Icons.contact_phone,
          "Contactos de emergencia",
          theme.colorScheme.onSecondary,
          _person!.contactos.isNotEmpty &&
                  _person!.contactos.first.mensaje != null
              ? [
                  _buildMessageListTile(
                    context,
                    _person!.contactos.first.mensaje!,
                  ),
                ]
              : _person!.contactos
                    .map(
                      (c) => ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(c.nombre ?? "Sin nombre"),
                        subtitle: Text(
                          "${c.relacion ?? "Sin relación"} - ${c.telefono ?? "N/A"}",
                        ),
                      ),
                    )
                    .toList(),
        ),

        const Divider(height: 30),

        // Condiciones médicas
        _buildDetailSection(
          context,
          Icons.local_hospital,
          "Condiciones médicas",
          theme.colorScheme.tertiary,
          _person!.condicionesMedicas.isNotEmpty &&
                  _person!.condicionesMedicas.first.mensaje != null
              ? [
                  _buildMessageListTile(
                    context,
                    _person!.condicionesMedicas.first.mensaje!,
                  ),
                ]
              : _person!.condicionesMedicas
                    .map(
                      (cm) => ListTile(
                        leading: const Icon(Icons.health_and_safety),
                        title: Text(cm.nombre ?? ""),
                        subtitle: Text(cm.descripcion ?? ""),
                      ),
                    )
                    .toList(),
        ),
      ],
    );
  }

  // Helper para construir secciones (Contactos, Condiciones)
  Widget _buildDetailSection(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  // Helper para el ListTile de mensaje de condición/contacto
  ListTile _buildMessageListTile(BuildContext context, String message) {
    return ListTile(
      leading: const Icon(Icons.info_outline, color: Colors.grey),
      title: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }
}
