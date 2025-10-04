import 'package:reportes_unimayor/services/api_settings_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

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
    final apiService = ApiSettingsService();

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
      // Opcional: Si tienes un provider que lista todos los contactos de emergencia,
      // podrías invalidarlo aquí para refrescar la lista.
      // ref.invalidate(emergencyContactListProvider);

      return true; // Éxito
    }

    return false; // Error en la API (aunque la API no lance una excepción)
  } catch (e) {
    print('Error en createEmergencyContact provider: $e');
    // Relanzar el error para que el widget pueda manejar los estados (error/loading)
    rethrow;
  }
}
