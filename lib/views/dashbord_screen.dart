import 'package:barcode_app/utils/plugins.dart';
import 'package:barcode_app/utils/tile_view.dart';
import 'package:barcode_app/views/home_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as curve;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final GlobalKey<SfCircularChartState> _circularChartKey = GlobalKey();
  late HomeService _homeService;
  late AuthenticationService _authenticationService;
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Present', y: 25, text: '25%'),
    ChartSampleData(x: 'Late', y: 4, text: '4%'),
    ChartSampleData(x: 'Absent', y: 14, text: '14%'),
    ChartSampleData(x: 'Half Day', y: 10, text: '10%'),
    ChartSampleData(x: 'Total Present', y: 15, text: '15%'),
    ChartSampleData(x: 'Total Absent', y: 7, text: '7%'),
    ChartSampleData(x: 'Total Half Day', y: 25, text: '25%'),
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    _homeService = context.watch();
    _authenticationService = context.watch();
    return Scaffold(

        appBar: AppBar(
          backgroundColor: AppTheme.PRIMARY_COLOR_BLUE_OPS,
          title: Text('Attendance'),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: _FAB(),
        backgroundColor: AppTheme.background,
        body: ViewModelBuilder<HomeViewModel>.reactive(

            builder: (context, model, child) {
              if (model.initialised)
                return MyLoader(
                  color: AppTheme.PRIMARY_COLOR_BLUE_OPS,
                );
              return SingleChildScrollView(
                child: Column(children: <Widget>[
                  SizedBox(height: height*0.05,),
                  TitleView(
                    titleTxt: 'User',
                    subTxt: 'Role',
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, top: 5, bottom: 18),
                    padding: EdgeInsets.all(10),
                    decoration: getCardDecorationWithLessRound,
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            '${_authenticationService.user.name}',
                            style: TextStyle(
                                color: AppTheme.lightText,
                                fontFamily: 'Times',
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Text(
                            '${_authenticationService.user.role}',
                            style: TextStyle(
                                color: AppTheme.lightText,
                                fontFamily: 'Times',
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),

                  TitleView(
                    titleTxt: 'All Feature',
                    subTxt: 'All Statistics',
                  ),
                  _buildCircularChart(),
                  TitleView(
                    titleTxt: 'Detail view',
                    subTxt: '',
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, top: 16, bottom: 18),
                    decoration: getCardDecoration,
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                height: 200,
                                child: _buildGauge(
                                    barColor: AppTheme.COLOR_PRESENT,value: chartData[0].y!.toDouble(),middleText: 'Present'))),
                        Expanded(
                            child: SizedBox(
                                height: 200,
                                child:
                                    _buildGauge(barColor: AppTheme.COLOR_LATE,value: chartData[1].y!.toDouble(),middleText: 'Late'))),
                      ],
                    ),
                  ),
                  // TitleView(
                  //   titleTxt: 'Absent',
                  //   subTxt: 'Half Day',
                  // ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, bottom: 18),
                    decoration: getCardDecoration,
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                height: 200,
                                child: _buildGauge(
                                    barColor: AppTheme.COLOR_ABSENT,value: chartData[2].y!.toDouble(),
                                    middleText: 'Absent'))),
                        Expanded(
                            child: SizedBox(
                                height: 200,
                                child: _buildGauge(
                                    barColor: AppTheme.COLOR_HALFDAY,value: chartData[3].y!.toDouble(),
                                    middleText: 'Half Day'))),
                      ],
                    ),
                  ),
                  // TitleView(
                  //   titleTxt: 'Total Present',
                  //   subTxt: 'Total Absent',
                  // ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, bottom: 18),
                    decoration: getCardDecoration,
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                height: 200,
                                child: _buildGauge(
                                    barColor: AppTheme.COLOR_TOTAL_PRESENT,value: chartData[4].y!.toDouble(),
                                    middleText: 'Total\nPresent'))),
                        Expanded(
                            child: SizedBox(
                                height: 200,
                                child: _buildGauge(
                                    barColor: AppTheme.COLOR_TOTAL_ABSENT,value: chartData[5].y!.toDouble(),
                                    middleText: 'Total\nAbsent'))),
                      ],
                    ),
                  ),
                  // TitleView(
                  //   titleTxt: 'Total Half Day',
                  //   subTxt: '',
                  // ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, bottom: 18),
                    decoration: getCardDecoration,
                    child: SizedBox(
                        height: 200,
                        child:
                            _buildGauge(barColor: AppTheme.COLOR_TOTAL_HALFDAY,value: chartData[6].y!.toDouble(),
                                middleText: 'Total\nHalf Day')),
                  ),
                ]),
              );
            },
            viewModelBuilder: () => HomeViewModel(homeService: _homeService),
        onModelReady: (model)async{
             //  model.setInitialised(true);
             // await model.get_attendance();
             //  model.setInitialised(false);

        },
        ));
  }
Widget _FAB()=> Column(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FloatingActionButton(
      onPressed: (){
        Get.to(()=> HomeScreen());
      },
      tooltip: 'Scan',
      heroTag: 'scan',
      backgroundColor: AppTheme.COLOR_REDISH,
      elevation: APPUTILS.getFontSizeByHeight(context, .02),
      highlightElevation:APPUTILS.getFontSizeByHeight(context, .09),
      splashColor: AppTheme.PRIMARY_COLOR_BLUE_OPS,
      child: Icon(
        Icons.qr_code_scanner_sharp,
        size: APPUTILS.getFontSizeByHeight(context, .03),
      ),
    ),
    SizedBox(height: APPUTILS.getFontSizeByHeight(context, .02),),
    FloatingActionButton(
      onPressed: (){
        _authenticationService.setLoggedOutStatus();
        //  Get.to(()=> HomeScreen());
      },
      tooltip: 'Log out',
      heroTag: 'log_out',
      backgroundColor: Colors.red.withOpacity(0.9),
      elevation: APPUTILS.getFontSizeByHeight(context, .02),
      highlightElevation:APPUTILS.getFontSizeByHeight(context, .09),
      splashColor: AppTheme.PRIMARY_COLOR_BLUE_OPS,
      child: Icon(
        Icons.logout,
        size: APPUTILS.getFontSizeByHeight(context, .03),
      ),
    ),
  ],
);
  // SpeedDial _FAB(double height) {
  //   return SpeedDial(
  //   animatedIcon: AnimatedIcons.menu_close,
  //   direction: SpeedDialDirection.Down,
  //   activeBackgroundColor: AppTheme.COLOR_REDISH,
  //   overlayColor: AppTheme.PRIMARY_COLOR_BLUE_OPS,
  //   overlayOpacity: 0.5,
  //   animatedIconTheme: IconThemeData(size: 22),
  //   backgroundColor: AppTheme.COLOR_REDISH,
  //   visible: true,
  //   curve: Curves.bounceIn,
  //   buttonSize: height*0.07,
  //   childrenButtonSize: height*0.07,
  //   children: [
  //     SpeedDialChild(
  //         child: Icon(Icons.qr_code_scanner_sharp,color:Colors.white),
  //         backgroundColor: AppTheme.PRIMARY_COLOR,
  //         onTap: () {
  //           Get.to(()=> HomeScreen());
  //
  //         },
  //         label: 'Scan For Attendance',
  //         labelStyle: TextStyle(
  //             fontWeight: FontWeight.w500,
  //             color: Colors.white,
  //             fontSize: 16.0),
  //         labelBackgroundColor: AppTheme.PRIMARY_COLOR
  //     ),
  //     SpeedDialChild(
  //         child: Icon(Icons.logout,color: Colors.white,),
  //         backgroundColor: Colors.red,
  //         onTap: () {
  //           },
  //         label: 'Log Out',
  //         labelStyle: TextStyle(
  //             fontWeight: FontWeight.w500,
  //             color: Colors.white,
  //             fontSize: 16.0),
  //         labelBackgroundColor: Colors.red
  //     ),
  //   ],
  // );
  // }

  /// Get default circular chart
  Widget _buildCircularChart() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        decoration: getCardDecoration,
        child: SfCircularChart(
          key: _circularChartKey,
          legend: Legend(
            isVisible: true,
            position: LegendPosition.left,
            overflowMode: LegendItemOverflowMode.wrap,
            iconBorderWidth: 1,
            iconBorderColor: Colors.white,
            // title: LegendTitle(text: 'Attendance')
            iconHeight: 20,
            iconWidth: 20,
          ),

          //title: ChartTitle(text: ''),
          // annotations: <CircularChartAnnotation>[
          //   CircularChartAnnotation(
          //       height: '55%',
          //       width: '55%',
          //       widget: Container(
          //           child: SizedBox(
          //         height: 20,
          //         width: 20,
          //         child: Icon(Icons.calendar_today, color: Colors.black),
          //       )))
          // ],

          series: _getDefaultCircularSeries(),
          onSelectionChanged: (value) {
            print(value);
          },
          onLegendTapped: (value) {
            print("onLegendTapperd ->$value");
          },
          onChartTouchInteractionDown: (value) {
            print("onChartTouchInteractionDown ->$value");
          },
        ),
      ),
    );
  }

  /// Get default circular series
  List<CircularSeries<ChartSampleData, String>> _getDefaultCircularSeries() {

    return <CircularSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          dataSource: chartData,
          // radius: '70',
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          strokeColor: Colors.white,
          //  : Colors.black,
          explode: true,
          strokeWidth: 1,
          legendIconType: LegendIconType.rectangle,
          dataLabelMapper: (ChartSampleData sales, _) => sales.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }

  SfRadialGauge _buildGauge(
      {dynamic value = 50.0,
      dynamic intialValue = 0.0,
      dynamic finalValue = 100.0,
      Color barColor = AppTheme.COLOR_REDISH,String middleText = 'text'}) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            minimum: intialValue,
            maximum: finalValue,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
                thicknessUnit: GaugeSizeUnit.factor, thickness: 0.15),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 180,
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Text(
                            '$value',
                            style: TextStyle(
                                fontFamily: 'Times',
                                fontSize: APPUTILS.getFontSizeByHeight(context, 0.02),
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Container(
                          child: Text(
                            ' / $finalValue',
                            style: TextStyle(
                                fontFamily: 'Times',
                                fontSize: APPUTILS.getFontSizeByHeight(context, 0.02),
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                      SizedBox(height: 5,),
                      Container(
                        child: Text(
                          '$middleText',
                          style: TextStyle(
                            color: AppTheme.lightText,
                              fontFamily: 'Times',
                              fontSize: APPUTILS.getFontSizeByHeight(context, 0.02),
                              fontWeight: FontWeight.w400,),
                        ),
                      ),
                    ],
                  )),
            ],
            pointers: <GaugePointer>[
              RangePointer(
                  value: value,
                  enableAnimation: true,
                  cornerStyle: curve.CornerStyle.bothCurve,
                  animationDuration: 1200,
                  animationType: AnimationType.ease,
                  sizeUnit: GaugeSizeUnit.factor,
                  gradient: SweepGradient(
                      colors: <Color>[barColor.withOpacity(0.6), barColor],
                      stops: <double>[0.25, 0.75]),
                  color: Color(0xFF00A8B5),
                  width: 0.15),
            ]),
      ],
    );
  }

  SfRadialGauge _buildDistanceTrackerExample(
      {dynamic value = 50.0,
      dynamic intialValue = 0.0,
      dynamic finalValue = 100.0,
      Color barColor = AppTheme.COLOR_REDISH}) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            radiusFactor: 0.5,
            minimum: intialValue,
            maximum: finalValue,
            axisLineStyle: const AxisLineStyle(
                // cornerStyle: CornerStyle.startCurve,
                thickness: 5),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 90,
                  positionFactor: 0,
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('$value %',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025)),
                    ],
                  )),
              GaugeAnnotation(
                  angle: 121,
                  positionFactor: 1.1,
                  widget: Container(
                    child: Text('$intialValue', style: TextStyle(fontSize: 14)),
                  )),
              GaugeAnnotation(
                  angle: 54,
                  positionFactor: 1.1,
                  widget: Container(
                    child: Text('$finalValue', style: TextStyle(fontSize: 14)),
                  )),
            ],
            pointers: <GaugePointer>[
              RangePointer(
                value: value,
                width: 16,
                pointerOffset: -6,
                enableAnimation: true,
                color: barColor,
                // color: Color(0xFFF67280),

                // gradient: SweepGradient(
                //     colors: <Color>[Color(0xFFFF7676), Color(0xFFF54EA2)],
                //     stops: <double>[0.25, 0.75]),
              ),
              // MarkerPointer(
              //   value:  _markerValue,
              //   color: Colors.white,
              //   markerType: MarkerType.circle,
              // ),
            ]),
      ],
    );
  }

  double _markerValue = 138;
}
