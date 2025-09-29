import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/widgets/brigadier/app_bar_brigadier.dart';
import 'package:reportes_unimayor/widgets/general/confirm_dialog.dart';
import 'package:reportes_unimayor/widgets/general/description_report_container.dart';
import 'package:reportes_unimayor/widgets/general/date_and_hour_container.dart';
import 'package:reportes_unimayor/widgets/general/info_user.dart';
import 'package:reportes_unimayor/widgets/general/view_location.dart';

class ViewReportProcessBrigadierScreen extends ConsumerWidget {
  final String id;

  const ViewReportProcessBrigadierScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReport = ref.watch(getReportByIdBrigadierProvider(id));
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: const AppBarBrigadier(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: asyncReport.when(
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
          loading: () =>
              Center(child: CircularProgressIndicator(color: colors.primary)),
        ),
      ),
      bottomNavigationBar: asyncReport.maybeWhen(
        data: (report) => switch (report.estado) {
          'Pendiente' => bottomAppBarMainPending(
            context,
            ref,
            report.idReporte,
            colors,
          ),
          _ => null,
        },
        orElse: () => null,
      ),
    );
  }

  BottomAppBar bottomAppBarMainPending(
    BuildContext context,
    WidgetRef ref,
    int id,
    ColorScheme colors,
  ) {
    final router = GoRouter.of(context);
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      height: 90,
      child: Material(
        color: colors.tertiary,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return ConfirmDialog(
                  title: "Confirmar aceptación",
                  message: "¿Estás seguro de enviar este aceptar el reporte?",
                  confirmText: "Aceptar",
                  cancelText: "Cancelar",
                  onConfirm: () async {
                    final response = await ref.read(
                      AcceptReportProvider(id).future,
                    );

                    if (response == true) {
                      router.push('/brigadier');
                    }
                  },
                );
              },
            );
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
                    color: colors.onTertiary, // contraste automático
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.check, color: colors.onTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox infoReport(ReportsModel report, BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewLocation(location: report.ubicacion),
          const SizedBox(height: 20),
          DescriptionReportContainer(
            idReport: report.idReporte,
            description: report.descripcion == '' ? '' : report.descripcion,
            audio: report.rutaAudio == '' ? '' : report.rutaAudio,
            isTextBig: true,
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
}
