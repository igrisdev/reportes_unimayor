import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

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
}

final List<EmergencyContact> mockContacts = [
  EmergencyContact(
    id: '1',
    nombre: 'Elena Rodríguez',
    relacion: 'Madre',
    telefono: '3101234567',
    email: 'elena@example.com',
    esPrincipal: true,
  ),
  EmergencyContact(
    id: '2',
    nombre: 'Javier Pérez',
    relacion: 'Hermano',
    telefono: '3209876543',
    telefonoAlternativo: '6015551234',
    esPrincipal: false,
  ),
  EmergencyContact(
    id: '3',
    nombre: 'Dr. López',
    relacion: 'Médico de cabecera',
    telefono: '3001112233',
    esPrincipal: false,
  ),
];

// Provider para obtener la lista de contactos de emergencia
final emergencyContactsListProvider = FutureProvider<List<EmergencyContact>>((
  ref,
) async {
  // Simular un retraso de red de 800ms
  await Future.delayed(const Duration(milliseconds: 800));
  return mockContacts;
});

// ----------------------------------------------------------------------
// 3. WIDGET PRINCIPAL (Lista de Contactos)
// ----------------------------------------------------------------------

// Convertimos a ConsumerWidget ya que solo necesitamos observar el provider
class EmergencyContactsUserScreen extends ConsumerWidget {
  const EmergencyContactsUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final contactsAsyncValue = ref.watch(emergencyContactsListProvider);

    // Path de navegación (obtenido del GoRouter)
    const createContactPath =
        '/user/settings/emergency_contacts/create_emergency_contact';

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
              return _ContactListItem(contact: contact, colors: colors);
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
        onPressed: () => context.go(createContactPath),
        label: Text(
          'Nuevo Contacto',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        icon: const Icon(Icons.person_add),
        backgroundColor: colors.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// 4. WIDGET DE ITEM DE LA LISTA
// ----------------------------------------------------------------------

class _ContactListItem extends StatelessWidget {
  final EmergencyContact contact;
  final ColorScheme colors;

  const _ContactListItem({required this.contact, required this.colors});

  @override
  Widget build(BuildContext context) {
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
              children: [
                Expanded(
                  child: Text(
                    contact.nombre,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (contact.esPrincipal)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.tertiary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.tertiary, width: 1.5),
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
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Relación: ${contact.relacion}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: colors.onSurface.withOpacity(0.7),
              ),
            ),
            const Divider(height: 16),

            // Teléfono Principal
            Row(
              children: [
                Icon(Icons.phone_android, size: 18, color: colors.secondary),
                const SizedBox(width: 8),
                Text(
                  'Móvil: ${contact.telefono}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // Teléfono Alternativo (Si existe)
            if (contact.telefonoAlternativo != null &&
                contact.telefonoAlternativo!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_in_talk,
                      size: 18,
                      color: colors.secondary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Alternativo: ${contact.telefonoAlternativo}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: colors.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

            // Email (Si existe)
            if (contact.email != null && contact.email!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 18,
                      color: colors.secondary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Email: ${contact.email}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: colors.onSurface.withOpacity(0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
