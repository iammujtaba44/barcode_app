import 'package:shared_preferences/shared_preferences.dart';

class StorageImpl {
  static StorageImpl _instance = new StorageImpl.internal();
  StorageImpl.internal();
  factory StorageImpl() => _instance;

  SharedPreferences? storage;

  Future<String?> read(String key)async{
   storage = await SharedPreferences.getInstance();
  return storage!.getString(key);
  }

  Future<bool> write(String key, String value) async{
    storage = await SharedPreferences.getInstance();
    return storage!.setString(key,value);
  }

  Future<bool> delete(String key) async{
    storage = await SharedPreferences.getInstance();
    return storage!.remove(key);  }

}

class LocalStorageKey {
  static const String user = "user";
  static const String username = "username";
  static const String userId = "role";
  static const String password = "password";
  static const String token = "token";
  static const String applang = "applang";
}