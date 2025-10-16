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
        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isConfirmDisabled = _controller.text.trim().isEmpty || isLoading;

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
            style: _buttonStyle(
              enabledBg: colorScheme.error,
              disabledBg: Colors.grey.shade400,
              enabledFg: colorScheme.onError,
              disabledFg: Colors.grey.shade800,
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          TextButton(
            onPressed: isConfirmDisabled
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
            style: _buttonStyle(
              enabledBg: colorScheme.primary,
              disabledBg: Colors.grey.shade400,
              enabledFg: colorScheme.onError,
              disabledFg: Colors.grey.shade800,
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  )
                : Text(
                    'Finalizar',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
