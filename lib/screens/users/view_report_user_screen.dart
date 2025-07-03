import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/components/app_bar_user.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';

class ViewReportUserScreen extends ConsumerWidget {
  final String id;

  const ViewReportUserScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReport = ref.watch(getReportByIdProvider(id));

    return Scaffold(
      appBar: AppBarUser(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: asyncReport.when(
          data: (report) => infoReport(report),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Column infoReport(ReportsModel report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                report.ubicacion.nombre,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: lightMode.colorScheme.secondary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 5,
                  bottom: 5,
                ),
                child: Text(
                  report.estado,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              '${report.horaCreacion.split(':').first}:${report.horaCreacion.split(':')[1]}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Text('  |  ', style: GoogleFonts.poppins(fontSize: 16)),
            Text(
              '${report.fechaCreacion.day.toString()} - ${report.fechaCreacion.month} - ${report.fechaCreacion.year.toString()}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 13),
        Column(
          children: [
            Text(report.descripcion, style: GoogleFonts.poppins(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
