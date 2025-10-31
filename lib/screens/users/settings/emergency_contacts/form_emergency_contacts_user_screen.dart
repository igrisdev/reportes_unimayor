import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/emergency_contact.dart';
import 'package:reportes_unimayor/providers/settings_provider.dart';
import 'package:reportes_unimayor/widgets/general/confirm_dialog.dart';

class FormEmergencyContactsUserScreen extends ConsumerStatefulWidget {
  final String? contactId;

  const FormEmergencyContactsUserScreen({super.key, this.contactId});

  @override
  ConsumerState<FormEmergencyContactsUserScreen> createState() =>
      _FormEmergencyContactsUserScreenState();
}

class _FormEmergencyContactsUserScreenState
    extends ConsumerState<FormEmergencyContactsUserScreen> {
  final _formKey = GlobalKey<FormState>();
  EmergencyContact newContact = EmergencyContact(
    id: '',
    nombre: '',
    relacion: '',
    telefono: '',
  );

  bool _isFetching = false;
  bool _isEditing = false;
  bool _aceptaTerminos = false;
  bool _showErrorTerminos = false;

  late TextEditingController _nombreController;
  late TextEditingController _relacionController;
  late TextEditingController _telefonoController;
  late TextEditingController _telefonoAlternativoController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.contactId != null && widget.contactId!.isNotEmpty;

    _nombreController = TextEditingController();
    _relacionController = TextEditingController();
    _telefonoController = TextEditingController();
    _telefonoAlternativoController = TextEditingController();
    _emailController = TextEditingController();

    if (_isEditing) {
      _loadContactData();
    }
  }

  void _loadContactData() async {
    setState(() => _isFetching = true);
    try {
      final contact = await ref.read(
        emergencyContactByIdProvider(widget.contactId!).future,
      );

      if (mounted && contact != null) {
        newContact = contact;
        _nombreController.text = contact.nombre;
        _relacionController.text = contact.relacion;
        _telefonoController.text = contact.telefono;
        _telefonoAlternativoController.text = contact.telefonoAlternativo ?? '';
        _emailController.text = contact.email ?? '';
      }
    } catch (e) {
      print('Error al cargar contacto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Error al cargar el contacto.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _relacionController.dispose();
    _telefonoController.dispose();
    _telefonoAlternativoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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

  Future<void> _performSubmit() async {
    try {
      bool success;
      if (_isEditing) {
        success = await ref.read(
          updateEmergencyContactProvider(
            newContact.id,
            newContact.nombre,
            newContact.relacion,
            newContact.telefono,
            newContact.telefonoAlternativo,
            newContact.email,
            newContact.esPrincipal,
          ).future,
        );
      } else {
        success = await ref.read(
          createEmergencyContactProvider(
            newContact.nombre,
            newContact.relacion,
            newContact.telefono,
            newContact.telefonoAlternativo,
            newContact.email,
            newContact.esPrincipal,
          ).future,
        );
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Contacto ${_isEditing ? 'actualizado' : 'guardado'} con éxito: ${newContact.nombre}',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              behavior: SnackBarBehavior.floating,
            ),
          );

          if (!_isEditing) {
            _formKey.currentState?.reset();
            _nombreController.clear();
            _relacionController.clear();
            _telefonoController.clear();
            _telefonoAlternativoController.clear();
            _emailController.clear();
            setState(() {
              newContact = EmergencyContact(
                id: '',
                nombre: '',
                relacion: '',
                telefono: '',
                telefonoAlternativo: '',
                email: '',
                esPrincipal: false,
              );
              _aceptaTerminos = false;
              _showErrorTerminos = false;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '⚠️ Error al ${_isEditing ? 'actualizar' : 'guardar'} el contacto.',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        print('Error al guardar contacto: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Error de conexión o API: ${e.toString()}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) ref.invalidate(emergencyContactsListProvider);
    }
  }

  void _onSubmitPressed() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_aceptaTerminos) {
      setState(() => _showErrorTerminos = true);
      return;
    } else {
      setState(() => _showErrorTerminos = false);
    }

    _formKey.currentState!.save();

    final action = _isEditing ? 'actualizar' : 'guardar';
    final title = _isEditing ? 'Confirmar actualización' : 'Confirmar guardado';
    final confirmText = _isEditing ? 'Actualizar' : 'Guardar';

    final message =
        '¿Deseas $action el contacto "${newContact.nombre}" con teléfono ${newContact.telefono}?';

    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: 'Cancelar',
        onConfirm: () async => await _performSubmit(),
      ),
    );
  }

  Widget _buildTerminosCheckbox(ColorScheme colors) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: Text.rich(
                TextSpan(
                  text: 'He leído y acepto los ',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: colors.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: 'Términos y Condiciones ',
                      style: GoogleFonts.poppins(
                        color: colors.primary,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(
                      text: 'sobre el tratamiento de mis datos personales.',
                    ),
                  ],
                ),
              ),
              value: _aceptaTerminos,
              onChanged: (bool? value) {
                setInnerState(() {
                  _aceptaTerminos = value ?? false;
                  _showErrorTerminos = false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              checkColor: colors.onPrimary,
              activeColor: colors.primary,
              contentPadding: EdgeInsets.zero,
            ),
            if (_showErrorTerminos)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  'Debes aceptar los Términos y Condiciones',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final title = _isEditing ? 'Editar Contacto' : 'Nuevo Contacto';

    if (_isEditing && _isFetching) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title, style: GoogleFonts.poppins(fontSize: 24)),
        ),
        body: Center(child: CircularProgressIndicator(color: colors.primary)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: colors.onSurface,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
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
                _buildTextFormField(
                  controller: _nombreController,
                  label: 'Nombre Completo',
                  icon: Icons.person,
                  keyboardType: TextInputType.name,
                  onSave: (value) => newContact.nombre = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'El nombre es obligatorio' : null,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _relacionController,
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
                _buildTextFormField(
                  controller: _telefonoController,
                  label: 'Teléfono Principal',
                  icon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                  onSave: (value) => newContact.telefono = value!,
                  validator: (value) => value!.isEmpty
                      ? 'El teléfono principal es obligatorio'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _telefonoAlternativoController,
                  label: 'Teléfono Alternativo (Opcional)',
                  icon: Icons.phone_in_talk,
                  keyboardType: TextInputType.phone,
                  onSave: (value) => newContact.telefonoAlternativo = value,
                  validator: (value) => null,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _emailController,
                  label: 'Correo Electrónico (Opcional)',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  onSave: (value) => newContact.email = value,
                  validator: (value) => null,
                ),
                const SizedBox(height: 24),
                _buildPrincipalCheckbox(colors),
                const SizedBox(height: 8),
                _buildTerminosCheckbox(colors),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(colors),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
    required void Function(String? value) onSave,
    required String? Function(String? value) validator,
  }) {
    return TextFormField(
      controller: controller,
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
    return StatefulBuilder(
      builder: (context, setInnerState) {
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
            setInnerState(() => newContact.esPrincipal = value!);
          },
          controlAffinity: ListTileControlAffinity.leading,
          checkColor: colors.onPrimary,
          activeColor: colors.primary,
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }

  Widget _buildSubmitButton(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 70,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          onPressed: _isFetching ? null : _onSubmitPressed,
          label: Text(
            _isEditing ? 'Actualizar Contacto' : 'Guardar Contacto',
            style: GoogleFonts.poppins(
              color: colors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(
            _isEditing ? Icons.update : Icons.save,
            color: colors.onSurface,
            size: 24,
          ),
        ),
      ),
    );
  }
}
