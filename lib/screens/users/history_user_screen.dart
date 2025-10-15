import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/widgets/users/app_bar_user.dart';
import 'package:reportes_unimayor/widgets/general/date_and_hour_container.dart';
import 'package:reportes_unimayor/widgets/users/drawer_user.dart';
import 'package:reportes_unimayor/widgets/general/text_note_brigadier.dart';
import 'package:reportes_unimayor/widgets/general/text_no_reports.dart';
import 'package:reportes_unimayor/widgets/general/view_location.dart';

class HistoryUserScreen extends ConsumerWidget {
  const HistoryUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportListProvider);

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBarUser(),
      drawer: DrawerUser(context: context),
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
                            color: colors.onSurface, // ← texto principal
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
                  child: _buildReportsList(reports, context, colors),
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

  Widget _buildReportsList(
    List<ReportsModel> reports,
    BuildContext context,
    ColorScheme colors,
  ) {
    final router = GoRouter.of(context);

    if (reports.isEmpty) {
      return const TextNoReports();
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];

        if (report.estado == 'Pendiente' || report.estado == 'En proceso') {
          return const SizedBox.shrink();
        }

        final isFinalized = report.estado == 'Finalizado';

        Color colorBackground = isFinalized ? colors.primary : colors.error;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline), // borde del tema
              borderRadius: BorderRadius.circular(5),
              color: colors.surface, // fondo del card
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ViewLocation(location: report.ubicacion),
                const SizedBox(height: 10),
                TextNoteBrigadier(
                  title: 'Nota Brigadista',
                  description: report.detallesFinalizacion.isNotEmpty
                      ? report.detallesFinalizacion
                      : 'Sin nota',
                ),
                if (report.detallesFinalizacion.isNotEmpty)
                  const SizedBox(height: 10),
                DateAndHourContainer(
                  date: report.fechaCreacion,
                  hour: report.horaCreacion,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorBackground,
                          borderRadius: BorderRadius.circular(5),
                        ),
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
                              color: colors.onPrimary, // texto sobre botón
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          router.push('/user/report/${report.idReporte}');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: colors.outline),
                            borderRadius: BorderRadius.circular(100),
                          ),
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
                                color: colors.onSurface, // texto general
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
