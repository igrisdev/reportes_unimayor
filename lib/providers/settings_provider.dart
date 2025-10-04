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
  FutureOr<void> build() {
    // Estado inicial
  }

  /// Actualiza un contacto y retorna true si fue exitoso.
  Future<bool> updateContact({
    required String id,
    required String nombre,
    required String relacion,
    required String telefono,
    required String? telefonoAlternativo,
    required String? email,
    required bool esPrincipal,
  }) async {
    state = const AsyncValue.loading();
    try {
      final apiService = ref.read(apiSettingsServiceProvider);

      final payload = EmergencyContactPayload(
        nombre: nombre,
        relacion: relacion,
        telefono: telefono,
        telefonoAlternativo: telefonoAlternativo,
        email: email,
        esPrincipal: esPrincipal,
      );

      final bool success = await apiService.updateEmergencyContact(id, payload);

      if (!success) {
        // Si la API devuelve 'false', lanzamos una excepción para que el catch la maneje.
        throw Exception(
          'Fallo la actualización en la API. Resultado no exitoso.',
        );
      }

      ref.invalidate(emergencyContactsListProvider);

      state = const AsyncValue.data(null);
      return true; // Retorna explícitamente true en caso de éxito
    } catch (e, st) {
      // Captura cualquier excepción (incluyendo la lanzada arriba)
      state = AsyncValue.error(e, st);
      return false; // Retorna false en caso de cualquier error
    }
  }
}

// -------------------------------------------------------------------
// D - DELETE (Manejador de estado)
// -------------------------------------------------------------------

// Usamos StateNotifierProvider para manejar el estado de la operación de borrado
@riverpod
class DeleteEmergencyContact extends _$DeleteEmergencyContact {
  @override
  FutureOr<void> build() {}

  Future<void> deleteContact(String id) async {
    state = const AsyncValue.loading();
    try {
      final apiService = ref.read(apiSettingsServiceProvider);
      final success = await apiService.deleteEmergencyContact(id);

      if (success) {
        // Invalida la lista para forzar la recarga
        ref.invalidate(emergencyContactsListProvider);
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Fallo la eliminación en la API.');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
