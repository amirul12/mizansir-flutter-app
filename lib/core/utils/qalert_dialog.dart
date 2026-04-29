import 'dart:ui';

 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mizansir/core/utils/q_context.dart';
import 'package:mizansir/core/utils/q_text.dart' show QText, TextType;
 

qAlertDialog(message,
    {cancelText,
    confirmText,
    title,
    customText,
    customPress,
    constomColor,
    Function? onconfirm,
    Function? onCancel,
    textAlign,
    isCancelable = true,
    confirmColor}) {
  return showDialog(
      context: QContext.navigatorKey.currentState!.context,
      builder: (context) {
        return PopScope(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 3.0,
              sigmaY: 3.0,
            ),
            child: CupertinoAlertDialog(
              title: QText(
                text: title ?? "Alert",
                type: TextType.title,
              ),
              content: QText(
                text: message,
                type: TextType.normal,
                textAlign: textAlign ?? TextAlign.center,
              ),
              actions: [
                if (isCancelable)
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    isDestructiveAction: true,
                    textStyle: const TextStyle(fontSize: 20),
                    child: QText(
                      text: cancelText ?? "Ok",
                      color: Colors.red,
                      type: TextType.normal,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (onCancel != null) onCancel();
                    },
                  ),
                if (customPress != null && customText != null)
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    isDestructiveAction: true,
                    textStyle: const TextStyle(fontSize: 20),
                    child: QText(
                      text: customText,
                      color: constomColor ?? Colors.black38,
                      type: TextType.normal,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      customPress();
                    },
                  ),
                if (onconfirm != null)
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    isDestructiveAction: true,
                    textStyle: const TextStyle(fontSize: 20),
                    child: QText(
                      text: confirmText ?? "Ok",
                      color: confirmColor ?? Colors.green,
                      type: TextType.normal,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      onconfirm();
                    },
                  ),
              ],
            ),
          ),
        );
      });
}
