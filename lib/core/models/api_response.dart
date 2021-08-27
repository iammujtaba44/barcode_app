

class ApiResponse{

  late bool _success;
  late String _msg;
  late String _errors;
  dynamic _status;
  dynamic _data;

  dynamic get status => _status;
  set status(dynamic value) {
    _status = value;
  }

  dynamic get data => _data;
  set data(dynamic value) {
    _data = value;
  }

  bool get success => _success;
  set success(bool value) {
    _success = value;
  }

  String get msg => _msg;
  set msg(String value) {
    _msg = value;
  }
}