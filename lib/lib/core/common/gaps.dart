import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dimens.dart';

class Gaps {
  static Widget hGap4 = SizedBox(width: ScreenUtil().setWidth(Dimens.dp4));
  static Widget hGap5 =  SizedBox(width: ScreenUtil().setWidth(Dimens.dp5));
  static Widget hGap8 =  SizedBox(width: ScreenUtil().setWidth(Dimens.dp8));
  static Widget hGap10 = SizedBox(width: ScreenUtil().setWidth(Dimens.dp10));
  static Widget hGap12 = SizedBox(width: ScreenUtil().setWidth(Dimens.dp12));
  static Widget hGap15 = SizedBox(width: ScreenUtil().setWidth(Dimens.dp15));
  static Widget hGap16 = SizedBox(width: ScreenUtil().setWidth(Dimens.dp16));
  static Widget hGap32 = SizedBox(width: ScreenUtil().setWidth(Dimens.dp32));

  static Widget vGap4 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp4));
  static Widget vGap5 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp5));
  static Widget vGap8 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp8));
  static Widget vGap10 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp10));
  static Widget vGap12 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp12));
  static Widget vGap15 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp15));
  static Widget vGap16 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp16));
  static Widget vGap24 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp24));
  static Widget vGap32 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp32));
  static Widget vGap50 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp50));
  static Widget vGap64 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp64));
  static Widget vGap128 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp128));
  static Widget vGap256 = SizedBox(height: ScreenUtil().setWidth(Dimens.dp256));


  static const Widget line = const Divider();

  static const Widget vLine = SizedBox(
    width: 0.6,
    height: 24.0,
    child: const VerticalDivider(),
  );

  static const Widget empty = const SizedBox.shrink();
}