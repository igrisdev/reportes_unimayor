import 'package:reportes_unimayor/providers/token_provider.dart';
import 'package:reportes_unimayor/services/api_auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_brigadier_provider.g.dart';

@riverpod
bool isBrigadier(IsBrigadierRef ref) {
  final token = ref.read(tokenProvider);

  if (token.isEmpty) {
    return false; // o throw Exception('Token no disponible');
  }

  try {
    final apiService = ApiAuthService();
    final result = apiService.userType(token);

    return result;
  } catch (e) {
    print('Error en report provider: $e');
    throw e; // Riverpod manejará el error
  }
}
