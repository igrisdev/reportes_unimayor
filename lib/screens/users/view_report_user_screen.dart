import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/widgets/app_bar_user.dart';
import 'package:reportes_unimayor/widgets/big_badge_view_progress.dart';
import 'package:reportes_unimayor/widgets/date_and_hour_container.dart';
import 'package:reportes_unimayor/widgets/description_report_container.dart';
import 'package:reportes_unimayor/widgets/text_and_title_container.dart';
import 'package:reportes_unimayor/widgets/view_location.dart';

class ViewReportUserScreen extends ConsumerWidget {
  final String id;

  const ViewReportUserScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReport = ref.watch(getReportByIdProvider(id));
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBarUser(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: asyncReport.when(
          data: (report) => infoReport(report, colors),
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

  Padding infoReport(ReportsModel report, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          BigBadgeViewProgress(text: report.estado),
          const SizedBox(height: 20),
          ViewLocation(location: report.ubicacion),
          const SizedBox(height: 30),
          DescriptionReportContainer(
            idReport: report.idReporte,
            description: report.descripcion == '' ? '' : report.descripcion,
            audio: report.rutaAudio == '' ? '' : report.rutaAudio,
          ),
          const SizedBox(height: 30),
          DateAndHourContainer(
            date: report.fechaCreacion,
            hour: report.horaCreacion,
          ),
          const SizedBox(height: 30),
          TextAndTitleContainer(
            title: 'Nota Brigadista',
            description: report.detallesFinalizacion.isNotEmpty
                ? report.detallesFinalizacion
                : 'Sin nota',
          ),
        ],
      ),
    );
  }
}
