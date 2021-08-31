
import 'package:barcode_app/utils/plugins.dart';

class APPUTILS {

  static mySnackBar({title,msg})
  {
    return Get.snackbar("${title?? "Please!"}", "${msg?? "Fill all required fields to continue"}",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppTheme.PRIMARY_COLOR_BLUE_OPS ,
        colorText: Colors.white,);
  }
  static double getFontSizeByHeight(BuildContext context,val)
  {
    return MediaQuery.of(context).size.height * val;
  }
  static double getFontSizeByWidth(BuildContext context,val)
  {
    return MediaQuery.of(context).size.width * val;
  }
}



class MyLoader extends StatelessWidget {
  MyLoader(
      {Key? key,
        this.opacity: 0.9,
        this.dismissibles: false,
        this.color: Colors.black,
        this.loadingTxt: 'Loading...'})
      : super(key: key);

  final double opacity;
  final bool dismissibles;
  final Color color;
  final String loadingTxt;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: const ModalBarrier(dismissible: false, color: Colors.white),
        ),
        Center(
          child: loadingbar(color: color, size: 70),
        ),
      ],
    );
  }

}

Widget loadingbar(
    {Color color = Colors.white,
      double? size,
      Color bgColor = Colors.transparent}) {
  return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        backgroundColor: bgColor,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ));
}

 BoxDecoration getCardDecoration = BoxDecoration(
   color: AppTheme.WHITE,
   borderRadius: BorderRadius.only(
       topLeft: Radius.circular(8.0),
       bottomLeft: Radius.circular(8.0),
       bottomRight: Radius.circular(8.0),
       topRight: Radius.circular(68.0)),
   boxShadow: <BoxShadow>[
     BoxShadow(
         color: AppTheme.GREY.withOpacity(0.2),
         offset: Offset(1.1, 1.1),
         blurRadius: 10.0),
   ],
 );

BoxDecoration getCardDecorationWithLessRound = BoxDecoration(
color: AppTheme.WHITE,
borderRadius: BorderRadius.only(
topLeft: Radius.circular(8.0),
bottomLeft: Radius.circular(8.0),
bottomRight: Radius.circular(8.0),
topRight: Radius.circular(8.0)),
boxShadow: <BoxShadow>[
BoxShadow(
color: AppTheme.GREY.withOpacity(0.2),
offset: Offset(1.1, 1.1),
blurRadius: 10.0),
],
);

class ErrorView extends StatelessWidget {
   ErrorView({
    Key? key,
    required this.res,
   required this.onTap
  }) : super(key: key);

  final ApiResponse res;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Spacer(),
          Expanded(
            child: Container(
              child: Text(
                '${res.msg}',
                style: TextStyle(
                  color: AppTheme.lightText,
                  fontFamily: 'Times',
                  fontSize: APPUTILS.getFontSizeByHeight(context, .03),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              child: Text(
                'Try Again',
                style: TextStyle(
                  color: AppTheme.COLOR_REDISH,
                  fontFamily: 'Times',
                  fontSize: APPUTILS.getFontSizeByHeight(context, .03),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
