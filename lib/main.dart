
import 'package:barcode_app/utils/app_colors.dart';
import 'package:barcode_app/utils/plugins.dart';
import 'package:barcode_app/utils/provider_setup.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Attendance',
        themeMode: ThemeMode.light,
        theme: ThemeData(
          primarySwatch: AppTheme.PRIMARY_COLOR,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
