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
      // Incluir opcionales solo si tienen valor, o incluirlos como null si el backend lo requiere.
      // Aquí los incluimos para coincidir con la estructura exacta de tu request body.
      "telefonoAlternativo": telefonoAlternativo,
      "email": email,
      "esPrincipal": esPrincipal,
    };
  }
}

class ApiSettingsService extends BaseDioService {
  /// Envía un nuevo contacto de emergencia al servidor.
  ///
  /// Recibe un objeto con todos los datos necesarios.
  Future<bool> createEmergencyContact(EmergencyContactPayload contact) async {
    try {
      final response = await dio.post(
        '/ContactoEmergencias', // Endpoint basado en la imagen
        data: contact.toJson(),
        options: Options(
          contentType:
              Headers.jsonContentType, // Asegura que se envíe como JSON
        ),
      );

      // El endpoint devuelve 200 OK en caso de éxito.
      if (response.statusCode == 200) {
        return true;
      }

      // Si el estado no es 200, lanzar una excepción.
      throw Exception(
        'Error al crear el contacto de emergencia. Código: ${response.statusCode}',
      );
    } on DioError catch (e) {
      print('Error Dio al crear contacto de emergencia: ${e.message}');
      // Puedes analizar el error.response aquí si necesitas detalles específicos del backend
      rethrow;
    } catch (e) {
      print('Error general al crear contacto de emergencia: $e');
      rethrow;
    }
  }
}
