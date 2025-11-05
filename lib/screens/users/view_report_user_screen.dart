import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/widgets/general/text_cancel.dart';
import 'package:reportes_unimayor/widgets/general/text_health_assistance.dart';
import 'package:reportes_unimayor/widgets/general/big_badge_view_progress.dart';
import 'package:reportes_unimayor/widgets/general/date_and_hour_container.dart';
import 'package:reportes_unimayor/widgets/general/description_report_container.dart';
import 'package:reportes_unimayor/widgets/general/text_note_brigadier.dart';
import 'package:reportes_unimayor/widgets/general/view_location.dart';

class ViewReportUserScreen extends ConsumerWidget {
  final String id;

  const ViewReportUserScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReport = ref.watch(getReportByIdProvider(id));
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles del Reporte',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: colors.onSurface,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: asyncReport.when(
          data: (report) =>
              SingleChildScrollView(child: infoReport(report, colors)),
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
              style: TextStyle(color: colors.error),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget infoReport(ReportsModel report, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigBadgeViewProgress(text: report.estado),
          const SizedBox(height: 20),
          if (report.estado == 'Cancelado')
            TextCancel(
              title: 'Motivo de cancelación',
              description: report.motivoCancelacion.isNotEmpty
                  ? report.motivoCancelacion
                  : 'Sin motivo',
            ),

          TextNoteBrigadier(
            title: 'Nota Brigadista',
            description: report.detallesFinalizacion.isNotEmpty
                ? report.detallesFinalizacion
                : 'Sin nota',
          ),
          const SizedBox(height: 20),
          Divider(height: 1),
          const SizedBox(height: 10),
          ViewLocation(
            location: report.ubicacion,
            ubicacionTextOpcional: report.ubicacionTextOpcional,
          ),
          const SizedBox(height: 20),
          TextHealthAssistance(isForMy: report.paraMi),
          const SizedBox(height: 10),
          DescriptionReportContainer(
            idReport: report.idReporte,
            description: report.descripcion.isNotEmpty
                ? report.descripcion
                : '',
            audio: report.rutaAudio.isNotEmpty ? report.rutaAudio : '',
            isTextBig: true,
          ),
          const SizedBox(height: 10),
          DateAndHourContainer(
            date: report.fechaCreacion,
            hour: report.horaCreacion,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
