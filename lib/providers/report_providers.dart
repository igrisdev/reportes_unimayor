import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/is_brigadier_provider.dart';
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
Future<List<ReportsModel>> reportListPending(ReportListPendingRef ref) async {
  final token = ref.watch(tokenProvider);

  if (token.isEmpty) {
    return []; // o throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiReportsService();
    final reports = await apiService.getReports(token);

    final pendingReports = reports
        .where(
          (report) =>
              report.estado != 'Finalizado' && report.estado != 'Cancelado',
        )
        .toList();
    return pendingReports;
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

@riverpod
Future<bool> createReport(
  CreateReportRef ref,
  String idUbicacion,
  String descripcion,
) async {
  final token = ref.watch(tokenProvider);

  if (token.isEmpty) {
    throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiReportsService();
    final response = await apiService.createReport(
      token,
      idUbicacion,
      descripcion,
    );

    if (response) {
      invalidateAllProviders(ref);
      return true;
    }

    return false;
  } catch (e) {
    print('Error en report provider: $e');
    throw e; // Riverpod manejará el error
  }
}

@riverpod
Future<bool> cancelReport(CancelReportRef ref, int id) async {
  final token = ref.watch(tokenProvider);

  if (token.isEmpty) {
    throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiReportsService();
    final response = await apiService.cancelReport(token, id);

    if (response) {
      invalidateAllProviders(ref);
      return true;
    }

    return false;
  } catch (e) {
    print('Error en report provider: $e');
    throw e; // Riverpod manejará el error
  }
}

void invalidateAllProviders(ref) {
  ref.invalidate(reportListPendingProvider);
  ref.invalidate(reportListProvider);
  ref.invalidate(isBrigadierProvider);
}
