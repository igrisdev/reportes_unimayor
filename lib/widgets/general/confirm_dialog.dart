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

    return PopScope(
      canPop: !isLoading,
      child: AlertDialog(
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: colors.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          widget.message,
          style: GoogleFonts.poppins(color: colors.onSurfaceVariant),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: isLoading ? null : () => Navigator.of(context).pop(),
            child: Text(
              widget.cancelText,
              style: GoogleFonts.poppins(fontSize: 16, color: colors.error),
            ),
          ),
          TextButton(
            onPressed: isLoading
                ? null
                : () async {
                    setState(() => isLoading = true);
                    try {
                      await widget.onConfirm();
                    } finally {
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.onSurface,
                    ),
                  )
                : Text(
                    widget.confirmText,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
