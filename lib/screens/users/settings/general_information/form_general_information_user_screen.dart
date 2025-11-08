import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:reportes_unimayor/providers/settings_provider.dart';
import 'package:reportes_unimayor/widgets/general/confirm_dialog.dart';
import 'package:reportes_unimayor/widgets/general/show_message_snack_bar_.dart';

class FormGeneralInformationUserScreen extends ConsumerStatefulWidget {
  const FormGeneralInformationUserScreen({super.key});

  @override
  ConsumerState<FormGeneralInformationUserScreen> createState() =>
      _FormGeneralInformationUserScreenState();
}

class _FormGeneralInformationUserScreenState
    extends ConsumerState<FormGeneralInformationUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _telefonoController;
  late TextEditingController _cedulaController;
  late TextEditingController _codigoInstitucionalController;

  bool _aceptaTerminos = false;
  bool _showErrorTerminos = false;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _telefonoController = TextEditingController();
    _cedulaController = TextEditingController();
    _codigoInstitucionalController = TextEditingController();

    Future.microtask(() async {
      try {
        final datos = await ref.read(personalDataProvider.future);
        _telefonoController.text = datos['numeroTelefonico'] ?? '';
        _cedulaController.text = datos['cedula'] ?? '';
        _codigoInstitucionalController.text =
            datos['codigoInstitucional'] ?? '';
      } catch (e) {
        debugPrint('Error cargando datos personales: $e');
      } finally {
        if (mounted) {
          setState(() => _cargando = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _telefonoController.dispose();
    _cedulaController.dispose();
    _codigoInstitucionalController.dispose();
    super.dispose();
  }

  Future<void> _performSave() async {
    final ok = await ref.read(
      updatePersonalDataProvider(
        _telefonoController.text.trim(),
        _cedulaController.text.trim(),
        _codigoInstitucionalController.text.trim(),
      ).future,
    );

    if (mounted) {
      if (ok) {
        ref.invalidate(personalDataProvider);
        context.pop();
        showMessageSnackBar(
          context,
          message: 'Datos personales actualizados correctamente',
          type: SnackBarType.success,
        );
      } else {
        showMessageSnackBar(
          context,
          message: 'Error al actualizar los datos personales',
          type: SnackBarType.error,
        );
      }
    }
  }

  void _onSavePressed() {
    FocusScope.of(context).unfocus();

    if (!_aceptaTerminos) {
      setState(() => _showErrorTerminos = true);
      return;
    } else {
      setState(() => _showErrorTerminos = false);
    }

    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Confirmar cambios',
        message: '¿Deseas guardar los cambios en tu información general?',
        onConfirm: _performSave,
        confirmText: 'Guardar',
        cancelText: 'Cancelar',
      ),
    );
  }

  Widget _buildCheckbox(ColorScheme colors) {
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
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push('/terms-and-conditions');
                        },
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
                FocusScope.of(context).unfocus();
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: colors.primary,
              checkColor: colors.onPrimary,
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Información',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: colors.onSurface,
          ),
        ),
      ),
      body: _cargando
          ? Center(
              child: CircularProgressIndicator(
                color: colors.primary,
                strokeWidth: 3,
              ),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información General',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _CampoTexto(
                        label: 'Número telefónico',
                        controller: _telefonoController,
                        icono: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      _CampoTexto(
                        label: 'Cédula',
                        controller: _cedulaController,
                        icono: Icons.badge,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      _CampoTexto(
                        label: 'Código institucional',
                        controller: _codigoInstitucionalController,
                        icono: Icons.account_balance,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),

                      _buildCheckbox(colors),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: _cargando
          ? null
          : Padding(
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
                  onPressed: _onSavePressed,
                  icon: Icon(Icons.check, color: colors.onSurface, size: 24),
                  label: Text(
                    'Guardar Cambios',
                    style: GoogleFonts.poppins(
                      color: colors.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _CampoTexto extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icono;
  final TextInputType? keyboardType;

  const _CampoTexto({
    required this.label,
    required this.controller,
    required this.icono,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icono, color: colors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.8),
        ),
      ),
    );
  }
}
