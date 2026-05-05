// File: lib/core/utils/qalert_dialog.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'q_context.dart';

/// Modern alert dialog with Material Design 3 theming.
///
/// Features:
/// - Blur backdrop effect
/// - Consistent theming with app colors
/// - Flexible action buttons (cancel, confirm, custom)
/// - Customizable text styling
/// - Barrier dismissible control
qAlertDialog(
  String message, {
  String? title,
  String? cancelText,
  String? confirmText,
  String? customText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  VoidCallback? customPress,
  Color? confirmColor,
  Color? customColor,
  TextAlign? textAlign,
  bool isCancelable = true,
  IconData? icon,
  Color? iconColor,
}) {
  final context = QContext.navigatorKey.currentState!.context;

  return showDialog(
    context: context,
    barrierDismissible: isCancelable,
    builder: (context) => _QAlertDialog(
      title: title,
      message: message,
      cancelText: cancelText,
      confirmText: confirmText,
      customText: customText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      customPress: customPress,
      confirmColor: confirmColor,
      customColor: customColor,
      textAlign: textAlign,
      icon: icon,
      iconColor: iconColor,
    ),
  );
}

class _QAlertDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String? cancelText;
  final String? confirmText;
  final String? customText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final VoidCallback? customPress;
  final Color? confirmColor;
  final Color? customColor;
  final TextAlign? textAlign;
  final IconData? icon;
  final Color? iconColor;

  const _QAlertDialog({
    this.title,
    required this.message,
    this.cancelText,
    this.confirmText,
    this.customText,
    this.onConfirm,
    this.onCancel,
    this.customPress,
    this.confirmColor,
    this.customColor,
    this.textAlign,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasActions = (onCancel != null && cancelText != null) ||
        (onConfirm != null && confirmText != null) ||
        (customPress != null && customText != null);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Section
                if (icon != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Title
                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text(
                      title!,
                      style: AppTextStyles.h4,
                      textAlign: textAlign ?? TextAlign.center,
                    ),
                  ),
                ],

                // Message
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    title != null ? 8 : 24,
                    24,
                    hasActions ? 16 : 24,
                  ),
                  child: Text(
                    message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: textAlign ?? TextAlign.center,
                  ),
                ),

                // Actions
                if (hasActions) ...[
                  const Divider(height: 1, color: AppColors.border),
                  _buildActions(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    final actions = <Widget>[];

    // Cancel button
    if (onCancel != null && cancelText != null) {
      actions.add(
        _DialogButton(
          text: cancelText!,
          onPressed: onCancel,
          isPrimary: false,
        ),
      );
    }

    // Custom button
    if (customPress != null && customText != null) {
      actions.add(
        _DialogButton(
          text: customText!,
          onPressed: customPress,
          isPrimary: false,
          customColor: customColor,
        ),
      );
    }

    // Confirm button
    if (onConfirm != null && confirmText != null) {
      actions.add(
        _DialogButton(
          text: confirmText!,
          onPressed: onConfirm,
          isPrimary: true,
          customColor: confirmColor,
        ),
      );
    }

    // Add vertical divider between buttons
    final children = <Widget>[];
    for (int i = 0; i < actions.length; i++) {
      children.add(actions[i]);
      if (i < actions.length - 1) {
        children.add(
          Container(
            width: 1,
            height: 48,
            color: AppColors.border,
          ),
        );
      }
    }

    return IntrinsicHeight(
      child: Row(children: children),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final Color? customColor;

  const _DialogButton({
    required this.text,
    this.onPressed,
    required this.isPrimary,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = isPrimary
        ? (customColor ?? AppColors.primary)
        : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onPressed?.call();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            text,
            style: AppTextStyles.buttonMedium.copyWith(
              color: buttonColor,
              fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
