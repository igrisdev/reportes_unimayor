import 'package:reportes_unimayor/models/emergency_contact.dart';
import 'package:reportes_unimayor/models/medical_condition.dart';
import 'package:reportes_unimayor/services/api_settings_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

// ---------------------------------------------------------------------------------------------------------------------------------------------------
// Emergency Contacts
// ---------------------------------------------------------------------------------------------------------------------------------------------------

@riverpod
Future<List<EmergencyContact>> emergencyContactsList(
  EmergencyContactsListRef ref,
) async {
  final api = ref.watch(apiSettingsServiceProvider);
  final List<Map<String, dynamic>> rawData = await api.getEmergencyContacts();

  return rawData.map((data) => EmergencyContact.fromJson(data)).toList();
}

@riverpod
Future<EmergencyContact> emergencyContactById(
  EmergencyContactByIdRef ref,
  String id,
) async {
  final api = ref.watch(apiSettingsServiceProvider);
  final Map<String, dynamic> rawData = await api.getEmergencyContactById(id);

  return EmergencyContact.fromJson(rawData);
}

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
    final api = ref.watch(apiSettingsServiceProvider);

    final payload = EmergencyContactPayload(
      nombre: nombre,
      relacion: relacion,
      telefono: telefono,
      telefonoAlternativo: telefonoAlternativo,
      email: email,
      esPrincipal: esPrincipal,
    );

    final response = await api.createEmergencyContact(payload);

    if (response) {
      await ref.refresh(emergencyContactsListProvider.future);

      return true;
    }

    return false;
  } catch (e) {
    print('Error en createEmergencyContact provider: $e');
    rethrow;
  }
}

@riverpod
Future<bool> updateEmergencyContact(
  UpdateEmergencyContactRef ref,
  String id,
  String nombre,
  String relacion,
  String telefono,
  String? telefonoAlternativo,
  String? email,
  bool esPrincipal,
) async {
  try {
    final api = ref.watch(apiSettingsServiceProvider);
    final payload = EmergencyContactPayload(
      nombre: nombre,
      relacion: relacion,
      telefono: telefono,
      telefonoAlternativo: telefonoAlternativo,
      email: email,
      esPrincipal: esPrincipal,
    );

    final res = await api.updateEmergencyContact(id, payload);

    if (res) {
      await ref.refresh(emergencyContactsListProvider.future);

      return true;
    }

    return false;
  } catch (e) {
    print('Error en eliminar contacto de emergencia: $e');
    rethrow;
  }
}

@riverpod
Future<bool> deleteEmergencyContact(
  DeleteEmergencyContactRef ref,
  String id,
) async {
  try {
    final api = ref.watch(apiSettingsServiceProvider);
    final response = await api.deleteEmergencyContact(id);

    if (response) {
      await ref.refresh(emergencyContactsListProvider.future);

      return true;
    }

    return false;
  } catch (e) {
    print('Error en report provider: $e');
    rethrow;
  }
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------
// Medical Conditions
// ---------------------------------------------------------------------------------------------------------------------------------------------------
@riverpod
Future<List<MedicalCondition>> medicalConditionsList(
  MedicalConditionsListRef ref,
) async {
  final api = ref.watch(apiSettingsServiceProvider);
  final raw = await api.getMedicalConditions();

  return raw.map((m) => MedicalCondition.fromJson(m)).toList();
}

@riverpod
Future<MedicalCondition> medicalConditionById(
  MedicalConditionByIdRef ref,
  String id,
) async {
  final api = ref.watch(apiSettingsServiceProvider);
  final raw = await api.getMedicalConditionById(id);
  return MedicalCondition.fromJson(raw);
}

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
      await ref.refresh(medicalConditionsListProvider.future);

      return true;
    }

    return false;
  } catch (e) {
    print('Error en createMedicalCondition provider: $e');
    rethrow;
  }
}

@riverpod
Future<bool> updateMedicalCondition(
  UpdateMedicalConditionRef ref,
  String id,
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

    final res = await api.updateMedicalCondition(id, payload);

    if (res) {
      await ref.refresh(medicalConditionsListProvider.future);

      return true;
    }

    return false;
  } catch (e) {
    print('Error en createMedicalCondition provider: $e');
    rethrow;
  }
}

@riverpod
Future<bool> deleteMedicalCondition(
  DeleteMedicalConditionRef ref,
  String id,
) async {
  try {
    final api = ref.watch(apiSettingsServiceProvider);
    final response = await api.deleteMedicalCondition(id);

    if (response) {
      await ref.refresh(medicalConditionsListProvider.future);

      return true;
    }

    return false;
  } catch (e) {
    print('Error en report provider: $e');
    rethrow;
  }
}

// ----------------------------
// 🧱 NUEVO: DATOS PERSONALES (INFORMACIÓN GENERAL)
// ----------------------------

/// GET /api/DatosPersonales/usuarios/datos-personales
@riverpod
Future<Map<String, dynamic>> personalData(PersonalDataRef ref) async {
  final api = ref.watch(apiSettingsServiceProvider);
  try {
    final result = await api.getPersonalData();
    return result;
  } catch (e) {
    print('Error al obtener datos personales: $e');
    rethrow;
  }
}

/// PUT /api/DatosPersonales/usuarios/datos-personales
@riverpod
Future<bool> updatePersonalData(
  UpdatePersonalDataRef ref,
  String numeroTelefonico,
  String cedula,
  String codigoInstitucional,
) async {
  try {
    final api = ref.watch(apiSettingsServiceProvider);
    final payload = PersonalDataPayload(
      numeroTelefonico: numeroTelefonico,
      cedula: cedula,
      codigoInstitucional: codigoInstitucional,
    );

    final res = await api.updatePersonalData(payload);

    if (res) {
      // Refresca el provider principal para que la pantalla se actualice automáticamente
      await ref.refresh(personalDataProvider.future);
      return true;
    }

    return false;
  } catch (e) {
    print('Error al actualizar datos personales: $e');
    rethrow;
  }
}
