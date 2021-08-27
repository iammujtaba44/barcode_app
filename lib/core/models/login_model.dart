
const String _jsonKeyLoginMessage = "message";
const String _jsonKeyLoginStatus = "status";
const String _jsonKeyLoginData = "data";
const String _jsonKeyLoginDataUser = "user";
const String _jsonKeyLoginDataToken = "token";
const String _jsonKeyLoginDataUserName = "name";
const String _jsonKeyLoginDataUserEmail = "email";
const String _jsonKeyLoginDataUserRole = "role";
class LoginDataUser {
  String? name;
  String? email;
  String? role;

  LoginDataUser({
    this.name,
    this.email,
    this.role,
  });
  LoginDataUser.fromJson(Map<String, dynamic> json) {
    name = json[_jsonKeyLoginDataUserName]?.toString();
    email = json[_jsonKeyLoginDataUserEmail]?.toString();
    role = json[_jsonKeyLoginDataUserRole]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[_jsonKeyLoginDataUserName] = name;
    data[_jsonKeyLoginDataUserEmail] = email;
    data[_jsonKeyLoginDataUserRole] = role;
    return data;
  }
}

class LoginData {
  LoginDataUser? user;
  String? token;

  LoginData({
    this.user,
    this.token,
  });
  LoginData.fromJson(Map<String, dynamic> json) {
    user = (json[_jsonKeyLoginDataUser] != null) ? LoginDataUser.fromJson(json[_jsonKeyLoginDataUser]) : null;
    token = json[_jsonKeyLoginDataToken]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (user != null) {
      data[_jsonKeyLoginDataUser] = user!.toJson();
    }
    data[_jsonKeyLoginDataToken] = token;
    return data;
  }
}

class Login {
  String? message;
  int? status;
  LoginData? data;

  Login({
    this.message,
    this.status,
    this.data,
  });
  Login.fromJson(Map<String, dynamic> json) {
    message = json[_jsonKeyLoginMessage]?.toString();
    status = json[_jsonKeyLoginStatus]?.toInt();
    data = (json[_jsonKeyLoginData] != null) ? LoginData.fromJson(json[_jsonKeyLoginData]) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[_jsonKeyLoginMessage] = message;
    data[_jsonKeyLoginStatus] = status;
    if (data != null) {
      data[_jsonKeyLoginData] = this.data!.toJson();
    }
    return data;
  }
}
