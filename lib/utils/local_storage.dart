import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() =>
    const AndroidOptions(encryptedSharedPreferences: true);

// Create storage
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

// Read value
Future<String?> readStorage(String key) async {
  String? storedValue = await storage.read(key: key);

  return storedValue;
}

// Read all values
// Map<String, String> allValues = await storage.readAll();

// Delete value
Future<void> deleteStorage(String key) async {
  await storage.delete(key: key);
}

// Delete all
Future<void> deleteAllStorage() async {
  await storage.deleteAll();
}

// Write value
Future<void> writeStorage(String key, String value) async {
  await storage.write(key: key, value: value);
}
