import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

const List<String> _cancellationReasons = [
  'El reporte fue creado por error',
  'La emergencia ya fue atendida por otros medios',
  'La situación se resolvió por sí sola',
  'Otro motivo',
];

class CancelDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Future<void> Function(String reason) onConfirm;

  const CancelDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = "Sí",
    this.cancelText = "No",
  });

  @override
  State<CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<CancelDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _selectedReason;
  final _otherReasonController = TextEditingController();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void _handleConfirm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final String finalReason = (_selectedReason == 'Otro motivo')
        ? _otherReasonController.text.trim()
        : _selectedReason!;

    try {
      await widget.onConfirm(finalReason);
    } finally {
      if (mounted) context.pop();
    }
  }

  ButtonStyle _buttonStyle({
    required Color enabledBg,
    required Color disabledBg,
    required Color enabledFg,
    required Color disabledFg,
  }) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.disabled)) return disabledBg;
        return enabledBg;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.disabled)) return disabledFg;
        return enabledFg;
      }),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bool showOtherReasonField = _selectedReason == 'Otro motivo';

    return PopScope(
      canPop: !_isLoading,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.message, style: GoogleFonts.poppins()),
                const SizedBox(height: 24),

                // --- DROPDOWN CON LA CORRECCIÓN PARA TEXTO MULTILÍNEA ---
                DropdownButtonFormField<String>(
                  value: _selectedReason,
                  hint: const Text('Seleccione un motivo...'),
                  isExpanded:
                      true, // Importante para que el child ocupe todo el ancho
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: _cancellationReasons.map((String reason) {
                    return DropdownMenuItem<String>(
                      value: reason,
                      // La solución es envolver el Text en un SizedBox.
                      child: SizedBox(
                        // Ancho arbitrario, el Dropdown lo ajustará.
                        width: 200,
                        child: Text(
                          reason,
                          softWrap:
                              true, // La propiedad clave para el salto de línea.
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Debe seleccionar un motivo' : null,
                ),

                // --- FIN DE LA CORRECCIÓN ---
                const SizedBox(height: 16),

                if (showOtherReasonField)
                  TextFormField(
                    controller: _otherReasonController,
                    minLines: 2,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Especifique el motivo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (showOtherReasonField &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Debe especificar el motivo';
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: _buttonStyle(
              enabledBg: colors.error,
              disabledBg: Colors.grey.shade400,
              enabledFg: colors.onError,
              disabledFg: Colors.grey.shade800,
            ),
            child: Text(widget.cancelText),
          ),
          FilledButton(
            onPressed: _isLoading ? null : _handleConfirm,
            style: _buttonStyle(
              enabledBg: colors.primary,
              disabledBg: colors.primary.withOpacity(0.6),
              enabledFg: colors.onPrimary,
              disabledFg: colors.onPrimary.withOpacity(0.8),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(widget.confirmText),
          ),
        ],
      ),
    );
  }
}
