

import 'package:barcode_app/utils/plugins.dart';

class HomeService extends ChangeNotifier
{
  late ApiImpl _api;
  dynamic _markAs = null;
  DateTime _date = DateTime.now();
  update(ApiImpl apiImp) {
    _api = apiImp;
  }

  dynamic get mark_as => _markAs;
  DateTime get date => _date;
  set date(DateTime val) {
    _date = val;
    notifyListeners();
  }
  set mark_as(dynamic val) {
    _markAs = val;
    notifyListeners();
  }

  Future<ApiResponse> get_attendance() async {

    ApiResponse response = await _api.get_attendance();
    return response;
  }

}