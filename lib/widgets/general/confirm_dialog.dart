import 'package:flutter/material.dart';

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
        title: Text(widget.title, style: TextStyle(color: colors.onSurface)),
        content: Text(
          widget.message,
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: isLoading ? null : () => Navigator.of(context).pop(),
            child: Text(
              widget.cancelText,
              style: TextStyle(color: colors.primary),
            ),
          ),
          TextButton(
            onPressed: isLoading
                ? null
                : () async {
                    setState(() => isLoading = true);
                    await widget.onConfirm();
                    if (mounted) Navigator.of(context).pop();
                  },
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  )
                : Text(
                    widget.confirmText,
                    style: TextStyle(color: colors.error),
                  ),
          ),
        ],
      ),
    );
  }
}
