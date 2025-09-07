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
import 'package:reportes_unimayor/widgets/info_user.dart';
import 'package:reportes_unimayor/widgets/text_and_title_container.dart';
import 'package:reportes_unimayor/widgets/text_no_reports.dart';
import 'package:reportes_unimayor/widgets/view_location.dart';

class MainBrigadierScreen extends ConsumerWidget {
  const MainBrigadierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportListBrigadierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final idReport = reportsAsync.whenData(
      (reports) => reports.first.idReporte,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                            color: colorScheme.onBackground,
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
                data: (reports) => RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(reportListBrigadierProvider);
                  },
                  child: _buildReportsList(reports, context, ref),
                ),
                loading: () => Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                ),
                error: (error, stack) => _buildErrorWidget(error, ref, context),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: reportsAsync.maybeWhen(
        data: (reports) =>
            reports.isNotEmpty && reports.first.estado == 'En proceso'
            ? buttonAppBarFinalizeReport(ref, idReport, context)
            : null,
        orElse: () => null,
      ),

      floatingActionButton: reportsAsync.maybeWhen(
        data: (reports) =>
            reports.isNotEmpty && reports.first.estado == 'En proceso'
            ? FloatingActionButton.extended(
                onPressed: () {
                  GoRouter.of(context).push('/brigadier/search-person');
                },
                backgroundColor: colorScheme.secondary,
                elevation: 0,
                highlightElevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                disabledElevation: 0,
                icon: Icon(
                  Icons.search,
                  color: colorScheme.onSecondary,
                  size: 30,
                ),
                label: Text(
                  "Consultar",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSecondary,
                  ),
                ),
              )
            : null,
        orElse: () => null,
      ),
    );
  }

  BottomAppBar buttonAppBarFinalizeReport(
    WidgetRef ref,
    AsyncValue<int> idReport,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      height: 90,
      child: Material(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () {
            if (idReport.isLoading || idReport.value == null) {
              return;
            }
            showDialogIfFinalized(ref, idReport);
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
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.check, color: colorScheme.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDialogIfFinalized(
    WidgetRef ref,
    AsyncValue<int> idReport,
  ) {
    final TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: ref.context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Confirmar Finalizar El Reporte',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Escribe el estado del paciente hasta el momento en que terminaste tu intervención.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'El paciente ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Finalizar'),
                  onPressed: descriptionController.text.trim().isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          ref.read(
                            endReportProvider(
                              idReport.value!,
                              descriptionController.text.trim(),
                            ),
                          );
                        },
                ),
              ],
            );
          },
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
    final colorScheme = Theme.of(context).colorScheme;

    if (reports.isEmpty) {
      return const TextNoReports();
    }

    if (reports.first.estado == 'En proceso') {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: viewReportInProcess(ref, reports.first, context),
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
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(5),
              color: colorScheme.surface,
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
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
                const SizedBox(height: 20),

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
                            color: Colors.green, // aquí podrías usar tertiary
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
                                  color: colorScheme.onTertiaryContainer,
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
                            border: Border.all(color: colorScheme.outline),
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
                                  color: colorScheme.onSurface,
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

  Widget viewReportInProcess(
    WidgetRef ref,
    ReportsModel report,
    BuildContext context,
  ) {
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
          const SizedBox(height: 20),
          InfoUser(
            name: report.usuario.nombre ?? "",
            email: report.usuario.correo,
          ),
        ],
      ),
    );
  }

  showDialogIfAccept(ref, report) {
    return showDialog(
      context: ref.context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text(
            'Confirmar aceptación',
            style: TextStyle(color: colorScheme.onBackground),
          ),
          content: Text(
            '¿Estás seguro de que quieres aceptar el reporte?',
            style: TextStyle(color: colorScheme.onSurface),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(acceptReportProvider(report.idReporte));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorWidget(Object error, WidgetRef ref, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Error al cargar reportes',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
