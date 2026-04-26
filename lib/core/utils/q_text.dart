 
import 'package:flutter/material.dart';
import 'package:mizansir/core/utils/app_color.dart' show AppColors;
 

enum TextType {
  // Button styles
  button16Center, // 16px, w600, center

  // Heading styles
  heading24, // 24px, w400, line-height 100%, letter-spacing -2%
  heading20Center, // 20px, w600, center
  heading24CenterBold, // 24px, w700, center, line-height 100%, letter-spacing -2%

  // Body styles
  body14, // 14px, w400, line-height 100%, letter-spacing -2%

  // Legacy styles (for backward compatibility)
  title,
  subtitle,
  heading1,
  heading2,
  heading3,
  heading4,
  heading5,
  heading6,
  body1,
  body2,
  body3,
  body4,
  body5,
  body6,
  body7,
  body8,
  normal,
  menutitle,
  menuSubtitle,
  caption,
  button,
}

// Language-based font family manager
class FontFamilyManager {
  static const String _urbanist = 'Urbanist';
  static const String _hindSiliguri = 'Hind Siliguri';

  static String getFontFamily({String? language, BuildContext? context}) {
    // Priority 1: Explicit language parameter
    if (language != null) {
      return language == 'bn' ? _hindSiliguri : _urbanist;
    }

    // Priority 2: Context-based locale detection
    if (context != null) {
      final locale = Localizations.localeOf(context);
      return locale.languageCode == 'bn' ? _hindSiliguri : _urbanist;
    }

    // Priority 3: Default to English font
    return _urbanist;
  }

  // Helper method to detect if text contains Bengali characters
  static bool containsBengaliText(String text) {
    // Bengali Unicode range: U+0980 to U+09FF
    return text.runes.any((rune) => rune >= 0x0980 && rune <= 0x09FF);
  }

  static String getFontFamilyByText(String text) {
    return containsBengaliText(text) ? _hindSiliguri : _urbanist;
  }
}

// Text style configuration class
class TextStyleConfig {
  final double fontSize;
  final FontWeight fontWeight;
  final double? lineHeight;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final Color? defaultColor;

  const TextStyleConfig({
    required this.fontSize,
    required this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
    this.textAlign,
    this.defaultColor,
  });

  TextStyle toTextStyle({
    required String fontFamily,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: lineHeight != null ? lineHeight! / fontSize : null,
      letterSpacing: letterSpacing,
      color: color ?? defaultColor ?? Colors.black,
    );
  }
}

// Centralized text style configurations (font-family agnostic)
class TextStylesCustom {
  static final Map<TextType, TextStyleConfig> _configs = {
    // New standardized styles based on your specifications
    TextType.button16Center: const TextStyleConfig(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      lineHeight: 20,
      letterSpacing: 0,
      textAlign: TextAlign.center,
    ),

    TextType.heading24: const TextStyleConfig(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      lineHeight: 24, // 100% line height
      letterSpacing: -0.48, // -2% of 24px
    ),

    TextType.heading20Center: const TextStyleConfig(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      lineHeight: 26,
      letterSpacing: 0,
      textAlign: TextAlign.center,
    ),

    TextType.heading24CenterBold: const TextStyleConfig(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      lineHeight: 24, // 100% line height
      letterSpacing: -0.48, // -2% of 24px
      textAlign: TextAlign.center,
    ),

    TextType.body14: const TextStyleConfig(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      lineHeight: 14, // 100% line height
      letterSpacing: -0.28, // -2% of 14px
    ),

    // Legacy styles (for backward compatibility)
    TextType.title: const TextStyleConfig(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      defaultColor: Colors.black,
    ),

    TextType.subtitle: const TextStyleConfig(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      defaultColor: Colors.black54,
    ),

    TextType.heading1: const TextStyleConfig(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      defaultColor: AppColors.heading3,
    ),

    TextType.heading2: const TextStyleConfig(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      defaultColor: AppColors.heading3,
    ),

    TextType.heading3: const TextStyleConfig(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      defaultColor: AppColors.heading3,
    ),

    TextType.heading4: const TextStyleConfig(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      defaultColor: Colors.black54,
    ),

    TextType.heading5: TextStyleConfig(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      defaultColor: AppColors.secondary01,
    ),

    TextType.heading6: TextStyleConfig(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      defaultColor: AppColors.secondary01,
    ),

    TextType.body1: const TextStyleConfig(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      defaultColor: Colors.black54,
    ),

    TextType.body2: TextStyleConfig(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      defaultColor: AppColors.secondary01,
    ),

    TextType.body3: const TextStyleConfig(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      defaultColor: Colors.black54,
    ),

    TextType.body4: const TextStyleConfig(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      defaultColor: Colors.black54,
    ),

    TextType.body5: const TextStyleConfig(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      defaultColor: Colors.black54,
    ),

    TextType.body6: const TextStyleConfig(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      defaultColor: Colors.black54,
    ),

    TextType.body7: const TextStyleConfig(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      defaultColor: Colors.black54,
    ),

    TextType.body8: const TextStyleConfig(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      defaultColor: Colors.black54,
    ),

    TextType.normal: const TextStyleConfig(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      defaultColor: Colors.black45,
    ),

    TextType.menutitle: TextStyleConfig(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      defaultColor: AppColors.secondary01,
    ),

    TextType.menuSubtitle: TextStyleConfig(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      defaultColor: AppColors.secondary01,
    ),

    TextType.caption: const TextStyleConfig(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      defaultColor: Colors.black54,
    ),

    TextType.button: const TextStyleConfig(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      defaultColor: Colors.white,
    ),
  };

  static TextStyleConfig? getConfig(TextType type) {
    return _configs[type];
  }
}

const Color TEXT_COLOR_BLACK = AppColors.blackColor;
const double DEFAULT_FONT_SIZE = 16.0;

class QText extends StatelessWidget {
  final String text;
  final Color? color;
  final bool softWrap;
  final double? fontSize;
  final TextAlign? textAlign;
  final int maxline;
  final FontWeight? fontWeight;
  final FontStyle fontStyle;
  final TextOverflow textOverflow;
  final TextDecoration textDecoration;
  final TextType? type;
  final TextStyle? style; // NEW: Direct TextStyle support
  final bool? isCapitalize;
  final bool? isOptional;
  final double? lineHeight;
  final double? letterSpacing;
  final String? language; // 'en' or 'bn'
  final bool autoDetectLanguage; // Auto detect based on text content

  const QText({
    super.key,
    required this.text,
    this.textAlign,
    this.maxline = 100,
    this.textDecoration = TextDecoration.none,
    this.softWrap = true,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle = FontStyle.normal,
    this.type,
    this.style, // NEW: Direct TextStyle parameter
    this.isCapitalize = false,
    this.isOptional = false,
    this.textOverflow = TextOverflow.visible,
    this.lineHeight,
    this.letterSpacing,
    this.language,
    this.autoDetectLanguage = true,
  }) : assert(
          (type == null && style == null) ||
              (type != null && style == null) ||
              (type == null && style != null),
          'Cannot provide both type and style. Use either type or style, not both.',
        );

  @override
  Widget build(BuildContext context) {
    // Determine font family based on language
    String fontFamily;

    if (language != null) {
      // Explicit language provided
      fontFamily = FontFamilyManager.getFontFamily(language: language);
    } else if (autoDetectLanguage) {
      // Auto-detect based on text content
      fontFamily = FontFamilyManager.getFontFamilyByText(text);
    } else {
      // Use context-based locale
      fontFamily = FontFamilyManager.getFontFamily(context: context);
    }

    TextStyle textStyle;
    TextAlign? finalTextAlign = textAlign;

    if (style != null) {
      // Direct TextStyle provided - override font family and apply textDecoration
      textStyle = style!.copyWith(
        fontFamily: fontFamily,
        color: color ?? style!.color,
        decoration: textDecoration, // FIX: Apply textDecoration parameter
        fontSize: fontSize ?? style!.fontSize, // Allow fontSize override
        fontWeight:
            fontWeight ?? style!.fontWeight, // Allow fontWeight override
        height: lineHeight != null
            ? lineHeight! / (fontSize ?? style!.fontSize ?? DEFAULT_FONT_SIZE)
            : style!.height, // Apply lineHeight if provided
        letterSpacing: letterSpacing ??
            style!.letterSpacing, // Apply letterSpacing if provided
      );
      finalTextAlign = textAlign ?? TextAlign.start;
    } else if (type != null) {
      // Existing TextType enum approach
      final config = TextStylesCustom.getConfig(type!);
      if (config != null) {
        textStyle = config
            .toTextStyle(
              fontFamily: fontFamily,
              color: color,
            )
            .copyWith(
              decoration: textDecoration, // FIX: Apply textDecoration parameter
              fontSize: fontSize ?? config.fontSize, // Allow fontSize override
              fontWeight:
                  fontWeight ?? config.fontWeight, // Allow fontWeight override
              height: lineHeight != null
                  ? lineHeight! / (fontSize ?? config.fontSize)
                  : config.lineHeight != null
                      ? config.lineHeight! / config.fontSize
                      : null,
              letterSpacing: letterSpacing ??
                  config.letterSpacing, // Allow letterSpacing override
            );
        finalTextAlign = textAlign ?? config.textAlign;
      } else {
        // Fallback for unknown types
        textStyle = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? DEFAULT_FONT_SIZE,
          color: color ?? TEXT_COLOR_BLACK,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontStyle: fontStyle,
          decoration: textDecoration,
          height: lineHeight != null
              ? lineHeight! / (fontSize ?? DEFAULT_FONT_SIZE)
              : null,
          letterSpacing: letterSpacing,
        );
      }
    } else {
      // When no type or style is specified, use custom properties
      textStyle = TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize ?? DEFAULT_FONT_SIZE,
        color: color ?? TEXT_COLOR_BLACK,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontStyle: fontStyle,
        decoration: textDecoration,
        height: lineHeight != null
            ? lineHeight! / (fontSize ?? DEFAULT_FONT_SIZE)
            : null,
        letterSpacing: letterSpacing,
      );
      finalTextAlign = textAlign ?? TextAlign.start;
    }

    return Text(
      isCapitalize!
          ? text.capitalize()
          : isOptional!
              ? "$text*"
              : text,
      maxLines: maxline,
      softWrap: softWrap,
      overflow: textOverflow,
      textAlign: finalTextAlign,
      style: textStyle,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty
        ? "${this[0].toUpperCase()}${substring(1).toLowerCase()}"
        : "";
  }
}
