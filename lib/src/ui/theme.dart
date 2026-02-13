import 'package:flutter/material.dart';

class DioSpyColors {
  DioSpyColors._();

  // Background
  static const Color background = Color(0xFFF2F3F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE6E7E9);
  static const Color primary = Color(0xFF011222);

  // Text
  static const Color textPrimary = Color(0xFF011222);
  static const Color textSecondary = Color(0xFF67717A);
  static const Color textTertiary = Color(0xFF9A9FA5);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status codes
  static const Color success = Color(0xFF027F31);
  static const Color info = Color(0xFF094BF4);
  static const Color warning = Color(0xFFFF8718);
  static const Color error = Color(0xFFE52E22);

  // Method chip colors
  static const Color getText = Color(0xFF027F31);
  static const Color postText = Color(0xFFAC7A04);
  static const Color putText = Color(0xFF0A58BA);
  static const Color deleteText = Color(0xFF973027);
  static const Color patchText = Color(0xFF7C45BE);

  static Color methodColors(String method) {
    return switch (method.toUpperCase()) {
      'GET' => getText,
      'POST' => postText,
      'PUT' => putText,
      'DELETE' => deleteText,
      'PATCH' => patchText,
      _ => getText,
    };
  }

  static Color statusColor(int? statusCode) {
    if (statusCode == null || statusCode < 0) return error;
    if (statusCode < 300) return success;
    if (statusCode < 400) return info;
    if (statusCode < 500) return warning;
    return error;
  }
}

class DioSpyTypo {
  static final t8 = const TextStyle(fontSize: 8).w400.primary;
  static final t10 = const TextStyle(fontSize: 10).w400.primary;
  static final t12 = const TextStyle(fontSize: 12).w400.primary;
  static final t14 = const TextStyle(fontSize: 14).w400.primary;
  static final t16 = const TextStyle(fontSize: 16).w400.primary;
  static final t18 = const TextStyle(fontSize: 18).w400.primary;
}

extension DioSpyTypoExt on TextStyle {
  // Font weights
  TextStyle get w300 => withFontWeight(FontWeight.w300); // light
  TextStyle get w400 => withFontWeight(FontWeight.w400); // regular
  TextStyle get w500 => withFontWeight(FontWeight.w500); // medium
  TextStyle get w600 => withFontWeight(FontWeight.w600); // semi-bold
  TextStyle get w700 => withFontWeight(FontWeight.w700); // bold
  TextStyle get w800 => withFontWeight(FontWeight.w800); // extra-bold
  TextStyle get w900 => withFontWeight(FontWeight.w900); // black

  TextStyle withFontWeight(FontWeight fontWeight) => copyWith(fontWeight: fontWeight);

  // Colors
  TextStyle get primary => withColor(DioSpyColors.textPrimary);
  TextStyle get secondary => withColor(DioSpyColors.textSecondary);
  TextStyle get tertiary => withColor(DioSpyColors.textTertiary);

  TextStyle withColor(Color color) => copyWith(color: color);

  TextStyle withFontFamily(String? fontFamily) => copyWith(fontFamily: fontFamily);
}

class DioSpyTheme {
  DioSpyTheme._();

  static ThemeData themeData(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fontFamily = textTheme.bodyLarge?.fontFamily;
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: DioSpyColors.background,
      appBarTheme: AppBarTheme(
        titleTextStyle: DioSpyTypo.t18.w600.withFontFamily(fontFamily),
        backgroundColor: DioSpyColors.surface,
        foregroundColor: DioSpyColors.textPrimary,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: DioSpyColors.textPrimary, size: 24),
      ),
      colorScheme: ColorScheme.light(surfaceTint: Colors.transparent),
      textTheme: textTheme,
      tabBarTheme: TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: DioSpyColors.divider,
        labelStyle: DioSpyTypo.t16.w600.withFontFamily(fontFamily),
        unselectedLabelStyle: DioSpyTypo.t16.w500.withFontFamily(fontFamily),
        labelColor: DioSpyColors.textPrimary,
        unselectedLabelColor: DioSpyColors.textTertiary,
        indicatorColor: DioSpyColors.textPrimary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: DioSpyTypo.t16.withFontFamily(fontFamily),
          foregroundColor: DioSpyColors.textPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(color: DioSpyColors.divider),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: DioSpyColors.primary),
    );
  }
}
