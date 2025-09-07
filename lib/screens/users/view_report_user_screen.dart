import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/widgets/app_bar_user.dart';
import 'package:reportes_unimayor/widgets/big_badge_view_progress.dart';
import 'package:reportes_unimayor/widgets/date_and_hour_container.dart';
import 'package:reportes_unimayor/widgets/text_and_title_container.dart';
import 'package:reportes_unimayor/widgets/view_location.dart';

class ViewReportUserScreen extends ConsumerWidget {
  final String id;

  const ViewReportUserScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReport = ref.watch(getReportByIdProvider(id));
    final colors = Theme.of(context).colorScheme; // ✅ Colores dinámicos

    return Scaffold(
      appBar: AppBarUser(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: asyncReport.when(
          data: (report) => infoReport(report, colors),
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
              style: TextStyle(color: colors.error), // ✅ usa esquema de error
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      bottomNavigationBar: asyncReport.maybeWhen(
        data: (report) => report.estado == 'Pendiente'
            ? bottomAppBarMain(context, ref, report.idReporte, colors)
            : null,
        orElse: () => null,
      ),
    );
  }

  BottomAppBar bottomAppBarMain(
    BuildContext context,
    WidgetRef ref,
    int id,
    ColorScheme colors,
  ) {
    final router = GoRouter.of(context);
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      height: 90,
      child: Material(
        color: colors.errorContainer, // ✅ Fondo de advertencia
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () async {
            final response = await ref.read(CancelReportProvider(id).future);

            if (response == true) {
              router.push('/user');
              return;
            }
          },
          borderRadius: BorderRadius.circular(100),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Cancelar Reporte",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colors.tertiary, // ✅ Texto con color de "éxito"
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.cancel, color: colors.tertiary), // ✅ Ícono igual
              ],
            ),
          ),
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
          TextAndTitleContainer(
            title: report.descripcion == '' ? 'Audio' : 'Descripción',
            description: report.descripcion == ''
                ? report.rutaAudio
                : report.descripcion,
            idReport: report.idReporte,
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
