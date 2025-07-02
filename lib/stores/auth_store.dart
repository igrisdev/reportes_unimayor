import 'package:reportes_unimayor/models/token_user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_store.g.dart';

@Riverpod(keepAlive: true)
class AuthStore extends _$AuthStore {
  @override
  TokenUserModel build() {
    return TokenUserModel();
  }

  void setToken(TokenUserModel newToken) {
    state = newToken;
  }

  void removeToken() {
    state = TokenUserModel();
  }
}
