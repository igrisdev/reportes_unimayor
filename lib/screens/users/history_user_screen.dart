import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/components/app_bar_user.dart';
import 'package:reportes_unimayor/components/card_report.dart';
import 'package:reportes_unimayor/components/drawer_user.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';

class HistoryUserScreen extends ConsumerWidget {
  const HistoryUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportListProvider);

    return Scaffold(
      // backgroundColor: lightMode.colorScheme.surface,
      appBar: AppBarUser(),
      drawer: DrawerUser(context: context),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
          top: 10,
          bottom: 10,
        ),
        child: ListView(
          children: [
            Text(
              'Historial de Reportes',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: reportsAsync.when(
                data: (reports) => _buildReportsList(reports, context),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error al cargar los reportes'),
              ),
            ),
          ],
        ),
      ),
      //   SizedBox(height: 10),
    );
  }

  Widget _buildReportsList(List<ReportsModel> reports, BuildContext context) {
    final router = GoRouter.of(context);

    if (reports.isEmpty) {
      return textNoReports();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CardReport(
            title: report.ubicacion.nombre,
            description: report.descripcion,
            status: report.estado,
            date:
                '${report.fechaCreacion.day.toString()} - ${report.fechaCreacion.month} - ${report.fechaCreacion.year.toString()}',
            hour:
                '${report.horaCreacion.split(':').first}:${report.horaCreacion.split(':')[1]}',
            location:
                '${report.ubicacion.edificio} - ${report.ubicacion.salon}',
            redirectTo: () => router.push('/user/report/${report.idReporte}'),
          ),
        );
      },
    );
  }

  SizedBox textNoReports() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text(
          "Sin Reporte",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
    );
  }
}
