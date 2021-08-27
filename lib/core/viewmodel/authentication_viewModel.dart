

import 'package:barcode_app/utils/plugins.dart';
import 'package:stacked/stacked.dart';

class AuthenticationViewModel extends BaseViewModel
{
  late AuthenticationService _service;
  AuthenticationViewModel({required AuthenticationService service}): _service = service;

  Future<ApiResponse> login(
      {String? email,String? pass}) async {
    setBusy(true);
    ApiResponse response = await _service.login(email: email,pass: pass);
    setBusy(false);
    return response;
  }
}