import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';

class TextNoReports extends ConsumerWidget {
  final bool isBrigadier;

  const TextNoReports({super.key, this.isBrigadier = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    String text = isBrigadier
        ? "No hay reportes en proceso"
        : "No tienes reportes creados aún";

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(reportListPendingProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 64,
                  color: colorScheme.outlineVariant, // 🎨 gris del tema
                ),
                const SizedBox(height: 16),
                Text(
                  "Sin Reportes",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: colorScheme.onSurface, // 🎨 texto principal
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: colorScheme.onSurfaceVariant, // 🎨 texto secundario
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
