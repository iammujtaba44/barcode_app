import 'dart:developer';
import 'dart:io';

import 'package:barcode_app/utils/app_utils.dart';
import 'package:barcode_app/utils/plugins.dart';
import 'package:barcode_app/utils/tile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeService _service;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  late QRViewController controller;

  bool permission = false;

  @override
  void initState() {
    super.initState();
  }

  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller.resumeCamera();
  //   }
  // }
  Future<PermissionStatus> _getCameraPermission() async {
    print("called");
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      return result;
    } else {
      setState(() {
        permission = true;
      });
      return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    _service = context.watch();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.PRIMARY_COLOR_BLUE_OPS,
        title: Text('Scan'),
        centerTitle: true,
      ),
      body: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder:()=> HomeViewModel(homeService: _service),
        builder: (context, model, child) {
          if (model.initialised)
            return MyLoader(
              color: AppTheme.PRIMARY_COLOR_BLUE_OPS,
            );
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                TitleView(
                  titleTxt: 'Select In/Out',
                ),
                Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.symmetric(horizontal: width*0.2),
                  margin: const EdgeInsets.only(
                      left: 24, right: 24, top: 5, bottom: 18),
                  decoration: getCardDecorationWithLessRound,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 1,
                        groupValue: _service.mark_as,
                        onChanged: (value) {
                          _service.mark_as = value;
                          controller.resumeCamera();

                        },
                        activeColor: Colors.green,
                        fillColor: MaterialStateColor.resolveWith(
                                (states) => AppTheme.COLOR_PRESENT),
                      ),

                      Container(
                        child: Text(
                          'IN',
                          style: TextStyle(
                            color: AppTheme.COLOR_PRESENT,
                            fontFamily: 'Times',
                            fontSize: APPUTILS.getFontSizeByHeight(context, 0.02),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      //  Spacer(),
                      Radio(
                        value: 2,
                        groupValue: _service.mark_as,
                        onChanged: (value) {
                          _service.mark_as = value;
                          controller.resumeCamera();
                        },
                        activeColor: Colors.green,
                        fillColor: MaterialStateColor.resolveWith(
                                (states) => AppTheme.COLOR_ABSENT),
                      ),
                      Container(
                        child: Text(
                          'OUT',
                          style: TextStyle(
                            color: AppTheme.COLOR_ABSENT,
                            fontFamily: 'Times',
                            fontSize: APPUTILS.getFontSizeByHeight(context, 0.02),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TitleView(
                  titleTxt: 'Attendance Date',
                ),
                InkWell(
                  onTap: () {
                    getDatePicker(height);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, top: 5, bottom: 18),
                    decoration: getCardDecorationWithLessRound,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Current Date : ',
                            style: TextStyle(
                              color: AppTheme.PRIMARY_COLOR_BLUE_OPS,
                              fontFamily: 'Times',
                              fontSize: APPUTILS.getFontSizeByHeight(context, .02),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        //  Spacer(),
                        Container(
                          child: Text(
                            '${_service.date.toString().substring(0,10)}',
                            style: TextStyle(
                              color: AppTheme.GREY,
                              fontFamily: 'Times',
                              fontSize: APPUTILS.getFontSizeByHeight(context, .02),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height * .7,
                  alignment: Alignment.center,
                  child: _buildQrView(context),
                )
              ],
            ),
          );
        },
        onModelReady: (model) async {
          model.setInitialised(true);
          PermissionStatus temp = await _getCameraPermission();
          if (temp.isGranted)
            setState(() {
              permission = true;
            });
          model.setInitialised(false);
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if(_service.mark_as == null)
        {
          APPUTILS.mySnackBar(msg: "Please select IN/OUT");
          controller.pauseCamera();
        }
      else
        {
          print(scanData);
          print(scanData.code);
          print(scanData.format);

          controller.stopCamera();
          controller.dispose();
          Get.back();
        }

    });
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return permission
        ? QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          )
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Your have not granted permission please do it!'),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  onPressed: () async {
                    PermissionStatus temp = await _getCameraPermission();
                    if (temp.isGranted)
                      setState(() {
                        permission = true;
                      });
                  },
                  backgroundColor: AppTheme.PRIMARY_COLOR_BLUE_OPS,
                  child: Icon(Icons.camera),
                ),
              ],
            ),
          );
  }

  void _onPermissionSet(
      BuildContext context, QRViewController ctrl, bool p) async {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      APPUTILS.mySnackBar(title: 'Permission Error', msg: 'No Permission');
      setState(() {
        permission = p;
      });
      //  await _getCameraPermission();
    } else
      setState(() {
        permission = p;
      });
  }

   getDatePicker(double height) {
    return DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now().subtract(Duration(days: 360)),
        maxTime: DateTime.now().add(Duration(days: 360)),
        theme: DatePickerTheme(
            backgroundColor: AppTheme.WHITE,
            containerHeight: height * 0.3,
            cancelStyle: TextStyle(
              color: AppTheme.COLOR_ABSENT,
              fontFamily: 'Times',
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
            doneStyle: TextStyle(
              color: AppTheme.COLOR_PRESENT,
              fontFamily: 'Times',
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
            headerColor: AppTheme.background), onChanged: (date) {
         // print('change $date');
        }, onConfirm: (date) {
          _service.date = date;
        }, currentTime: _service.date, locale: LocaleType.en);
  }


}
