import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importar flutter_riverpod
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/settings_provider.dart';

// Modelo de datos para el contacto de emergencia
class EmergencyContact {
  String nombre;
  String relacion;
  String telefono;
  String? telefonoAlternativo;
  String? email;
  bool esPrincipal;

  EmergencyContact({
    required this.nombre,
    required this.relacion,
    required this.telefono,
    this.telefonoAlternativo,
    this.email,
    this.esPrincipal = false,
  });

  // Método de utilidad (aunque ya no es estrictamente necesario aquí)
  Map<String, dynamic> toProviderArgs() {
    return {
      'nombre': nombre,
      'relacion': relacion,
      'telefono': telefono,
      'telefonoAlternativo': telefonoAlternativo,
      'email': email,
      'esPrincipal': esPrincipal,
    };
  }
}

// Clase principal con el nuevo nombre y convertida a ConsumerStatefulWidget
class FormEmergencyContactsUserScreen extends ConsumerStatefulWidget {
  const FormEmergencyContactsUserScreen({super.key});

  @override
  ConsumerState<FormEmergencyContactsUserScreen> createState() =>
      _FormEmergencyContactsUserScreenState();
}

class _FormEmergencyContactsUserScreenState
    extends ConsumerState<FormEmergencyContactsUserScreen> {
  final _formKey = GlobalKey<FormState>();
  EmergencyContact newContact = EmergencyContact(
    nombre: '',
    relacion: '',
    telefono: '',
  );

  bool isLoading = false;

  // Widget de encabezado de sección reutilizable
  Widget _sectionHeader({required String title, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  // Método para el envío del formulario, ahora usando Riverpod
  void _submitForm() async {
    // Desenfocar el teclado
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      try {
        // 1. Llamada real al provider de Riverpod
        final success = await ref.read(
          createEmergencyContactProvider(
            newContact.nombre,
            newContact.relacion,
            newContact.telefono,
            newContact.telefonoAlternativo,
            newContact.email,
            newContact.esPrincipal,
          ).future,
        ); // Usamos .future para esperar el resultado AsyncValue<bool>

        // 2. Manejo de respuesta
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '✅ Contacto guardado con éxito: ${newContact.nombre}',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
            );
            // Si el contacto se guarda con éxito, se puede resetear el formulario
            _formKey.currentState?.reset();
            setState(() {
              newContact = EmergencyContact(
                nombre: '',
                relacion: '',
                telefono: '',
              );
            });
          } else {
            // Esto maneja el caso donde la APIService devuelve 'false'
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '⚠️ Error al guardar el contacto (Respuesta no exitosa).',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } catch (e) {
        // 3. Manejo de excepción (errores de Dio, red, etc.)
        if (mounted) {
          print('Excepción al crear contacto: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❌ Error de conexión o API: ${e.toString()}',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        // 4. Finalizar carga
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo Contacto de Emergencia',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: colors.onSurface,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                title: 'Información Básica *',
                color: colors.primary,
              ),

              // 1. NOMBRE (OBLIGATORIO)
              _buildTextFormField(
                label: 'Nombre Completo',
                icon: Icons.person,
                keyboardType: TextInputType.name,
                onSave: (value) => newContact.nombre = value!,
                validator: (value) =>
                    value!.isEmpty ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 16),

              // 2. RELACIÓN (OBLIGATORIO)
              _buildTextFormField(
                label: 'Relación (Ej: Padre, Amigo, etc.)',
                icon: Icons.family_restroom,
                keyboardType: TextInputType.text,
                onSave: (value) => newContact.relacion = value!,
                validator: (value) =>
                    value!.isEmpty ? 'La relación es obligatoria' : null,
              ),
              const SizedBox(height: 16),

              _sectionHeader(
                title: 'Información de Contacto *',
                color: colors.primary,
              ),

              // 3. TELÉFONO PRINCIPAL (OBLIGATORIO)
              _buildTextFormField(
                label: 'Teléfono Principal',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                onSave: (value) => newContact.telefono = value!,
                validator: (value) => value!.isEmpty
                    ? 'El teléfono principal es obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),

              // 4. TELÉFONO ALTERNATIVO (OPCIONAL)
              _buildTextFormField(
                label: 'Teléfono Alternativo (Opcional)',
                icon: Icons.phone_in_talk,
                keyboardType: TextInputType.phone,
                onSave: (value) => newContact.telefonoAlternativo = value,
                validator: (value) => null, // Opcional, no requiere validación
              ),
              const SizedBox(height: 16),

              // 5. EMAIL (OPCIONAL)
              _buildTextFormField(
                label: 'Correo Electrónico (Opcional)',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                onSave: (value) => newContact.email = value,
                validator: (value) => null, // Opcional, no requiere validación
              ),
              const SizedBox(height: 24),

              // 6. ES PRINCIPAL (BOOLEANO)
              _buildPrincipalCheckbox(colors),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(colors),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
    required void Function(String? value) onSave,
    required String? Function(String? value) validator,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onSaved: onSave,
      validator: validator,
    );
  }

  Widget _buildPrincipalCheckbox(ColorScheme colors) {
    return CheckboxListTile(
      title: Text(
        'Establecer como Contacto Principal',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
        ),
      ),
      value: newContact.esPrincipal,
      onChanged: (bool? value) {
        setState(() {
          newContact.esPrincipal = value!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      checkColor: colors.onPrimary,
      activeColor: colors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSubmitButton(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 60,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          onPressed: isLoading ? null : _submitForm,
          label: Text(
            isLoading ? 'Guardando...' : 'Guardar Contacto',
            style: GoogleFonts.poppins(
              color: colors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Icon(Icons.save, color: colors.onSurface, size: 24),
        ),
      ),
    );
  }
}
