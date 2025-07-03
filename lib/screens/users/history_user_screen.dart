import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/components/app_bar_user.dart';
import 'package:reportes_unimayor/components/drawer_user.dart';

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
              // children: [
              //   CardReport(
              //     title: "Reporte de Emergencia #001",
              //     description: "Situación de emergencia en el campus principal",
              //     status: "En Proceso",
              //     date: "23/05/2025",
              //     location: "Campus Principal",
              //     redirectTo: () => Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const ViewReportUserScreen(),
              //       ),
              //     ),
              //   ),
              //   SizedBox(height: 10),
              //   CardReport(
              //     title: "Reporte de Emergencia #002",
              //     description: "Incidente reportado en la biblioteca",
              //     status: "Pendiente",
              //     date: "22/05/2025",
              //     location: "Biblioteca Central",
              //     redirectTo: () => Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const ViewReportUserScreen(),
              //       ),
              //     ),
              //   ),
              //   SizedBox(height: 10),
              //   CardReport(
              //     title: "Reporte de Emergencia #003",
              //     description: "Problema de seguridad en el estacionamiento",
              //     status: "Resuelto",
              //     date: "21/05/2025",
              //     location: "Estacionamiento A",
              //     redirectTo: () => Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const ViewReportUserScreen(),
              //       ),
              //     ),
              //   ),
              //   SizedBox(height: 10),
              //   CardReport(
              //     title: "Reporte de Emergencia #004",
              //     description: "Mantenimiento requerido en laboratorio",
              //     status: "En Proceso",
              //     date: "20/05/2025",
              //     location: "Laboratorio de Sistemas",
              //     redirectTo: () => Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const ViewReportUserScreen(),
              //       ),
              //     ),
              //   ),
              //   SizedBox(height: 10),
              //   CardReport(
              //     title: "Reporte de Emergencia #005",
              //     description: "Evacuación por alarma de incendio",
              //     status: "Cerrado",
              //     date: "19/05/2025",
              //     location: "Edificio Administrativo",
              //     redirectTo: () => Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const ViewReportUserScreen(),
              //       ),
              //     ),
              //   ),
              // ],
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
