import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Future<void> Function() onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = "Sí",
    this.cancelText = "No",
  });

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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

    return PopScope(
      canPop: !isLoading,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          widget.message,
          style: GoogleFonts.poppins(color: colors.onSurfaceVariant),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: isLoading ? null : () => Navigator.of(context).pop(),
            style: _buttonStyle(
              enabledBg: colors.error,
              disabledBg: Colors.grey.shade400,
              enabledFg: colors.onError,
              disabledFg: Colors.grey.shade800,
            ),
            child: Text(
              widget.cancelText,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Confirmar: muestra loader cuando isLoading, y queda deshabilitado mientras
          TextButton(
            onPressed: isLoading
                ? null
                : () async {
                    setState(() => isLoading = true);
                    try {
                      await widget.onConfirm();
                    } finally {
                      if (mounted) Navigator.of(context).pop();
                    }
                  },
            style: _buttonStyle(
              enabledBg: colors.primary,
              disabledBg: colors.primary.withOpacity(0.6),
              enabledFg: colors.onPrimary,
              disabledFg: colors.onPrimary.withOpacity(0.8),
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.onPrimary,
                    ),
                  )
                : Text(
                    widget.confirmText,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
