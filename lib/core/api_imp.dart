import 'dart:convert';
import 'dart:io';

//import 'package:barcode_app/utils/plugins.dart';
import 'package:barcode_app/core/app_constants.dart';
import 'package:barcode_app/core/models/api_response.dart';
import 'package:barcode_app/core/viewmodel/storage_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiImpl {
  final MyClient _client;

  ApiImpl()
      : _client = MyClient(
          defaultHeaders: {},
        );

  ///** -----------auth apis---------- */
  Future<ApiResponse> login({String? email, String? pass}) async {
    ApiResponse response = await _client.post(AppConstants.LOGIN,
        headers: <String, String>{},
        body: <String, String>{'email': email!, 'password': pass!});
    return response;
  }

  ///Get

  Future<ApiResponse> get_attendance() async {
    ApiResponse response = await _client.get(
      await AppConstants().getAccordingGettterUrl(),
      headers: <String, String>{},
    ).onError((error, stackTrace) {
      print("In ERROR ->> ${error}");
      ApiResponse t = ApiResponse();
      t.data = null;
      t.msg = 'Unkown Error';
      t.success = false;
      return t;
    });
    return response;
  }

  Future<ApiResponse> mark_attendance(
      {Map<String, String>? body, String? Url}) async {
    ApiResponse response = await _client
        .withoutBaseUrlpost(Url!, headers: <String, String>{}, body: body)
        .onError((error, stackTrace) {
      print("In ERROR ->> ${error}");
      ApiResponse t = ApiResponse();
      t.data = null;
      t.msg = 'Unkown Error';
      t.success = false;
      return t;
    });
    return response;
  }
}

class MyClient {
  final Map<String, String> defaultHeaders;
  http.Client _httpClient = new http.Client();
  HttpClient _Client = new HttpClient();

  final baseUrl = AppConstants.API_URL;
  StorageImpl _StorageImpl = StorageImpl();

  MyClient({this.defaultHeaders = const {}});

  Future<ApiResponse> _generateResponse(Response res) async {
    ApiResponse _apiResponse = ApiResponse();

    _apiResponse.data = null;
    print(res.body);
    try {
      var data = json.decode(res.body);
      _apiResponse.status = data['status']; //res.statusCode;
      _apiResponse.msg = data["message"] ?? "no msg";
      _apiResponse.success = _apiResponse.status == 200 ? true : false;
      _apiResponse.data = _apiResponse.status != 200 || data['data'] == false
          ? null
          : json.decode(res.body);
    } on SocketException {
      print("********Socket Exception ");
      _apiResponse.status = 1;
      _apiResponse.success = false;
      _apiResponse.msg =
          "No Internet Available.\nPlease check your internet connection & Try Again!";
    } on FormatException {
      print("********Format Exception ");
      _apiResponse.success = false;
      _apiResponse.status = 2;
      _apiResponse.msg = "Something went wrong, Please try again.";
    } on HttpException {
      print("********Http Exception ");
      _apiResponse.success = false;
      _apiResponse.status = 3;
      _apiResponse.msg = "Something went wrong, Please try again.";
    } catch (e) {
      print("********Unknown Exception ${e.toString()}");
      _apiResponse.success = false;
      _apiResponse.status = 4;
      _apiResponse.msg = "Something went wrong, Our team has been notified";
    }
    return _apiResponse;
  }

  @override
  Future<ApiResponse> get(url, {Map<String, String>? headers}) async {
    print("******** (GET REQUEST) ********");
    url = '$baseUrl$url';
    headers!.addAll({'token': await _getToken()});
    http.Response res = await _httpClient.get(Uri.parse(url), headers: headers);
    print("${res.request}");

    return _generateResponse(res);
  }

  @override
  Future<ApiResponse> post(String url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    print("******** (POST REQUEST) ********");
    url = '$baseUrl$url';
    print(url);
    headers!.addAll(defaultHeaders);
    headers.addAll({'token': await _getToken()});
    http.Response res = await _httpClient.post(Uri.parse(url),
        headers: headers, body: body, encoding: encoding);
    print("${res.request}");

    return _generateResponse(res);
  }

  Future<ApiResponse> withoutBaseUrlpost(String url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    print("******** (POST REQUEST) ********");
    print(url);
    headers!.addAll(defaultHeaders);
    headers.addAll({'token': await _getToken()});
    http.Response res = await _httpClient.post(Uri.parse(url),
        headers: headers, body: body, encoding: encoding);
    print("${res.request}");

    return _generateResponse(res);
  }

  @override
  Future<ApiResponse> delete(url, {Map<String, String>? headers}) async {
    print("******** (DELETE REQUEST) ********");

    // url = '$baseUrl$url';
    headers!.addAll(defaultHeaders);
    // headers!.addAll({'Authorization': await _getToken()});
    http.Response res = await _httpClient.get(url, headers: headers);
    return _generateResponse(res);
  }

  Future<String> _getToken() async {
    print('---------get token----------');
    var token = await _StorageImpl.read('token');
    if (token != '' && token != null) token = '$token';
    print(token);
    return token.toString();
  }
}
