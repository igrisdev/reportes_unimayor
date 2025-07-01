import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_store.g.dart';

@riverpod
String tokenStore(TokenStoreRef ref) {
  return 'token';
}
