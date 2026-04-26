import 'package:awesome_dialog/awesome_dialog.dart';
 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mizansir/core/utils/common_response.dart';
import 'package:mizansir/core/utils/qalert_dialog.dart' show qAlertDialog;
import 'package:mizansir/core/utils/testing.dart' show amirPrint;
import 'package:nb_utils/nb_utils.dart' as QContext;

 

class CommonToJson {
  Future<bool> getJson(var res) {
    dynamic commonResponseModel = CommonResponseModel.fromJson(res);

    if (!commonResponseModel.success!) {
      if (commonResponseModel.message == null) {
        qAlertDialog('Something Went Wrong , Please try again');
      } else {
        qAlertDialog(commonResponseModel.message);
      }
      return Future.value(false);
    } else {
      if (commonResponseModel.message == null) {
        qAlertDialog("Something went wrong, please try again");
      } else {
        AwesomeDialog(
          
          context: QContext.navigatorKey.currentState!.context,
          dialogType: DialogType.noHeader,
          dismissOnTouchOutside: false,
          animType: AnimType.bottomSlide,
          title: 'Success',
          desc: commonResponseModel.message,
          titleTextStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          descTextStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          dialogBorderRadius: BorderRadius.circular(0),
          buttonsBorderRadius: BorderRadius.circular(0),
          btnOkColor: Colors.black,
          btnOkOnPress: () {
            Navigator.of(QContext.navigatorKey.currentState!.context)
                .pushNamedAndRemoveUntil(
              "/",
              (Route<dynamic> route) => false,
            );
          },
        ).show();
      }

      return Future.value(true);
    }
  }

  dynamic getString(var res,
      {isSuccessMsg = false,
      isErrorMsg = true,
      isUnexpectedMsg = true,
      isReturnTrue = false,
      isList = false}) {
    if (kDebugMode) {
      amirPrint('${res.runtimeType} : $res');
    }

    dynamic commonResponseModel = CommonResponseModel.fromJson(res);

    if (kDebugMode) {
      amirPrint(commonResponseModel.toJson());
    }

    if (!commonResponseModel.success!) {
      if (commonResponseModel.message == null) {
        qAlertDialog('Something Went Wrong , Please try again');
      } else if (isErrorMsg) {
        //  showToast(commonResponseModel.decentMessage,"Sorry");
        if (commonResponseModel.message!.isNotEmpty) {
          qAlertDialog(commonResponseModel.message);
        }
      } else if (commonResponseModel.data == null) {
        qAlertDialog(commonResponseModel.message);
      }
      // return false;
    } else {
      if (isSuccessMsg) {
        if (commonResponseModel.message == null) {
          qAlertDialog("Something went wrong, please try again");
        } else {
          qAlertDialog(commonResponseModel.message);
        }
      }
      if (commonResponseModel.data == null && isUnexpectedMsg) {
        qAlertDialog(commonResponseModel.message);
      }
    }

    String finalStringdata = "";

    if (kDebugMode) {
      amirPrint("=-=-=-=-=-=-=- C o n t e n t -=-=-=-=-=-=");
    }

    try {
      if (commonResponseModel.data != null) {
        finalStringdata =
            // json.decode(commonResponseModel.data);
            commonResponseModel.data.toString();
      }
      if (kDebugMode) {
        amirPrint(finalStringdata);
      }
    } catch (e) {
      if (kDebugMode) {
        amirPrint(e);
      }
    }

    return finalStringdata;
  }
}
