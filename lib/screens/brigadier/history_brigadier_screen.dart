import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/widgets/app_bar_brigadier.dart';
import 'package:reportes_unimayor/widgets/date_and_hour_container.dart';
import 'package:reportes_unimayor/widgets/drawer_brigadier.dart';
import 'package:reportes_unimayor/widgets/text_and_title_container.dart';
import 'package:reportes_unimayor/widgets/text_no_reports.dart';
import 'package:reportes_unimayor/widgets/view_location.dart';

class HistoryBrigadierScreen extends ConsumerWidget {
  const HistoryBrigadierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportListHistoryBrigadierProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      appBar: AppBarBrigadier(),
      drawer: DrawerBrigadier(context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            reportsAsync.maybeWhen(
              data: (reports) =>
                  reports.isNotEmpty &&
                      reports.first.estado != 'En proceso' &&
                      reports.first.estado != 'Pendiente'
                  ? Column(
                      children: [
                        Text(
                          'Historial de Reportes',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: reportsAsync.when(
                data: (reports) => RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(reportListProvider);
                  },
                  child: _buildReportsList(reports, context),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Center(child: Text('Error al cargar los reportes: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsList(List<ReportsModel> reports, BuildContext context) {
    final router = GoRouter.of(context);

    if (reports.isEmpty) {
      return TextNoReports();
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];

        final isFinalized = report.estado == 'Finalizado';

        Color colorBackground = isFinalized
            ? const Color(0xFF3882F1)
            : Color(0xFFFF3737);

        if (report.estado == 'Pendiente' || report.estado == 'En proceso') {
          return null;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ViewLocation(location: report.ubicacion),
                SizedBox(height: 20),
                TextAndTitleContainer(
                  title: report.descripcion == '' ? 'Audio' : 'Descripción',
                  description: report.descripcion == ''
                      ? report.rutaAudio
                      : report.descripcion,
                ),
                SizedBox(height: 20),
                DateAndHourContainer(
                  date: report.fechaCreacion,
                  hour: report.horaCreacion,
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorBackground,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 20,
                          ),
                          child: Center(
                            child: Text(
                              report.estado,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          router.push('/brigadier/report/${report.idReporte}');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            child: Center(
                              child: Text(
                                'Ver Más',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
