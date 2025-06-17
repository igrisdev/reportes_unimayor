import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/components/app_bar_user.dart';
import 'package:reportes_unimayor/components/card_report.dart';
import 'package:reportes_unimayor/components/drawer_user.dart';
import 'package:reportes_unimayor/screens/users/view_report_user_screen.dart';

class HistoryUserScreen extends StatelessWidget {
  const HistoryUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            Column(
              children: [
                CardReport(
                  redirectTo: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewReportUserScreen(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CardReport(
                  redirectTo: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewReportUserScreen(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CardReport(
                  redirectTo: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewReportUserScreen(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CardReport(
                  redirectTo: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewReportUserScreen(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CardReport(
                  redirectTo: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewReportUserScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
