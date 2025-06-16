import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/components/app_bar_user.dart';
import 'package:reportes_unimayor/components/card_report.dart';
import 'package:reportes_unimayor/components/drawer_user.dart';
import 'package:reportes_unimayor/screens/users/create_report_user_screen.dart';
import 'package:reportes_unimayor/screens/users/view_report_user_screen.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';

class MainUserScreen extends StatelessWidget {
  const MainUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: lightMode.colorScheme.surface,
      appBar: AppBarUser(),
      drawer: DrawerUser(context: context),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reporte En Curso',
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
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBarMain(context),
    );
  }

  GestureDetector bottomAppBarMain(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateReportUserScreen(),
          ),
        );
      },
      child: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        height: 90,
        child: Container(
          decoration: BoxDecoration(
            color: lightMode.colorScheme.secondary,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Realizar Reporte",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.send),
            ],
          ),
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
