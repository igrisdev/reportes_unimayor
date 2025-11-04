import 'package:reportes_unimayor/services/api_auth_service.dart';
import 'package:reportes_unimayor/services/api_auth_with_google.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier_provider.g.dart';

enum AuthStatus { authenticated, unauthenticated, checking }

class AuthState {
  final AuthStatus status;
  final bool? isBrigadier;
  AuthState({this.status = AuthStatus.checking, this.isBrigadier});
  AuthState copyWith({AuthStatus? status, bool? isBrigadier}) {
    return AuthState(
      status: status ?? this.status,
      isBrigadier: isBrigadier ?? this.isBrigadier,
    );
  }
}

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    checkAuthStatus();
    return AuthState();
  }

  Future<void> checkAuthStatus() async {
    final token = await readStorage('token');

    if (token != null) {
      final isBrigadier = await ref.read(apiAuthServiceProvider).userType();

      state = AuthState(
        status: AuthStatus.authenticated,
        isBrigadier: isBrigadier,
      );
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login() async {
    final isBrigadier = await ref.read(apiAuthServiceProvider).userType();
    state = AuthState(
      status: AuthStatus.authenticated,
      isBrigadier: isBrigadier,
    );
  }

  Future<void> logout() async {
    print("[AuthNotifier] logout: Empezando logout flow...");
    try {
      await ref.read(apiAuthWithGoogleProvider).googleSingOut();
    } catch (e) {
      print('Error durante googleSignOut en AuthNotifier: $e');
    }
    await deleteAllStorage();
    state = AuthState(status: AuthStatus.unauthenticated);
    print(
      "[AuthNotifier] logout: ¡ESTADO FINAL ESTABLECIDO! -> unauthenticated",
    );
  }
}
