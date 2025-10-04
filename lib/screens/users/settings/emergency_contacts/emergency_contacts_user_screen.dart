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
    final idValue = json['idContactoEmergencia'] ?? json['id'] ?? '';
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
      esPrincipal: json['esPrincipal'] as bool,
    );
  }
}

// ----------------------------------------------------------------------
// 3. WIDGET PRINCIPAL (Lista de Contactos)
// ----------------------------------------------------------------------

class EmergencyContactsUserScreen extends ConsumerWidget {
  const EmergencyContactsUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final contactsAsyncValue = ref.watch(emergencyContactsListProvider);

    ref.listen<AsyncValue<void>>(deleteEmergencyContactProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (_) {
          // Éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contacto eliminado correctamente'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Cerrar el diálogo si está abierto
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
        error: (error, _) {
          // Error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${error.toString()}'),
              backgroundColor: colors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    });

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
              return _ContactListItem(contact: contact, colors: colors);
            },
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: colors.primary)),
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

  const _ContactListItem({
    super.key,
    required this.contact,
    required this.colors,
  });

  // Diálogo de confirmación de eliminación
  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
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
              onPressed: () => Navigator.of(context).pop(),
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
              onPressed: deleteState.isLoading
                  ? null
                  : () async {
                      await ref
                          .read(deleteEmergencyContactProvider.notifier)
                          .deleteContact(contact.id);
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

                // Botones de Acción
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    IconButton(
                      icon: Icon(Icons.edit_note, color: colors.secondary),
                      onPressed: () {
                        context.go(
                          '/user/settings/emergency_contacts/create_and_edit/${contact.id}',
                        );
                      },
                      tooltip: 'Editar contacto',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: colors.error),
                      onPressed: () => _confirmDelete(context, ref),
                      tooltip: 'Eliminar contacto',
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 16),

            _ContactInfoRow(
              icon: Icons.phone_android,
              label: 'Móvil',
              value: contact.telefono,
              colors: colors,
              isPrimary: true,
            ),

            if (contact.telefonoAlternativo != null &&
                contact.telefonoAlternativo!.isNotEmpty)
              _ContactInfoRow(
                icon: Icons.phone_in_talk,
                label: 'Alternativo',
                value: contact.telefonoAlternativo!,
                colors: colors,
              ),

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
    );
  }
}

// ----------------------------------------------------------------------
// 5. Widget auxiliar para mostrar información de contacto
// ----------------------------------------------------------------------

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
