import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';
import 'package:reportes_unimayor/widgets/app_bar_user.dart';
import 'package:reportes_unimayor/widgets/big_badge_view_progress.dart';
import 'package:reportes_unimayor/widgets/date_and_hour_container.dart';
import 'package:reportes_unimayor/widgets/drawer_user.dart';
import 'package:reportes_unimayor/widgets/text_and_title_container.dart';
import 'package:reportes_unimayor/widgets/text_no_reports.dart';
import 'package:reportes_unimayor/widgets/text_note.dart';
import 'package:reportes_unimayor/widgets/view_location.dart';

class MainUserScreen extends ConsumerStatefulWidget {
  const MainUserScreen({super.key});

  @override
  ConsumerState<MainUserScreen> createState() => _MainUserScreenState();
}

class _MainUserScreenState extends ConsumerState<MainUserScreen> {
  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(reportListPendingProvider);

    final idReport = reportsAsync.whenData(
      (reports) => reports.isNotEmpty ? reports.first.idReporte : null,
    );

    final stateReport = reportsAsync.whenData(
      (reports) => reports.isNotEmpty ? reports.first.estado : null,
    );

    return Scaffold(
      appBar: const AppBarUser(),
      drawer: DrawerUser(context: context),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: reportsAsync.when(
                data: (reports) => RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(reportListPendingProvider);
                  },
                  child: _buildReportsList(reports, context, ref),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _buildErrorWidget(error, ref),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: reportsAsync.maybeWhen(
        data: (reports) {
          if (reports.isEmpty) {
            return buttonAppBarCreateReport(context);
          }
          if (stateReport.value == 'Pendiente') {
            return buttonAppBarCancelReport(ref, idReport);
          }
          return null;
        },
        orElse: () => null,
      ),
    );
  }

  Widget _buildReportsList(
    List<ReportsModel> reports,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (reports.isEmpty) {
      return const TextNoReports();
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        final isAccepted = report.estado == 'En proceso';

        final String textNote = isAccepted
            ? 'Reporte aceptado, brigadista en camino'
            : 'Reporte realizado, espera a que lo acepte un brigadista';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              BigBadgeViewProgress(text: report.estado),
              const SizedBox(height: 20),
              ViewLocation(location: report.ubicacion),
              const SizedBox(height: 20),
              TextAndTitleContainer(
                title: report.descripcion == '' ? 'Audio' : 'Descripción',
                description: report.descripcion == ''
                    ? report.rutaAudio
                    : report.descripcion,
                idReport: report.idReporte,
              ),
              const SizedBox(height: 20),
              DateAndHourContainer(
                date: report.fechaCreacion,
                hour: report.horaCreacion,
              ),
              const SizedBox(height: 30),
              TextNote(title: 'Nota', description: textNote),
            ],
          ),
        );
      },
    );
  }

  Center _buildErrorWidget(Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error al cargar reportes',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  BottomAppBar buttonAppBarCreateReport(BuildContext context) {
    final router = GoRouter.of(context);

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      height: 130,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Material(
          color: lightMode.colorScheme.secondary,
          borderRadius: BorderRadius.circular(100),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              router.push('/user/create-report');
            },
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.send, color: Colors.black, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    "Realizar Reporte",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomAppBar buttonAppBarCancelReport(
    WidgetRef ref,
    AsyncValue<int?> idReport,
  ) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      height: 130,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Material(
          color: const Color(0xFFFF3737),
          borderRadius: BorderRadius.circular(100),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              if (idReport.isLoading || idReport.value == null) {
                return;
              }
              showDialogIfCancel(ref, idReport.value!);
            },
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Cancelar Reporte",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showDialogIfCancel(WidgetRef ref, int idReport) {
    return showDialog(
      context: ref.context,
      builder: (BuildContext context) {
        bool isCancelling = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Confirmar cancelación'),
              content: const Text(
                '¿Estás seguro de que quieres cancelar el reporte?',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  onPressed: isCancelling
                      ? null
                      : () async {
                          setDialogState(() {
                            isCancelling = true;
                          });
                          await ref.read(cancelReportProvider(idReport).future);

                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                  child: isCancelling
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sí'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
