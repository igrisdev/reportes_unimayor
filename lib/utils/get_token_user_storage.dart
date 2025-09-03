import 'package:reportes_unimayor/utils/local_storage.dart';

Future<String> getTokenUser() async {
  final token = await readStorage('token') ?? '';
  return token;
}
