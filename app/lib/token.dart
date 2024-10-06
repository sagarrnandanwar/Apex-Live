import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await storage.write(key: 'authToken', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'authToken');
}

Future<void> removeToken() async {
  await storage.delete(key: 'authToken');
}
