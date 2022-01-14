import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/app_colors.dart';
import '../common/dimens.dart';
import '../errors/base_error.dart';
import '../errors/connection_error.dart';
import '../errors/custom_error.dart';
import '../errors/internal_server_error.dart';
import '../localization/translations.dart';
import '../model/error_message_model.dart';
import '../constants.dart';
import '../errors/bad_request_error.dart';
import '../errors/conflict_error.dart';
import '../errors/forbidden_error.dart';
import '../errors/not_found_error.dart';
import '../errors/timeout_error.dart';
import '../errors/unauthorized_error.dart';
import '../errors/unknown_error.dart';
import 'show_dialog.dart';

class ShowError {
  static void showErrorSnakBar(BuildContext context,BaseError error,dynamic state){
    if (error is ErrorMessageModel){
      ShowError.showCustomError(context, error.message!);
    }
    else if(error.runtimeType is ConnectionError || error is ConnectionError) {
      ShowError.showConnectionError(context, state.callback);
    } else if (error is CustomError) {
      ShowError.showCustomError(context, error.message!);
    } else if (error is UnauthorizedError) {
      ShowError.showUnauthorizedError(context);
    }
    else if (error is BadRequestError) {
      ShowError.showBadRequestError(context);
    }
    else if (error is ForbiddenError) {
      ShowError.showForbiddenError(context);
    }
    else if (error is NotFoundError) {
      ShowError.showNotFoundError(context);
    }
    else if (error is ConflictError) {
      ShowError.showConflictError(context);
    }
    else if (error is TimeoutError) {
      ShowError.showTimeoutError(context);
    }
    else if (error is UnknownError) {
      ShowError.showUnknownError(context);
    }

    else if (error is InternalServerError)  {
      ShowError.showInternalServerError(context);
    }
    else {
      ShowError.showUnexpectedError(context);
    }
  }
  static void showConnectionError(BuildContext context, VoidCallback callback) {
    ShowDialog().showElasticDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: ()=>Future.value(false),
            child: Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(ScreenUtil().setWidth(60))),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width*0.75,
                          MediaQuery.of(context).size.height * 0.15
                      )),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.28,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Translations.of(context)!.translate("error_connection_lost"),
                          style: TextStyle(
                              color: Colors.white, fontSize: ScreenUtil().setSp(Dimens.font_sp38)),
                        ),
                        Text(
                          Translations.of(context)!.translate("error_oops"),
                          style: TextStyle(
                              color: AppColors.blueFontColor,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(Dimens.font_sp38)),
                        ),
                        CircleAvatar(
                          maxRadius: ScreenUtil().setWidth(50),
                          child: Icon(Icons.signal_wifi_off,color: Colors.white,size: ScreenUtil().setWidth(40),),
                          backgroundColor: Colors.red,
                        ),
                        Text(
                          Translations.of(context)!.translate("error_sorry"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(Dimens.font_sp32)),
                        ),
                        Text(
                          Translations.of(context)!.translate("error_appears_that_connection_lost"),
                          style: TextStyle(
                              color: AppColors.accentColor,
                              fontSize: ScreenUtil().setSp(Dimens.font_sp32),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showCustomError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void showUnexpectedError(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(Translations.of(context)!.translate('error_general'),),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void showUnauthorizedError(BuildContext context) {
    ShowDialog().showElasticDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: ()=>Future.value(false),
          child: Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(ScreenUtil().setWidth(60))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ERROR_403_401,
                    scale: 2.5,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(Dimens.dp24)),
                    child: Text(
                      Translations.of(context)!.translate('error_Unauthorized_Error'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(Dimens.font_sp38),
                          fontWeight: FontWeight.bold,
                          color: AppColors.disabledColor
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // TODO do something
                        },
                        child: Text(Translations.of(context)!.translate("Login")),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppColors.primaryColor
                          ),
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                                fontSize: ScreenUtil().setSp(
                                    Dimens.font_sp24
                                ),
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showBadRequestError(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(Translations.of(context)!.translate('error_BadRequest_Error')),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void showForbiddenError(BuildContext context) {
    ShowDialog().showElasticDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: ()=>Future.value(false),
          child: Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(ScreenUtil().setWidth(60))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ERROR_403_401,
                    scale: 2.5,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(Dimens.dp24)),
                    child: Text(
                      Translations.of(context)!.translate('error_forbidden_error'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(Dimens.font_sp38),
                          fontWeight: FontWeight.bold,
                          color: AppColors.disabledColor
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // TODO do something
                        },
                        child: Text(Translations.of(context)!.translate("Login")),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppColors.primaryColor
                          ),
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                                fontSize: ScreenUtil().setSp(
                                    Dimens.font_sp24
                                ),
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showInternalServerError(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(Translations.of(context)!.translate('error_internal_server')),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void showNotFoundError(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(Translations.of(context)!.translate('error_NotFound_Error')),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void showConflictError(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(Translations.of(context)!.translate('error_general')),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void showTimeoutError(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(Translations.of(context)!.translate('error_Timeout_Error')),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void showUnknownError(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(Translations.of(context)!.translate('error_general')),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}