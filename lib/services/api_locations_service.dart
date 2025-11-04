import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reportes_unimayor/services/base_dio_service.dart';
import 'package:reportes_unimayor/models/ubicacion_model.dart';

final apiLocationsServiceProvider = Provider((ref) => ApiLocationsService(ref));

class ApiLocationsService extends BaseDioService {
  final Ref _ref;
  ApiLocationsService(this._ref) : super(_ref);

  Future<List<Ubicacion>> getUbicaciones() async {
    try {
      final response = await dio.get('/admin/ubicaciones');

      if (response.data == null) return [];

      final List<dynamic> jsonList = response.data as List<dynamic>;
      final List<Ubicacion> ubicaciones = jsonList
          .map((json) => Ubicacion.fromJson(json as Map<String, dynamic>))
          .toList();

      return ubicaciones;
    } catch (e) {
      print('Error en ApiLocationsService: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUbicacionById(int id) async {
    try {
      final response = await dio.get('/admin/ubicaciones/$id');

      if (response.statusCode == 404 || response.data == null) {
        throw Exception('Ubicación no encontrada');
      }

      final Map<String, dynamic> json = response.data as Map<String, dynamic>;

      final int idUbicacion = json['idUbicacion'] is int
          ? json['idUbicacion'] as int
          : int.tryParse(json['idUbicacion']?.toString() ?? '') ?? -1;

      final String sede = (json['sede'] as String?)?.trim() ?? '';
      final String lugar = (json['lugar'] as String?)?.trim() ?? '';

      return {'idUbicacion': idUbicacion, 'sede': sede, 'lugar': lugar};
    } catch (e) {
      print('Error en getUbicacionById: $e');
      rethrow;
    }
  }
}
