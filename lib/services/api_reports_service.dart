import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reportes_unimayor/models/person_model.dart';
import 'package:reportes_unimayor/models/reports_model.dart';
import 'package:reportes_unimayor/services/base_dio_service.dart';

final apiReportsServiceProvider = Provider((ref) => ApiReportsService(ref));

class ApiReportsService extends BaseDioService {
  final Ref _ref;
  ApiReportsService(this._ref) : super(_ref);

  Future<List<ReportsModel>> getReports() async {
    try {
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
      rethrow;
    }
  }

  Future<String> getRecordReport(int idReport, String urlRecord) async {
    final response = await dio.get(
      '/reportes/$idReport/audio',
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al descargar el audio');
    }

    final dir = await getTemporaryDirectory();
    final fileName = urlRecord.split('/').last;
    final filePath = '${dir.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(response.data as List<int>);
    return filePath;
  }

  Future<List<ReportsModel>> getReportsBrigadierPending() async {
    try {
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
      rethrow;
    }
  }

  Future<List<ReportsModel>> getReportsBrigadierAssigned() async {
    try {
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
      rethrow;
    }
  }

  Future<ReportsModel> getReportById(String id) async {
    try {
      final response = await dio.get('/reportes/$id');

      if (response.data == null) {
        throw Exception('Reporte no encontrado');
      }

      final Map<String, dynamic> json = response.data as Map<String, dynamic>;

      final ReportsModel report = ReportsModel.fromJson(json);

      return report;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow;
    }
  }

  Future<bool> createReport(
    String? idUbicacion,
    String? description,
    String? record,
    bool paraMi,
    String? ubicacionTextOpcional,
  ) async {
    FormData formData;

    final Map<String, dynamic> dataMap = {
      'IdUbicacion': idUbicacion,
      'Descripcion': description,
      'ParaMi': paraMi,
      'UbicacionTextOpcional': ubicacionTextOpcional,
    };

    if (record != null && record.isNotEmpty) {
      dataMap['ArchivoAudio'] = await MultipartFile.fromFile(
        record,
        filename: 'audio.m4a',
        contentType: DioMediaType('audio', 'm4a'),
      );
    }

    formData = FormData.fromMap(dataMap);

    try {
      final response = await dio.post('/reportes', data: formData);

      if (response.statusCode != 200) {
        throw Exception('Error al crear el reporte con audio');
      }

      return true;
    } catch (e) {
      print('Error crear reporte con audio:  $e');
      rethrow;
    }
  }

  Future<bool> cancelReport(int id, String motivoCancelacion) async {
    try {
      final response = await dio.put(
        '/reportes/cancelar/$id',
        data: {'motivoCancelacion': motivoCancelacion},
      );

      if (response.statusCode != 200) {
        throw Exception('Error al cancelar el reporte');
      }

      return true;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow;
    }
  }

  Future<bool> acceptReport(int id) async {
    try {
      final response = await dio.put('/brigadista/reportes/aceptar/$id');

      if (response.statusCode != 200) {
        throw Exception('Error al cancelar el reporte');
      }

      print('Reporte aceptado exitosamente');
      return true;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow;
    }
  }

  Future<bool> endReport(int id, String description) async {
    try {
      final response = await dio.put(
        '/brigadista/reportes/finalizar/$id',
        data: {'detallesFinalizacion': description},
      );

      if (response.statusCode != 200) {
        throw Exception('Error al cancelar el reporte');
      }

      return true;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow; // Re-lanzar el error para que lo maneje el provider
    }
  }

  Future<PersonModel> searchPerson(String email) async {
    try {
      final response = await dio.get(
        '/brigadista/reportes/info-completa/$email',
      );

      if (response.data == null) {
        throw Exception('Persona no encontrada');
      }

      final Map<String, dynamic> json = response.data as Map<String, dynamic>;

      final PersonModel person = PersonModel.fromJson(json);

      return person;
    } catch (e) {
      print('Error en ApiReportsService: $e');
      rethrow; // Re-lanzar el error para que lo maneje el provider
    }
  }
}
