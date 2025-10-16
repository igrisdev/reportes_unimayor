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
  final api = ApiSettingsService();
  final List<Map<String, dynamic>> rawData = await api.getEmergencyContacts();

  return rawData.map((data) => EmergencyContact.fromJson(data)).toList();
}

@riverpod
Future<EmergencyContact> emergencyContactById(
  EmergencyContactByIdRef ref,
  String id,
) async {
  final api = ApiSettingsService();
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
    final api = ApiSettingsService();

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
    final api = ApiSettingsService();
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
    final apiService = ApiSettingsService();
    final response = await apiService.deleteEmergencyContact(id);

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
  final api = ApiSettingsService();
  final raw = await api.getMedicalConditions();

  return raw.map((m) => MedicalCondition.fromJson(m)).toList();
}

@riverpod
Future<MedicalCondition> medicalConditionById(
  MedicalConditionByIdRef ref,
  String id,
) async {
  final api = ApiSettingsService();
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
    final api = ApiSettingsService();
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
    final api = ApiSettingsService();
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
    final apiService = ApiSettingsService();
    final response = await apiService.deleteMedicalCondition(id);

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
