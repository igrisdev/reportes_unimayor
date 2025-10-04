import 'package:dio/dio.dart';
import 'package:reportes_unimayor/services/base_dio_service.dart'; // Asumiendo esta ruta

class EmergencyContactPayload {
  final String nombre;
  final String relacion;
  final String telefono;
  final String? telefonoAlternativo;
  final String? email;
  final bool esPrincipal;

  EmergencyContactPayload({
    required this.nombre,
    required this.relacion,
    required this.telefono,
    this.telefonoAlternativo,
    this.email,
    required this.esPrincipal,
  });

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "relacion": relacion,
      "telefono": telefono,
      // Incluir opcionales. El backend de la imagen parece esperar la clave, incluso si es null.
      "telefonoAlternativo": telefonoAlternativo,
      "email": email,
      "esPrincipal": esPrincipal,
    };
  }
}

class ApiSettingsService extends BaseDioService {
  final String _endpoint = '/ContactoEmergencias';

  // --- 1. POST: Crear Contacto ---
  /// Envía un nuevo contacto de emergencia al servidor.
  Future<bool> createEmergencyContact(EmergencyContactPayload contact) async {
    try {
      final response = await dio.post(
        _endpoint,
        data: contact.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      // El endpoint devuelve 200 OK en caso de éxito.
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error Dio al crear contacto de emergencia: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al crear contacto de emergencia: $e');
      rethrow;
    }
  }

  // --- 2. GET: Obtener todos los Contactos ---
  /// Obtiene la lista completa de contactos de emergencia del usuario.
  /// Retorna una lista de mapas (que luego se convertirán en objetos).
  Future<List<Map<String, dynamic>>> getEmergencyContacts() async {
    try {
      final response = await dio.get(_endpoint);

      if (response.statusCode == 200 && response.data is List) {
        // Asumiendo que response.data es List<Map<String, dynamic>>
        return List<Map<String, dynamic>>.from(response.data);
      }

      throw Exception(
        'Formato de respuesta incorrecto o código: ${response.statusCode}',
      );
    } on DioException catch (e) {
      print('Error Dio al obtener lista de contactos: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al obtener lista de contactos: $e');
      rethrow;
    }
  }

  // --- 3. GET: Obtener un solo Contacto por ID ---
  /// Obtiene un contacto específico por su ID.
  Future<Map<String, dynamic>> getEmergencyContactById(String id) async {
    try {
      final response = await dio.get('$_endpoint/$id');

      if (response.statusCode == 200 && response.data is Map) {
        // Asumiendo que response.data es Map<String, dynamic>
        return Map<String, dynamic>.from(response.data);
      }

      throw Exception(
        'Error al obtener contacto $id. Código: ${response.statusCode}',
      );
    } on DioException catch (e) {
      print('Error Dio al obtener contacto por ID: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al obtener contacto por ID: $e');
      rethrow;
    }
  }

  // --- 4. PUT: Actualizar Contacto ---
  /// Actualiza un contacto existente por su ID.
  Future<bool> updateEmergencyContact(
    String id,
    EmergencyContactPayload contact,
  ) async {
    try {
      final response = await dio.put(
        '$_endpoint/$id',
        data: contact.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      // El endpoint devuelve 200 OK en caso de éxito (o 204 No Content).
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      print('Error Dio al actualizar contacto $id: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al actualizar contacto $id: $e');
      rethrow;
    }
  }

  // --- 5. DELETE: Eliminar Contacto ---
  /// Elimina un contacto existente por su ID.
  Future<bool> deleteEmergencyContact(String id) async {
    try {
      final response = await dio.delete('$_endpoint/$id');

      // El endpoint devuelve 200 OK o 204 No Content en caso de éxito.
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      print('Error Dio al eliminar contacto $id: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al eliminar contacto $id: $e');
      rethrow;
    }
  }
}
