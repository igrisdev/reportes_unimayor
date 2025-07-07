import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';
import 'package:reportes_unimayor/widgets/app_bar_user.dart';

class ViewReportUserScreen extends ConsumerWidget {
  final String id;

  const ViewReportUserScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReport = ref.watch(getReportByIdProvider(id));

    return Scaffold(
      appBar: AppBarUser(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: asyncReport.when(
          data: (report) => infoReport(report),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      bottomNavigationBar: asyncReport.maybeWhen(
        data: (report) => report.estado == 'Pendiente'
            ? bottomAppBarMain(context, ref, report.idReporte)
            : null,
        orElse: () => null, // Por defecto no mostrar
      ),
    );
  }

  BottomAppBar bottomAppBarMain(BuildContext context, WidgetRef ref, int id) {
    final router = GoRouter.of(context);
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      height: 90,
      child: Material(
        color: lightMode.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () async {
            final response = await ref.read(CancelReportProvider(id).future);

            if (response == true) {
              router.push('/user');
              return;
            }
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Cancelar Reporte",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: lightMode.colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.cancel, color: lightMode.colorScheme.tertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column infoReport(ReportsModel report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                report.ubicacion.sede,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: lightMode.colorScheme.secondary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 5,
                  bottom: 5,
                ),
                child: Text(
                  report.estado,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              '${report.horaCreacion.split(':').first}:${report.horaCreacion.split(':')[1]}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Text('  |  ', style: GoogleFonts.poppins(fontSize: 16)),
            Text(
              '${report.fechaCreacion.day.toString()} - ${report.fechaCreacion.month} - ${report.fechaCreacion.year.toString()}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 13),
        Column(
          children: [
            Text(report.descripcion, style: GoogleFonts.poppins(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
