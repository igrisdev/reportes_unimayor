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
      appBar: AppBarUser(),
      drawer: DrawerUser(context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historial de Reportes',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: reportsAsync.when(
                data: (reports) => _buildReportsList(reports, context),
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
      return const Center(
        child: Text(
          "Sin Reportes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      );
    }

    return ListView.separated(
      itemCount: reports.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report = reports[index];
        return CardReport(
          title: report.ubicacion.nombre,
          description: report.descripcion,
          status: report.estado,
          date:
              '${report.fechaCreacion.day} - ${report.fechaCreacion.month} - ${report.fechaCreacion.year}',
          hour:
              '${report.horaCreacion.split(':').first}:${report.horaCreacion.split(':')[1]}',
          location: '${report.ubicacion.edificio} - ${report.ubicacion.salon}',
          redirectTo: () => router.push('/user/report/${report.idReporte}'),
        );
      },
    );
  }
}
