import 'dart:async';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:barcode_app/core/viewmodel/base_model.dart';
import 'package:barcode_app/core/viewmodel/base_widget.dart';
import 'package:barcode_app/utils/app_colors.dart';
import 'package:barcode_app/utils/plugins.dart';
import 'package:barcode_app/views/dashbord_screen.dart';
import 'package:barcode_app/views/login_screen.dart';

class SplashScreen extends StatelessWidget {
  late AuthenticationService _service;
  @override
  Widget build(BuildContext context) {
    _service = context.watch();
    return Scaffold(
      backgroundColor: AppTheme.PRIMARY_COLOR_BLUE_OPS,
      body: BaseWidget<BaseModel>(
        model: BaseModel(),
        builder: (context, model, child) {
          return TranslationAnimatedWidget.tween(
            enabled: true,
            translationDisabled: Offset(0, 200),
            translationEnabled: Offset(0, 0),
            duration: Duration(seconds: 1),
            child: OpacityAnimatedWidget.tween(
                opacityEnabled: 1,
                opacityDisabled: 0,
                enabled: true,
                duration: Duration(seconds: 1),
                child: Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.COLOR_REDISH,
                              spreadRadius: -2,
                              blurRadius: 20,
                              offset: Offset(0, 10))
                        ],
                        image: DecorationImage(
                            image: AssetImage('assets/ic_attend.jpg'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                AppTheme.PRIMARY_COLOR_BLUE_OPS,
                                BlendMode.difference))),
                    // child: Image(image: AssetImage('assets/ic_attend.jpg'),),
                  ),
                )),
          );
        },
        onModelReady: (model) {
          Timer(Duration(seconds: 3), () async {
            bool res = await _service.autoLogin();
            if (res) {
              Get.off(() => DashBoardScreen());
            } else
              Get.off(() => LoginScrenn());
          });
        },
      ),
    );
  }
}
