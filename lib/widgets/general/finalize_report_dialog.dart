import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinalizeReportDialog extends StatefulWidget {
  final String title;
  final String message;
  final String hintText;
  final Future<void> Function(String description) onConfirm;

  const FinalizeReportDialog({
    super.key,
    required this.title,
    required this.message,
    required this.hintText,
    required this.onConfirm,
  });

  @override
  State<FinalizeReportDialog> createState() => _FinalizeReportDialogState();
}

class _FinalizeReportDialogState extends State<FinalizeReportDialog> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !isLoading,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.message,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 3,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: isLoading ? null : () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: colorScheme.error,
              ),
            ),
          ),
          TextButton(
            onPressed: _controller.text.trim().isEmpty || isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    setState(() => isLoading = true);
                    try {
                      await widget.onConfirm(_controller.text.trim());
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
                      color: colorScheme.onSurface,
                    ),
                  )
                : Text(
                    'Finalizar',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: colorScheme.primary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
