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
Future<List<ReportsModel>> reportListBrigadier(
  ReportListBrigadierRef ref,
) async {
  final token = ref.watch(tokenProvider);

  if (token.isEmpty) {
    return []; // o throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiReportsService();

    final reportAccepted = await apiService.getReportsBrigadierAssigned(token);

    final reports = reportAccepted
        .where((element) => element.estado == 'En proceso')
        .toList();

    if (reports.isEmpty) {
      return await apiService.getReportsBrigadierPending(token);
    }

    return reports;
  } catch (e) {
    print('Error en report provider: $e');
    throw e; // Riverpod manejará el error
  }
}

@riverpod
Future<List<ReportsModel>> reportListHistoryBrigadier(
  ReportListHistoryBrigadierRef ref,
) async {
  final token = ref.watch(tokenProvider);

  if (token.isEmpty) {
    return []; // o throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiReportsService();

    final reportFinalized = await apiService.getReportsBrigadierAssigned(token);

    final reports = reportFinalized
        .where(
          (element) =>
              element.estado != 'En proceso' && element.estado != 'Pendiente',
        )
        .toList();

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
    print('Error Report List Pending ***: $e');
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
Future<ReportsModel> getReportByIdBrigadier(
  GetReportByIdBrigadierRef ref,
  String id,
) async {
  final token = ref.watch(tokenProvider);

  if (token.isEmpty) {
    throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiReportsService();
    final reports = await apiService.getReportsBrigadierPending(token);

    final report = reports.where((report) => report.idReporte.toString() == id);

    if (report.isEmpty) {
      final report = await apiService.getReportsBrigadierAssigned(token);
      return report.firstWhere((report) => report.idReporte.toString() == id);
    }

    return report.first;
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
    final response = await apiService.createReportWrite(
      token,
      idUbicacion,
      descripcion,
    );

    print('response: $response');
    if (response) {
      invalidateAllProvidersUser(ref);
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
      invalidateAllProvidersUser(ref);
      return true;
    }

    return false;
  } catch (e) {
    print('Error en report provider: $e');
    throw e; // Riverpod manejará el error
  }
}

@riverpod
Future<bool> acceptReport(AcceptReportRef ref, int id) async {
  final token = ref.watch(tokenProvider);

  if (token.isEmpty) {
    throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiReportsService();
    final response = await apiService.acceptReport(token, id);

    if (response) {
      invalidateAllProvidersBrigadier(ref);
      ref.invalidate(reportListBrigadierProvider);
      return true;
    }

    return false;
  } catch (e) {
    print('Error en report provider: $e');
    throw e; // Riverpod manejará el error
  }
}

@riverpod
Future<bool> endReport(EndReportRef ref, int id) async {
  final token = ref.watch(tokenProvider);

  if (token.isEmpty) {
    throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiReportsService();
    final response = await apiService.endReport(token, id);

    if (response) {
      invalidateAllProvidersBrigadier(ref);
      return true;
    }

    return false;
  } catch (e) {
    print('Error en report provider: $e');
    throw e; // Riverpod manejará el error
  }
}

void invalidateAllProvidersUser(ref) {
  ref.invalidate(reportListPendingProvider);
  ref.invalidate(reportListProvider);
  ref.invalidate(isBrigadierProvider);
}

void invalidateAllProvidersBrigadier(ref) {
  invalidateAllProvidersUser(ref);
  ref.invalidate(reportListBrigadierProvider);
  ref.invalidate(getReportByIdBrigadierProvider);
}
