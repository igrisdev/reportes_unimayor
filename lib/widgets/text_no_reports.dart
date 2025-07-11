import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';

class TextNoReports extends ConsumerWidget {
  final bool isBrigadier;

  const TextNoReports({super.key, this.isBrigadier = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          height: MediaQueryData.fromView(View.of(context)).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "Sin Reportes",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[500],
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
