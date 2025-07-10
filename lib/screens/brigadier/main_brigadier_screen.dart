import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/widgets/app_bar_brigadier.dart';
import 'package:reportes_unimayor/widgets/big_badge_view_progress.dart';
import 'package:reportes_unimayor/widgets/date_and_hour_container.dart';
import 'package:reportes_unimayor/widgets/drawer_brigadier.dart';
import 'package:reportes_unimayor/widgets/text_and_title_container.dart';
import 'package:reportes_unimayor/widgets/view_location.dart';

class MainBrigadierScreen extends ConsumerWidget {
  const MainBrigadierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportListBrigadierProvider);

    final idReport = reportsAsync.whenData(
      (reports) => reports.first.idReporte,
    );

    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 140, 238, 213),
      appBar: AppBarBrigadier(),
      drawer: DrawerBrigadier(context: context),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            reportsAsync.maybeWhen(
              data: (reports) =>
                  reports.isNotEmpty && reports.first.estado != 'En proceso'
                  ? Column(
                      children: [
                        Text(
                          'Reportes Pendientes',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink(),
              orElse: () => const SizedBox.shrink(),
            ),
            Expanded(
              child: reportsAsync.when(
                // data: (reports) => _buildReportsList(reports, context),
                data: (reports) => RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(reportListBrigadierProvider);
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
        data: (reports) =>
            reports.isNotEmpty && reports.first.estado == 'En proceso'
            ? buttonAppBarFinalizeReport(ref, idReport)
            : null,
        orElse: () => null, // Por defecto no mostrar
      ),
    );
  }

  BottomAppBar buttonAppBarFinalizeReport(
    WidgetRef ref,
    AsyncValue<int> idReport,
  ) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      height: 90,
      child: Material(
        color: const Color(0xFF034593),
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
                  "Finalizar Reporte",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.check, color: Colors.white),
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
          title: const Text('Confirmar Finalizar El Reporte'),
          content: const Text(
            '¿Estás seguro de que quieres finalizar el reporte?',
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
                Navigator.of(context).pop();
                ref.read(endReportProvider(idReport.value!));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportsList(
    List<ReportsModel> reports,
    BuildContext context,
    WidgetRef ref,
  ) {
    final router = GoRouter.of(context);

    if (reports.isEmpty) {
      return textNoReports(ref, context);
    }

    if (reports.first.estado == 'En proceso') {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: viewReportInProcess(ref, reports.first),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];

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
                  title: 'Descripción',
                  description: report.descripcion,
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
                      child: GestureDetector(
                        onTap: () {
                          showDialogIfAccept(ref, report);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF338838),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            child: Center(
                              child: Text(
                                'Aceptar',
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

  Widget viewReportInProcess(WidgetRef ref, ReportsModel report) {
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
        ],
      ),
    );
  }

  showDialogIfAccept(ref, report) {
    return showDialog(
      context: ref.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar aceptación'),
          content: const Text(
            '¿Estás seguro de que quieres aceptar el reporte?',
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
                ref.read(acceptReportProvider(report.idReporte));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorWidget(Object error, WidgetRef ref) {
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

  Widget textNoReports(WidgetRef ref, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(reportListBrigadierProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQueryData.fromView(View.of(context)).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "Sin Reportes",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "No han realizado reportes",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
