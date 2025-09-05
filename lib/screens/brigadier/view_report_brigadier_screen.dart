import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/widgets/app_bar_brigadier.dart';
import 'package:reportes_unimayor/widgets/date_and_hour_container.dart';
import 'package:reportes_unimayor/widgets/info_user.dart';
import 'package:reportes_unimayor/widgets/text_and_title_container.dart';
import 'package:reportes_unimayor/widgets/view_location.dart';

class ViewReportBrigadierScreen extends ConsumerWidget {
  final String id;

  const ViewReportBrigadierScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReport = ref.watch(getReportByIdBrigadierProvider(id));
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface, // antes tenía un gris fijo
      appBar: const AppBarBrigadier(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: asyncReport.when(
          data: (report) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(getReportByIdBrigadierProvider(id));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: infoReport(report, context),
            ),
          ),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () =>
              Center(child: CircularProgressIndicator(color: colors.primary)),
        ),
      ),
      bottomNavigationBar: asyncReport.maybeWhen(
        data: (report) => switch (report.estado) {
          'Pendiente' => bottomAppBarMainPending(
            context,
            ref,
            report.idReporte,
            colors,
          ),
          'En proceso' => bottomAppBarMainInProgress(
            context,
            ref,
            report.idReporte,
            colors,
          ),
          _ => null,
        },
        orElse: () => null,
      ),
    );
  }

  BottomAppBar bottomAppBarMainInProgress(
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
        color: colors.primary, // usas el color principal del tema
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () async {
            final response = await ref.read(EndReportProvider(id).future);
            if (response == true) {
              router.push('/brigadier');
            }
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Finalizar Reporte",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colors.onPrimary, // texto legible sobre primary
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.check, color: colors.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomAppBar bottomAppBarMainPending(
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
        color: colors.tertiary, // ejemplo: verde de “acción positiva”
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () async {
            final response = await ref.read(AcceptReportProvider(id).future);
            if (response == true) {
              router.push('/brigadier');
            }
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Aceptar Reporte",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colors.onTertiary, // contraste automático
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.check, color: colors.onTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox infoReport(ReportsModel report, BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewLocation(location: report.ubicacion),
          const SizedBox(height: 20),
          TextAndTitleContainer(
            title: report.descripcion.isEmpty ? 'Audio' : 'Descripción',
            description: report.descripcion.isEmpty
                ? report.rutaAudio
                : report.descripcion,
            idReport: report.idReporte,
          ),
          const SizedBox(height: 20),
          DateAndHourContainer(
            date: report.fechaCreacion,
            hour: report.horaCreacion,
          ),
          const SizedBox(height: 20),
          InfoUser(
            name: report.usuario.nombre ?? "",
            email: report.usuario.correo,
          ),
        ],
      ),
    );
  }
}
