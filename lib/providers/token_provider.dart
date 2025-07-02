import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_provider.g.dart';

@Riverpod(keepAlive: true)
class Token extends _$Token {
  @override
  String build() => '';

  void setToken(String newToken) {
    state = newToken;
  }

  void removeToken() {
    state = '';
  }
}
