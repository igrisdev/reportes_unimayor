import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';
import 'package:reportes_unimayor/widgets/app_bar_user.dart';
import 'package:reportes_unimayor/widgets/big_badge_view_progress.dart';
import 'package:reportes_unimayor/widgets/drawer_user.dart';
import 'package:reportes_unimayor/widgets/text_and_title_container.dart';
import 'package:reportes_unimayor/widgets/view_location.dart';

class MainUserScreen extends ConsumerWidget {
  const MainUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportListPendingProvider);

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
        data: (reports) => reports.isEmpty ? bottomAppBarMain(context) : null,
        orElse: () => null, // Por defecto no mostrar
      ),
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

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
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

  BottomAppBar bottomAppBarMain(BuildContext context) {
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

  Widget textNoReports(WidgetRef ref, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(reportListPendingProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQueryData.fromView(View.of(context)).size.height * 0.7,
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
                  "No tienes reportes creados aún",
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
