import 'package:reportes_unimayor/services/api_auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_brigadier_provider.g.dart';

@riverpod
Future<bool> isBrigadier(IsBrigadierRef ref) async {
  try {
    final apiService = ApiAuthService();
    final result = await apiService.userType();

    return result;
  } catch (e) {
    print('Error en isBrigadierProvider: $e');
    return false;
  }
}
