import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';
import 'package:reportes_unimayor/widgets/app_bar_brigadier.dart';
import 'package:reportes_unimayor/widgets/date_and_hour_container.dart';
import 'package:reportes_unimayor/widgets/text_and_title_container.dart';
import 'package:reportes_unimayor/widgets/view_location.dart';

class ViewReportBrigadierScreen extends ConsumerWidget {
  final String id;

  const ViewReportBrigadierScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReport = ref.watch(getReportByIdBrigadierProvider(id));

    return Scaffold(
      appBar: AppBarBrigadier(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: asyncReport.when(
          // data: (report) => infoReport(report),
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
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      bottomNavigationBar: asyncReport.maybeWhen(
        data: (report) => report.estado == 'Pendiente'
            ? bottomAppBarMainPending(context, ref, report.idReporte)
            : report.estado == 'En proceso'
            ? bottomAppBarMainInProgress(context, ref, report.idReporte)
            : null,
        orElse: () => null, // Por defecto no mostrar
      ),
    );
  }

  BottomAppBar bottomAppBarMainInProgress(
    BuildContext context,
    WidgetRef ref,
    int id,
  ) {
    final router = GoRouter.of(context);
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      height: 90,
      child: Material(
        color: lightMode.colorScheme.primaryFixed,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () async {
            final response = await ref.read(EndReportProvider(id).future);

            if (response == true) {
              router.push('/brigadier');
              return;
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
                    color: lightMode.colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.check, color: lightMode.colorScheme.tertiary),
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
  ) {
    final router = GoRouter.of(context);
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      height: 90,
      child: Material(
        color: const Color(0xFF338838),
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () async {
            final response = await ref.read(AcceptReportProvider(id).future);

            if (response == true) {
              router.push('/brigadier');
              return;
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
                    color: lightMode.colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.check, color: lightMode.colorScheme.tertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox infoReport(ReportsModel report, BuildContext context) {
    return SizedBox(
      height: MediaQueryData.fromView(View.of(context)).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewLocation(location: report.ubicacion),
          SizedBox(height: 20),
          TextAndTitleContainer(
            title: 'Descripción',
            description: report.descripcion,
          ),
          SizedBox(height: 20),
          DateAndHourContainer(
            date: report.fechaCreacion,
            hour: report.horaCreacion,
          ),
        ],
      ),
    );
  }
}
