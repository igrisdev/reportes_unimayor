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

class MainUserScreen extends ConsumerWidget {
  const MainUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportListPendingProvider);

    final idReport = reportsAsync.whenData(
      (reports) => reports.first.idReporte,
    );

    return Scaffold(
      appBar: AppBarUser(),
      drawer: DrawerUser(context: context),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: reportsAsync.when(
                // data: (reports) => _buildReportsList(reports, context),
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
        data: (reports) => reports.isEmpty
            ? buttonAppBarCreateReport(context)
            : buttonAppBarCancelReport(ref, idReport),
        orElse: () => null, // Por defecto no mostrar
      ),
    );
  }

  Widget _buildReportsList(
    List<ReportsModel> reports,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (reports.isEmpty) {
      return TextNoReports();
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
              SizedBox(height: 20),
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
              SizedBox(height: 30),
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
      height: 110,
      child: Material(
        color: lightMode.colorScheme.secondary,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () {
            router.push('/user/create-report');
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Realizar Reporte",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: lightMode.colorScheme.secondaryFixed,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.send, color: lightMode.colorScheme.secondaryFixed),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomAppBar buttonAppBarCancelReport(
    WidgetRef ref,
    AsyncValue<int> idReport,
  ) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      height: 90,
      child: Material(
        color: const Color(0xFFFF3737),
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () {
            if (idReport.isLoading || idReport.value == null) {
              return;
            }
            showDialogIfCancel(ref, idReport);
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Cancelar Reporte",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.cancel_outlined, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDialogIfCancel(WidgetRef ref, AsyncValue<int> idReport) {
    return showDialog(
      context: ref.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar cancelación'),
          content: const Text(
            '¿Estás seguro de que quieres cancelar el reporte?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                // Dismiss the dialog and then cancel the report
                Navigator.of(context).pop();
                ref.read(cancelReportProvider(idReport.value!));
              },
            ),
          ],
        );
      },
    );
  }

  Column textReports() {
    return Column(
      children: [
        Text(
          'Reportes En Curso',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
