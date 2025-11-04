import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reportes_unimayor/services/base_dio_service.dart';

final apiSettingsServiceProvider = Provider((ref) => ApiSettingsService(ref));

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
      "telefonoAlternativo": telefonoAlternativo,
      "email": email,
      "esPrincipal": esPrincipal,
    };
  }
}

class MedicalConditionPayload {
  final String nombre;
  final String descripcion;
  final DateTime fechaDiagnostico;

  MedicalConditionPayload({
    required this.nombre,
    required this.descripcion,
    required this.fechaDiagnostico,
  });

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "descripcion": descripcion,
      // Enviar en formato ISO8601 que tu API parece usar en el swagger
      "fechaDiagnostico": fechaDiagnostico.toIso8601String(),
    };
  }
}

class PersonalDataPayload {
  final String numeroTelefonico;
  final String cedula;
  final String codigoInstitucional;

  PersonalDataPayload({
    required this.numeroTelefonico,
    required this.cedula,
    required this.codigoInstitucional,
  });

  Map<String, dynamic> toJson() {
    return {
      "numeroTelefonico": numeroTelefonico,
      "cedula": cedula,
      "codigoInstitucional": codigoInstitucional,
    };
  }
}


class ApiSettingsService extends BaseDioService {
  final Ref _ref;
  ApiSettingsService(this._ref) : super(_ref);

  final String _contactsEndpoint = '/ContactoEmergencias';
  final String _medicalEndpoint = '/CondicionMedica';
  final String _personalEndpoint = '/DatosPersonales/usuarios/datos-personales';

  // -----------------------------
  // Contactos de emergencia (ya definidos)
  // -----------------------------
  Future<bool> createEmergencyContact(EmergencyContactPayload contact) async {
    try {
      final response = await dio.post(
        _contactsEndpoint,
        data: contact.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error Dio al crear contacto de emergencia: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al crear contacto de emergencia: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getEmergencyContacts() async {
    try {
      final response = await dio.get(_contactsEndpoint);

      if (response.statusCode == 200 && response.data is List) {
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

  Future<Map<String, dynamic>> getEmergencyContactById(String id) async {
    try {
      final response = await dio.get('$_contactsEndpoint/$id');

      if (response.statusCode == 200 && response.data is Map) {
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

  Future<bool> updateEmergencyContact(
    String id,
    EmergencyContactPayload contact,
  ) async {
    try {
      final response = await dio.put(
        '$_contactsEndpoint/$id',
        data: contact.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error Dio al actualizar contacto $id: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al actualizar contacto $id: $e');
      rethrow;
    }
  }

  Future<bool> deleteEmergencyContact(String id) async {
    try {
      final response = await dio.delete('$_contactsEndpoint/$id');

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error Dio al eliminar contacto $id: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al eliminar contacto $id: $e');
      rethrow;
    }
  }

  // -----------------------------
  // Condiciones Médicas
  // -----------------------------

  /// GET /api/CondicionMedica  -> lista de condiciones
  Future<List<Map<String, dynamic>>> getMedicalConditions() async {
    try {
      final response = await dio.get(_medicalEndpoint);

      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }

      throw Exception(
        'Formato de respuesta incorrecto o código: ${response.statusCode}',
      );
    } on DioException catch (e) {
      print('Error Dio al obtener lista de condiciones médicas: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al obtener lista de condiciones médicas: $e');
      rethrow;
    }
  }

  /// GET /api/CondicionMedica/{id}
  Future<Map<String, dynamic>> getMedicalConditionById(String id) async {
    try {
      final response = await dio.get('$_medicalEndpoint/$id');

      if (response.statusCode == 200 && response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      }

      throw Exception(
        'Error al obtener condicion medica $id. Código: ${response.statusCode}',
      );
    } on DioException catch (e) {
      print('Error Dio al obtener condicion medica por ID: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al obtener condicion medica por ID: $e');
      rethrow;
    }
  }

  /// POST /api/CondicionMedica
  Future<bool> createMedicalCondition(MedicalConditionPayload payload) async {
    try {
      final response = await dio.post(
        _medicalEndpoint,
        data: payload.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error Dio al crear condicion medica: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al crear condicion medica: $e');
      rethrow;
    }
  }

  /// PUT /api/CondicionMedica/{id}
  Future<bool> updateMedicalCondition(
    String id,
    MedicalConditionPayload payload,
  ) async {
    try {
      final response = await dio.put(
        '$_medicalEndpoint/$id',
        data: payload.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error Dio al actualizar condicion medica $id: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al actualizar condicion medica $id: $e');
      rethrow;
    }
  }

  /// DELETE /api/CondicionMedica/{id}
  Future<bool> deleteMedicalCondition(String id) async {
    try {
      final response = await dio.delete('$_medicalEndpoint/$id');

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error Dio al eliminar condicion medica $id: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al eliminar condicion medica $id: $e');
      rethrow;
    }
  }

  // -----------------------------
  // NUEVO: Datos Personales (Información General)
  // -----------------------------

  Future<Map<String, dynamic>> getPersonalData() async {
    try {
      final response = await dio.get(_personalEndpoint);

      if (response.statusCode == 200 && response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      }

      throw Exception(
        'Formato de respuesta incorrecto o código: ${response.statusCode}',
      );
    } on DioException catch (e) {
      print('Error Dio al obtener datos personales: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al obtener datos personales: $e');
      rethrow;
    }
  }

  Future<bool> updatePersonalData(PersonalDataPayload payload) async {
    try {
      final response = await dio.put(
        _personalEndpoint,
        data: payload.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error Dio al actualizar datos personales: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error general al actualizar datos personales: $e');
      rethrow;
    }
  }
}
