import 'package:dio/dio.dart';
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

  Future<List<ReportsModel>> getReportsBrigadierPending(String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.get('/brigadista/reportes/pendientes');

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

  Future<List<ReportsModel>> getReportsBrigadierAssigned(String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.get('/brigadista/reportes/asignados');

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

      return report;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow; // Re-lanzar el error para que lo maneje el provider
    }
  }

  Future<bool> createReportWrite(
    String token,
    String id,
    String description,
  ) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.post(
        '/reportes',
        data: {'idUbicacion': id, 'descripcion': description},
      );

      if (response.statusCode != 200) {
        throw Exception('Error al crear el reporte');
      }

      return true;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow; // Re-lanzar el error para que lo maneje el provider
    }
  }

  Future<bool> createReportAudio(String token, String id, String record) async {
    final formData = FormData.fromMap({
      'IdUbicacion': id,
      'ArchivoAudio': await MultipartFile.fromFile(
        record,
        filename: 'audio.m4a',
        contentType: DioMediaType('audio', 'm4a'),
      ),
    });

    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.post('/reportes/audio', data: formData);

      if (response.statusCode != 200) {
        throw Exception('Error al crear el reporte con audio');
      }

      return true;
    } catch (e) {
      print('Error crear reporte con audio: $e');
      rethrow; // Re-lanzar el error para que lo maneje el provider
    }
  }

  Future<bool> cancelReport(String token, int id) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.put('/reportes/cancelar/$id');

      if (response.statusCode != 200) {
        throw Exception('Error al cancelar el reporte');
      }

      return true;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow; // Re-lanzar el error para que lo maneje el provider
    }
  }

  Future<bool> acceptReport(String token, int id) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.put('/brigadista/reportes/aceptar/$id');

      if (response.statusCode != 200) {
        throw Exception('Error al cancelar el reporte');
      }

      print('Reporte aceptado exitosamente');
      return true;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow; // Re-lanzar el error para que lo maneje el provider
    }
  }

  Future<bool> endReport(String token, int id) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.put('/brigadista/reportes/finalizar/$id');

      if (response.statusCode != 200) {
        throw Exception('Error al cancelar el reporte');
      }

      print('Reporte finalizado exitosamente');
      return true;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow; // Re-lanzar el error para que lo maneje el provider
    }
  }
}
