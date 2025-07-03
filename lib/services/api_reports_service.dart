import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/services/base_dio_service.dart';

class ApiReportsService extends BaseDioService {
  Future<List<ReportsModel>> getReports(String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.get('/reportes');

      if (response.data == null) {
        return [];
      }

      final List<dynamic> jsonList = response.data as List<dynamic>;

      final List<ReportsModel> reports = jsonList
          .map((json) => ReportsModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return reports;
    } catch (e) {
      print('Error detallado en ApiReportsService: $e');
      rethrow; // Re-lanzar el error para que lo maneje el provider
    }
  }

  Future<ReportsModel> getReportById(String token, String id) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.get('/reportes/$id');

      if (response.data == null) {
        throw Exception('Reporte no encontrado');
      }

      final Map<String, dynamic> json = response.data as Map<String, dynamic>;

      final ReportsModel report = ReportsModel.fromJson(json);

      print('________________________________________________________');
      print('Reporte obtenido: $report');

      return report;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow; // Re-lanzar el error para que lo maneje el provider
    }
  }
}
