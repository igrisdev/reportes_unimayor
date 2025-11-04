import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/settings_provider.dart';
import 'package:reportes_unimayor/widgets/general/confirm_dialog.dart';

class FormMedicalInformationUserScreen extends ConsumerStatefulWidget {
  final String? conditionId;

  const FormMedicalInformationUserScreen({super.key, this.conditionId});

  @override
  ConsumerState<FormMedicalInformationUserScreen> createState() =>
      _FormMedicalInformationUserScreenState();
}

class _FormMedicalInformationUserScreenState
    extends ConsumerState<FormMedicalInformationUserScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  bool _isFetching = false;
  bool _aceptaTerminos = false;
  bool _showErrorTerminos = false;
  bool _showErrorFecha = false;

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  DateTime? _fechaDiagnostico;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.conditionId != null && widget.conditionId!.isNotEmpty;

    _nombreController = TextEditingController();
    _descripcionController = TextEditingController();

    if (_isEditing) {
      _loadCondition();
    }
  }

  Future<void> _loadCondition() async {
    setState(() => _isFetching = true);

    try {
      final condition = await ref.read(
        medicalConditionByIdProvider(widget.conditionId!).future,
      );
      if (mounted && condition != null) {
        _nombreController.text = condition.nombre;
        _descripcionController.text = condition.descripcion;
        _fechaDiagnostico = condition.fechaDiagnostico;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Error al cargar: ${e.toString()}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
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
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final initialDate = _fechaDiagnostico ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() {
        _fechaDiagnostico = picked;
        _showErrorFecha = false;
      });
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _performSave() async {
    FocusScope.of(context).unfocus();
    if (_fechaDiagnostico == null) return;

    try {
      bool success;
      if (_isEditing) {
        success = await ref.read(
          updateMedicalConditionProvider(
            widget.conditionId!,
            _nombreController.text.trim(),
            _descripcionController.text.trim(),
            _fechaDiagnostico!,
          ).future,
        );
      } else {
        success = await ref.read(
          createMedicalConditionProvider(
            _nombreController.text.trim(),
            _descripcionController.text.trim(),
            _fechaDiagnostico!,
          ).future,
        );
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Condición ${_isEditing ? 'actualizada' : 'guardada'} con éxito',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              behavior: SnackBarBehavior.floating,
            ),
          );

          if (!_isEditing) {
            _formKey.currentState?.reset();
            _nombreController.clear();
            _descripcionController.clear();
            setState(() {
              _fechaDiagnostico = null;
              _aceptaTerminos = false;
              _showErrorTerminos = false;
              _showErrorFecha = false;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '⚠️ Error al ${_isEditing ? 'actualizar' : 'guardar'} la condición',
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Error: ${e.toString()}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      ref.invalidate(medicalConditionsListProvider);
    }
  }

  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) return;

    // Validar fecha de diagnóstico
    if (_fechaDiagnostico == null) {
      setState(() => _showErrorFecha = true);
      return;
    } else {
      setState(() => _showErrorFecha = false);
    }

    // Validar términos
    if (!_aceptaTerminos) {
      setState(() => _showErrorTerminos = true);
      return;
    } else {
      setState(() => _showErrorTerminos = false);
    }

    final action = _isEditing ? 'actualizar' : 'guardar';
    final title = _isEditing ? 'Confirmar actualización' : 'Confirmar guardado';
    final confirmText = _isEditing ? 'Actualizar' : 'Guardar';
    final message =
        '¿Deseas $action la condición "${_nombreController.text.trim()}"?';

    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: title,
          message: message,
          onConfirm: () async {
            await _performSave();
          },
          confirmText: confirmText,
          cancelText: 'Cancelar',
        );
      },
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

                FocusScope.of(context).unfocus();
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

  Widget _buildFechaDiagnostico(ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha de Diagnóstico *',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.onSurface.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _fechaDiagnostico == null
                        ? 'Seleccionar fecha'
                        : _fechaDiagnostico!
                              .toLocal()
                              .toString()
                              .split(' ')
                              .first,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_month),
              label: Text('Seleccionar', style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        if (_showErrorFecha)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              'Selecciona la fecha de diagnóstico',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final title = _isEditing ? 'Editar Condición' : 'Nueva Condición';

    if (_isEditing && _isFetching) {
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Información Básica *',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nombreController,
                  style: GoogleFonts.poppins(fontSize: 18),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la Condición',
                    prefixIcon: const Icon(Icons.medical_services),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'El nombre es obligatorio'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionController,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  style: GoogleFonts.poppins(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'La descripción es obligatoria'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildFechaDiagnostico(colors),
                const SizedBox(height: 16),
                _buildTerminosCheckbox(colors),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
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
            onPressed: _isFetching ? null : _onSavePressed,
            icon: Icon(
              _isEditing ? Icons.update : Icons.save,
              color: colors.onSurface,
              size: 24,
            ),
            label: Text(
              _isEditing ? 'Actualizar Condición' : 'Guardar Condición',
              style: GoogleFonts.poppins(
                color: colors.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
