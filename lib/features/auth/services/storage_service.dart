
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swaplio_frontend/core/constants.dart';

class StorageService {
    static final storage = FlutterSecureStorage();
    static Future<void> saveToken(String token) async {
   await storage.write(key: Constants.tokenKey, value: token);
    return;
  }
    static Future<String?> getToken() async {
    return storage.read(key: Constants.tokenKey);
  }
    static Future<void> deleteToken() async {
    await storage.delete(key: Constants.tokenKey);
    return;
  }
}