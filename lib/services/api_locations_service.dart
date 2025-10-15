import 'package:reportes_unimayor/services/base_dio_service.dart';
import 'package:reportes_unimayor/models/ubicacion_model.dart';

class ApiLocationsService extends BaseDioService {
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
}
