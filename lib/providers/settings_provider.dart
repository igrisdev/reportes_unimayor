import 'package:reportes_unimayor/screens/users/settings/emergency_contacts/emergency_contacts_user_screen.dart';
import 'package:reportes_unimayor/services/api_settings_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
ApiSettingsService apiSettingsService(ApiSettingsServiceRef ref) {
  return ApiSettingsService();
}

// -------------------------------------------------------------------
// R - READ (LISTAR y BUSCAR por ID)
// -------------------------------------------------------------------

// [READ ALL] Provider que lista todos los contactos de emergencia
@riverpod
Future<List<EmergencyContact>> emergencyContactsList(
  EmergencyContactsListRef ref,
) async {
  final apiService = ref.watch(apiSettingsServiceProvider);
  final List<Map<String, dynamic>> rawData = await apiService
      .getEmergencyContacts();

  // Mapear los datos brutos (Map) a objetos EmergencyContact
  return rawData.map((data) => EmergencyContact.fromJson(data)).toList();
}

// [READ ONE] Provider que obtiene un contacto de emergencia por ID
@riverpod
Future<EmergencyContact> emergencyContactById(
  EmergencyContactByIdRef ref,
  String id,
) async {
  final apiService = ref.watch(apiSettingsServiceProvider);
  final Map<String, dynamic> rawData = await apiService.getEmergencyContactById(
    id,
  );

  // Mapear el dato bruto (Map) a objeto EmergencyContact
  return EmergencyContact.fromJson(rawData);
}

// -------------------------------------------------------------------
// C - CREATE
// -------------------------------------------------------------------

@riverpod
Future<bool> createEmergencyContact(
  CreateEmergencyContactRef ref,
  String nombre,
  String relacion,
  String telefono,
  String? telefonoAlternativo,
  String? email,
  bool esPrincipal,
) async {
  try {
    final apiService = ref.watch(apiSettingsServiceProvider);

    // Crear el payload con los datos recibidos
    final payload = EmergencyContactPayload(
      nombre: nombre,
      relacion: relacion,
      telefono: telefono,
      telefonoAlternativo: telefonoAlternativo,
      email: email,
      esPrincipal: esPrincipal,
    );

    final response = await apiService.createEmergencyContact(payload);

    if (response) {
      // Invalida la lista para forzar la recarga en la pantalla principal
      ref.invalidate(emergencyContactsListProvider);
      return true; // Éxito
    }

    return false; // Error en la API (aunque la API no lance una excepción)
  } catch (e) {
    print('Error en createEmergencyContact provider: $e');
    rethrow;
  }
}

// -------------------------------------------------------------------
// U - UPDATE (Manejador de estado)
// -------------------------------------------------------------------

@riverpod
class UpdateEmergencyContact extends _$UpdateEmergencyContact {
  @override
  FutureOr<void> build() {}

  Future<bool> updateContact({
    required String id,
    required String nombre,
    required String relacion,
    required String telefono,
    required String? telefonoAlternativo,
    required String? email,
    required bool esPrincipal,
  }) async {
    final result = await AsyncValue.guard(() async {
      final apiService = ref.read(apiSettingsServiceProvider);

      final payload = EmergencyContactPayload(
        nombre: nombre,
        relacion: relacion,
        telefono: telefono,
        telefonoAlternativo: telefonoAlternativo,
        email: email,
        esPrincipal: esPrincipal,
      );

      final success = await apiService.updateEmergencyContact(id, payload);

      if (!success) {
        throw Exception('La API devolvió false al actualizar.');
      }

      ref.invalidate(emergencyContactsListProvider);
      return true;
    });

    if (result.hasError) {
      state = AsyncValue.error(result.error!, result.stackTrace!);
      return false;
    } else {
      state = const AsyncValue.data(null);
      return true;
    }
  }
}

// -------------------------------------------------------------------
// D - DELETE (Manejador de estado)
// -------------------------------------------------------------------

@riverpod
class DeleteEmergencyContact extends _$DeleteEmergencyContact {
  @override
  FutureOr<void> build() {}

  Future<void> deleteContact(String id) async {
    state = await AsyncValue.guard(() async {
      final apiService = ref.read(apiSettingsServiceProvider);
      final success = await apiService.deleteEmergencyContact(id);

      if (!success) {
        throw Exception('Fallo la eliminación en la API.');
      }

      ref.invalidate(emergencyContactsListProvider);
    });
  }
}

// -----------------------------
// MODELO local (ligero) para mapear desde la API
// -----------------------------
class MedicalCondition {
  final String id;
  final int? idUsuario;
  final String nombre;
  final String descripcion;
  final DateTime fechaDiagnostico;
  final String? mensaje;

  MedicalCondition({
    required this.id,
    this.idUsuario,
    required this.nombre,
    required this.descripcion,
    required this.fechaDiagnostico,
    this.mensaje,
  });

  factory MedicalCondition.fromJson(Map<String, dynamic> json) {
    final idValue = json['idCondicionMedica'] ?? json['id'] ?? '';
    final String idStr = idValue is int
        ? idValue.toString()
        : (idValue as String);

    DateTime parsedDate;
    final rawDate = json['fechaDiagnostico'];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else {
      parsedDate = DateTime.now();
    }

    return MedicalCondition(
      id: idStr,
      idUsuario: json['idUsuario'] is int
          ? json['idUsuario'] as int
          : (json['idUsuario'] != null
                ? int.tryParse(json['idUsuario'].toString())
                : null),
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      fechaDiagnostico: parsedDate,
      mensaje: json['mensaje'] as String?,
    );
  }
}

// -----------------------------
// READ ALL
// -----------------------------
@riverpod
Future<List<MedicalCondition>> medicalConditionsList(
  MedicalConditionsListRef ref,
) async {
  final api = ref.watch(apiSettingsServiceProvider);
  final raw = await api.getMedicalConditions();

  return raw.map((m) => MedicalCondition.fromJson(m)).toList();
}

// -----------------------------
// READ ONE
// -----------------------------
@riverpod
Future<MedicalCondition> medicalConditionById(
  MedicalConditionByIdRef ref,
  String id,
) async {
  final api = ref.watch(apiSettingsServiceProvider);
  final raw = await api.getMedicalConditionById(id);
  return MedicalCondition.fromJson(raw);
}

// -----------------------------
// CREATE
// -----------------------------
@riverpod
Future<bool> createMedicalCondition(
  CreateMedicalConditionRef ref,
  String nombre,
  String descripcion,
  DateTime fechaDiagnostico,
) async {
  try {
    final api = ref.watch(apiSettingsServiceProvider);
    final payload = MedicalConditionPayload(
      nombre: nombre,
      descripcion: descripcion,
      fechaDiagnostico: fechaDiagnostico,
    );
    final res = await api.createMedicalCondition(payload);

    if (res) {
      ref.invalidate(medicalConditionsListProvider);
      return true;
    }

    return false;
  } catch (e) {
    print('Error en createMedicalCondition provider: $e');
    rethrow;
  }
}

// -----------------------------
// UPDATE
// -----------------------------
@riverpod
class UpdateMedicalCondition extends _$UpdateMedicalCondition {
  @override
  FutureOr<void> build() {}

  Future<bool> updateCondition({
    required String id,
    required String nombre,
    required String descripcion,
    required DateTime fechaDiagnostico,
  }) async {
    final result = await AsyncValue.guard(() async {
      final api = ref.read(apiSettingsServiceProvider);

      final payload = MedicalConditionPayload(
        nombre: nombre,
        descripcion: descripcion,
        fechaDiagnostico: fechaDiagnostico,
      );

      final success = await api.updateMedicalCondition(id, payload);
      if (!success) {
        throw Exception('API returned false on update.');
      }

      ref.invalidate(medicalConditionsListProvider);
      return true;
    });

    if (result.hasError) {
      state = AsyncValue.error(result.error!, result.stackTrace!);
      return false;
    } else {
      state = const AsyncValue.data(null);
      return true;
    }
  }
}

// -----------------------------
// DELETE
// -----------------------------
@riverpod
class DeleteMedicalCondition extends _$DeleteMedicalCondition {
  @override
  FutureOr<void> build() {}

  Future<void> deleteCondition(String id) async {
    state = await AsyncValue.guard(() async {
      final api = ref.read(apiSettingsServiceProvider);
      final success = await api.deleteMedicalCondition(id);

      if (!success) {
        throw Exception('La API devolvió false al eliminar condicion medica.');
      }

      ref.invalidate(medicalConditionsListProvider);
    });
  }
}
