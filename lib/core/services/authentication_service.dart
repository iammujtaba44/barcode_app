


import 'package:barcode_app/core/models/login_model.dart';
import 'package:barcode_app/core/viewmodel/storage_impl.dart';
import 'package:barcode_app/utils/plugins.dart';
import 'package:barcode_app/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService extends ChangeNotifier
{
   late ApiImpl _api;
  late StorageImpl _storageImpl = new StorageImpl();
  LoginDataUser user = LoginDataUser();
   update(ApiImpl apiImp) {
     _api = apiImp;
     getUser();
   }

   Future<ApiResponse> login(
       {String? email,String? pass}) async {

     ApiResponse response = await _api.login(email: email,pass: pass);
     await setLoggedInStatus(response);
     return response;
   }


   Future<void> setLoggedInStatus(ApiResponse res) async {
     if (res.success) {
       try {
         await _saveInfo(res);
       } catch (e) {
         print(e);
       }
     }
   }
   Future<void> setLoggedOutStatus() async {
       try {
         await _removeInfo();
         Get.off(()=>LoginScrenn());

       } catch (e) {
         print(e);
       }

   }
   _saveInfo(ApiResponse res) async {
     print('------------save user info--------------');
     print(res.data);
     if(res.success)
     {
       Login login = Login.fromJson(res.data);
       await _storageImpl.write(LocalStorageKey.token, login.data!.token!);
       await _storageImpl.write(LocalStorageKey.username, login.data!.user!.name!);
       await _storageImpl.write(LocalStorageKey.userId, login.data!.user!.role!);
       getUser();

     }
   }
   _removeInfo() async {
     print('------------remove user info--------------');
       await _storageImpl.delete(LocalStorageKey.token);
       await _storageImpl.delete(LocalStorageKey.username);
       await _storageImpl.delete(LocalStorageKey.userId);


   }
   Future<bool> autoLogin() async {
     var token = await _storageImpl.read('token');
     if (token != null) {
       return true;
     }
     return false;
   }
   Future getUser() async {
     var res = await _storageImpl.read('token');
     var name = await _storageImpl.read(LocalStorageKey.username);
     var role = await _storageImpl.read(LocalStorageKey.userId);

     if (res != null && res != '') {
       print('Auth token - $res');
     }
     if(name != null && name != '')
       {
         user.name = name;
       }
     if(role != null && role != '')
     {
       user.role = role;
     }
   }
}