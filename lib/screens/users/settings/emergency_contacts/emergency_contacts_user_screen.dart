import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

// Importamos el provider real
import 'package:reportes_unimayor/providers/settings_provider.dart';

// ----------------------------------------------------------------------
// 1. MODELO DE DATOS (Incluye fromJson para la API)
// ----------------------------------------------------------------------

class EmergencyContact {
  final String id;
  String nombre;
  String relacion;
  String telefono;
  String? telefonoAlternativo;
  String? email;
  bool esPrincipal;

  EmergencyContact({
    required this.id,
    required this.nombre,
    required this.relacion,
    required this.telefono,
    this.telefonoAlternativo,
    this.email,
    this.esPrincipal = false,
  });

  // Constructor factory para deserializar desde el JSON de la API
  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    // La API parece usar "idContactoEmergencia" como ID y puede ser int o string
    final idValue = json['idContactoEmergencia'] ?? json['id'] ?? '';
    // Nos aseguramos de que el ID sea un String
    final String contactId = idValue is int
        ? idValue.toString()
        : (idValue as String);

    return EmergencyContact(
      id: contactId,
      nombre: json['nombre'] as String,
      relacion: json['relacion'] as String,
      telefono: json['telefono'] as String,
      telefonoAlternativo: json['telefonoAlternativo'] as String?,
      email: json['email'] as String?,
      // Aseguramos que 'esPrincipal' sea un booleano (la API lo envía como bool)
      esPrincipal: json['esPrincipal'] as bool,
    );
  }
}

// ----------------------------------------------------------------------
// 3. WIDGET PRINCIPAL (Lista de Contactos)
// ----------------------------------------------------------------------

// Convertimos a ConsumerWidget ya que solo necesitamos observar el provider
class EmergencyContactsUserScreen extends ConsumerWidget {
  const EmergencyContactsUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    // Usamos el provider REAL de settings_provider.dart
    final contactsAsyncValue = ref.watch(emergencyContactsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contactos de Emergencia',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: colors.onSurface,
          ),
        ),
      ),
      body: contactsAsyncValue.when(
        // Estado: Data cargada
        data: (contacts) {
          if (contacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 80,
                    color: colors.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No tienes contactos registrados.',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '¡Agrega el primero!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: colors.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return _ContactListItem(
                contact: contact,
                colors: colors,
                ref: ref,
              );
            },
          );
        },
        // Estado: Cargando
        loading: () =>
            Center(child: CircularProgressIndicator(color: colors.primary)),
        // Estado: Error
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Error al cargar contactos: ${err.toString()}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: colors.error),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.go('/user/settings/emergency_contacts/create_and_edit'),
        label: Text(
          'Nuevo Contacto',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colors.onPrimary,
          ),
        ),
        icon: const Icon(Icons.person_add, color: Colors.white),
        backgroundColor: colors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// 4. WIDGET DE ITEM DE LA LISTA
// ----------------------------------------------------------------------

class _ContactListItem extends ConsumerWidget {
  final EmergencyContact contact;
  final ColorScheme colors;
  final WidgetRef ref;

  const _ContactListItem({
    required this.contact,
    required this.colors,
    required this.ref,
  });

  // Función para mostrar el diálogo de confirmación de eliminación
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        // Observa el estado del provider de eliminación
        final deleteState = ref.watch(deleteEmergencyContactProvider);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: colors.error),
              const SizedBox(width: 10),
              Text(
                'Confirmar Eliminación',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro de que quieres eliminar a ${contact.nombre} de tus contactos de emergencia?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cerrar
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(color: colors.primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Deshabilita el botón mientras se está cargando
              onPressed: deleteState.isLoading
                  ? null
                  : () async {
                      // Intentar eliminar
                      await ref
                          .read(deleteEmergencyContactProvider.notifier)
                          .deleteContact(contact.id);

                      // Cierra el diálogo solo si no hay error
                      if (!ref.read(deleteEmergencyContactProvider).hasError) {
                        Navigator.of(context).pop();
                      }
                      // En caso de error, el estado se actualiza automáticamente.
                    },
              child: deleteState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Eliminar',
                      style: GoogleFonts.poppins(color: colors.onError),
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Aquí podríamos navegar a una pantalla de detalle/edición
          // context.go('/user/settings/emergency_contacts/${contact.id}/edit');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Navegando a edición de ${contact.nombre} (ID: ${contact.id})',
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y Relación
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.nombre,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Relación: ${contact.relacion}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: colors.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botones de Acción (Editar y Eliminar)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge Principal
                      if (contact.esPrincipal)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colors.tertiary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: colors.tertiary,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'PRINCIPAL',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: colors.tertiary,
                              ),
                            ),
                          ),
                        ),

                      // Botón Editar
                      IconButton(
                        icon: Icon(Icons.edit_note, color: colors.secondary),
                        onPressed: () {
                          context.go(
                            '/user/settings/emergency_contacts/create_and_edit/${contact.id}',
                          );
                        },
                        tooltip: 'Editar contacto',
                      ),

                      // Botón Eliminar
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: colors.error),
                        onPressed: () => _confirmDelete(context),
                        tooltip: 'Eliminar contacto',
                      ),
                    ],
                  ),
                ],
              ),

              const Divider(height: 16),

              // Información de contacto
              _ContactInfoRow(
                icon: Icons.phone_android,
                label: 'Móvil',
                value: contact.telefono,
                colors: colors,
                isPrimary: true,
              ),

              // Teléfono Alternativo (Si existe)
              if (contact.telefonoAlternativo != null &&
                  contact.telefonoAlternativo!.isNotEmpty)
                _ContactInfoRow(
                  icon: Icons.phone_in_talk,
                  label: 'Alternativo',
                  value: contact.telefonoAlternativo!,
                  colors: colors,
                ),

              // Email (Si existe)
              if (contact.email != null && contact.email!.isNotEmpty)
                _ContactInfoRow(
                  icon: Icons.email,
                  label: 'Email',
                  value: contact.email!,
                  colors: colors,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para las filas de información de contacto
class _ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colors;
  final bool isPrimary;

  const _ContactInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isPrimary
                ? colors.secondary
                : colors.secondary.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isPrimary ? FontWeight.w500 : FontWeight.w400,
              color: colors.onSurface.withOpacity(isPrimary ? 1.0 : 0.8),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
