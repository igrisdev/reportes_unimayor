import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/providers/audio_player_notifier.dart';
import 'package:reportes_unimayor/services/api_reports_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_providers.g.dart';

@riverpod
Future<List<ReportsModel>> reportList(ReportListRef ref) async {
  try {
    final apiService = ApiReportsService();
    final reports = await apiService.getReports();

    final history = reports
        .where((r) => r.estado != 'Pendiente' && r.estado != 'En proceso')
        .toList();

    DateTime _combineDateAndHour(ReportsModel r) {
      final datePart = r.fechaCreacion.toIso8601String().split('T')[0];
      final dateTimeString = '$datePart ${r.horaCreacion}';
      try {
        return DateTime.parse(dateTimeString);
      } catch (_) {
        return r.fechaCreacion;
      }
    }

    history.sort((a, b) {
      final da = _combineDateAndHour(a);
      final db = _combineDateAndHour(b);
      return db.compareTo(da);
    });

    return history;
  } catch (e) {
    print('Error en report provider: $e');
    rethrow;
  }
}

@riverpod
Future<List<ReportsModel>> reportListBrigadier(
  ReportListBrigadierRef ref,
) async {
  try {
    final apiService = ApiReportsService();

    final reportAccepted = await apiService.getReportsBrigadierAssigned();

    final reports = reportAccepted
        .where((element) => element.estado == 'En proceso')
        .toList();

    if (reports.isEmpty) {
      return await apiService.getReportsBrigadierPending();
    }

    return reports;
  } catch (e) {
    print('Error en report provider: $e');
    rethrow;
  }
}

@riverpod
Future<List<ReportsModel>> reportListHistoryBrigadier(
  ReportListHistoryBrigadierRef ref,
) async {
  try {
    final apiService = ApiReportsService();

    final allReports = await apiService.getReportsBrigadierAssigned();

    final reports = allReports
        .where((r) => r.estado != 'En proceso' && r.estado != 'Pendiente')
        .toList();

    DateTime _combineDateAndHour(ReportsModel r) {
      final datePart = r.fechaCreacion.toIso8601String().split('T').first;
      final dateTimeString = '$datePart ${r.horaCreacion}';
      try {
        return DateTime.parse(dateTimeString);
      } catch (_) {
        return r.fechaCreacion;
      }
    }

    reports.sort((a, b) {
      final da = _combineDateAndHour(a);
      final db = _combineDateAndHour(b);
      return db.compareTo(da);
    });

    return reports;
  } catch (e) {
    print('Error en reportListHistoryBrigadier provider: $e');
    rethrow;
  }
}

@riverpod
Future<List<ReportsModel>> reportListPending(ReportListPendingRef ref) async {
  try {
    final apiService = ApiReportsService();
    final reports = await apiService.getReports();

    final pendingReports = reports
        .where(
          (report) =>
              report.estado != 'Finalizado' && report.estado != 'Cancelado',
        )
        .toList();
    return pendingReports;
  } catch (e) {
    print('Error Report List Pending ***: $e');
    rethrow;
  }
}

@riverpod
Future<bool> cancelReport(CancelReportRef ref, int id) async {
  try {
    final apiService = ApiReportsService();
    final response = await apiService.cancelReport(id);

    if (response) {
      await ref.refresh(reportListPendingProvider.future);
      ref.invalidate(reportListProvider);

      return true;
    }

    return false;
  } catch (e) {
    print('Error en report provider: $e');
    rethrow;
  }
}

@riverpod
Future<ReportsModel> getReportById(GetReportByIdRef ref, String id) async {
  try {
    final apiService = ApiReportsService();
    final report = await apiService.getReportById(id);

    return report;
  } catch (e) {
    print('Error en report provider: $e');
    rethrow;
  }
}

@riverpod
Future<ReportsModel> getReportByIdBrigadier(
  GetReportByIdBrigadierRef ref,
  String id,
) async {
  try {
    final apiService = ApiReportsService();
    final reports = await apiService.getReportsBrigadierPending();

    final report = reports.where((report) => report.idReporte.toString() == id);

    if (report.isEmpty) {
      final report = await apiService.getReportsBrigadierAssigned();
      return report.firstWhere((report) => report.idReporte.toString() == id);
    }

    return report.first;
  } catch (e) {
    print('Error en report provider: $e');
    rethrow;
  }
}

@riverpod
Future<bool> createReport(
  CreateReportRef ref,
  String? idUbicacion,
  String? descripcion,
  String? record,
  bool paraMi,
  String? ubicacionTextOpcional,
) async {
  try {
    final api = ApiReportsService();

    final response = await api.createReport(
      idUbicacion,
      descripcion,
      record,
      paraMi,
      ubicacionTextOpcional,
    );

    if (response) {
      await ref.refresh(reportListPendingProvider.future);
      return true;
    }

    return false;
  } catch (e, stack) {
    print('Error en createReportUserProvider: $e');
    print(stack);
    rethrow;
  }
}

// @riverpod
// Future<bool> createReport(
//   CreateReportRef ref,
//   String idUbicacion,
//   String? descripcion,
//   String? record,
// ) async {
//   try {
//     final apiService = ApiReportsService();
//     final response = await apiService.createReport(
//       idUbicacion,
//       descripcion,
//       record,
//     );

//     if (response) {
//       await ref.refresh(reportListPendingProvider.future);

//       return true;
//     }

//     return false;
//   } catch (e) {
//     print('Error en report provider: $e');
//     rethrow;
//   }
// }

@riverpod
Future<bool> acceptReport(AcceptReportRef ref, int id) async {
  try {
    final apiService = ApiReportsService();
    final response = await apiService.acceptReport(id);

    if (response) {
      await ref.refresh(reportListBrigadierProvider.future);
      return true;
    }

    return false;
  } catch (e) {
    print('Error en report provider: $e');
    rethrow;
  }
}

@riverpod
Future<bool> endReport(EndReportRef ref, int id, String description) async {
  try {
    final apiService = ApiReportsService();
    final response = await apiService.endReport(id, description);

    if (response) {
      await ref.refresh(reportListBrigadierProvider.future);
      ref.invalidate(reportListHistoryBrigadierProvider);

      return true;
    }

    return false;
  } catch (e) {
    print('Error en report provider: $e');
    rethrow;
  }
}

@riverpod
Future<String> getRecord(
  GetRecordRef ref,
  int idReport,
  String urlRecord,
) async {
  try {
    final apiService = ApiReportsService();
    final response = await apiService.getRecordReport(idReport, urlRecord);

    if (response.isEmpty) {
      throw Exception('Error obteniendo el audio');
    }

    final audioNotifier = ref.read(audioPlayerNotifierProvider.notifier);
    await audioNotifier.load(response);

    return response;
  } catch (e) {
    print('Error obtener audio: $e');
    rethrow;
  }
}
