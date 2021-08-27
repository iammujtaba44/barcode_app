import 'package:barcode_app/core/viewmodel/authentication_viewModel.dart';
import 'package:barcode_app/utils/plugins.dart';
import 'package:barcode_app/views/dashbord_screen.dart';
import 'package:barcode_app/views/home_screen.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:stacked/stacked.dart';

class LoginScrenn extends StatefulWidget {
  @override
  _LoginScrennState createState() => _LoginScrennState();
}

const users = const {
  'abc@test.com': '12345',
  'hunter@gmail.com': '12345',
};

class _LoginScrennState extends State<LoginScrenn> {
  Duration get loginTime => Duration(milliseconds: 2250);
  late AuthenticationService _service;

  Future<String?> _authUser(LoginData data) async{
    print('Name: ${data.name}, Password: ${data.password}');

    ApiResponse res  = await _service.login(email: data.name,pass: data.password)
    .timeout(Duration(seconds: 5),onTimeout: (){
      ApiResponse r = ApiResponse();
      r.success = false;
      r.msg = "time out";
      return r;

    });
    print(res);
    if(res.success)
      {
        return null;
      }
    else
     return res.msg.toString();
      // return 'User not exists';

    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _service = context.watch();
    return ViewModelBuilder.reactive(builder: (context,model,child){
      return FlutterLogin(
        title: 'LOGIN',
        //logo: 'assets/ic_attend.jpg',
        onLogin: _authUser,
        onSignup: _authUser,
        hideForgotPasswordButton: true,
        hideSignUpButton: true,
        theme: LoginTheme(
          primaryColor: AppTheme.PRIMARY_COLOR_BLUE_OPS,
          accentColor: AppTheme.COLOR_REDISH,
          errorColor: Colors.deepOrange,
          titleStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Quicksand',
            letterSpacing: 4,
          ),
          textFieldStyle: TextStyle(
            color: AppTheme.PRIMARY_COLOR_BLUE_OPS,
            shadows: [Shadow(color: AppTheme.PRIMARY_COLOR_BLUE_OPS, blurRadius: 0)],
          ),

        ),

        onSubmitAnimationCompleted: () {
           Get.off(()=>DashBoardScreen());
        },
        onRecoverPassword: _recoverPassword,
      );
    }, viewModelBuilder:()=> AuthenticationViewModel(service: _service));
  }
}