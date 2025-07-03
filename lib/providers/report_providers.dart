import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/token_provider.dart';
import 'package:reportes_unimayor/services/api_reports_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_providers.g.dart';

@riverpod
Future<List<ReportsModel>> reportList(ReportListRef ref) async {
  final token = ref.watch(tokenProvider);

  if (token.isEmpty) {
    return []; // o throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiReportsService();
    final reports = await apiService.getReports(token);

    return reports;
  } catch (e) {
    print('Error en report provider: $e');
    throw e; // Riverpod manejará el error
  }
}

@riverpod
Future<ReportsModel> getReportById(GetReportByIdRef ref, String id) async {
  final token = ref.watch(tokenProvider);

  if (token.isEmpty) {
    throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiReportsService();
    final report = await apiService.getReportById(token, id);

    return report;
  } catch (e) {
    print('Error en report provider: $e');
    throw e; // Riverpod manejará el error
  }
}
