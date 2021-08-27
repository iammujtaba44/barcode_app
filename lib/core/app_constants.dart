
import 'package:barcode_app/core/viewmodel/storage_impl.dart';

class AppConstants {

  StorageImpl _storageImpl = StorageImpl();
  static const String HOST = 'https://school.letmesent.com/';
  static const String API_URL = '${HOST}rest/';
  static const String LOGIN = 'apilogin';
  static const String STUDENT_ATTENDANCE = 'getStudentAttendance';
  static const String STAFF_ATTENDANCE = 'getStaffAttendance';

  static const String LOCAL_API_URL = 'https://172.16.105.23/smartSchool/rest/';
  static const String NGROK_LOGIN = 'http://5439-103-228-159-4.ngrok.io/smartSchool/rest/Apilogin';
  static const String LOCAL_STUDENT_ATTENDANCE = '${LOCAL_API_URL}getStudentAttendance';
  static const String LOCAL_STAFF_ATTENDANCE = '${LOCAL_API_URL}getStaffAttendance';


  Future<String?> getAccordingGettterUrl() async
  {
    var res = await _storageImpl.read(LocalStorageKey.userId);
    if(res!.contains('Teacher'))
      return STUDENT_ATTENDANCE;
    if(res.contains('Admin') || res.contains('Super Admin'))
      return STAFF_ATTENDANCE;


  }

}