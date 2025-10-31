import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';

class TextNoReports extends ConsumerWidget {
  final bool isBrigadier;
  final bool isHistoryBrigadier;

  const TextNoReports({
    super.key,
    this.isBrigadier = false,
    this.isHistoryBrigadier = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    String text = isBrigadier
        ? "No hay reportes en proceso"
        : "No haz realizado un reporte";

    if (isHistoryBrigadier) {
      text = "No haz finalizado ningún reporte";
    }

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
                  Icons.inbox_outlined,
                  size: 64,
                  color: colorScheme.outlineVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  "Sin Reporte",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: colorScheme.onSurfaceVariant,
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
