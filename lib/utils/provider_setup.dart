

import 'package:barcode_app/core/services/home_services.dart';
import 'package:barcode_app/utils/plugins.dart';
import 'package:provider/single_child_widget.dart';
List<SingleChildWidget> providers = [
  ...apis,
  ...services
];

List<SingleChildWidget> services = [
  ChangeNotifierProxyProvider<ApiImpl, HomeService>(
    create: (_) => HomeService(),
    update: (context, apiImp, dataService) =>
    dataService!..update(apiImp),
  ),
  ChangeNotifierProxyProvider<ApiImpl, AuthenticationService>(
    create: (_) => AuthenticationService(),
    update: (context, apiImp, authenticationService) =>
    authenticationService!..update(apiImp),
  ),

];

List<SingleChildWidget> apis = [
  Provider<ApiImpl>.value(value: ApiImpl()),

];

