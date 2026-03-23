import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budget_bytes/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    // 1. Create the initial base theme
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: AppColors.background,
    );

    // 2. Return the base with ALL overrides using .copyWith
    return base.copyWith(
      // Typography: Apply Google Fonts to the base text theme
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.body,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.buttonLabel,
        labelMedium: AppTypography.caption,
        labelSmall: AppTypography.overline,
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.appBarTitle,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(color: AppColors.white, size: 26),
        actionsIconTheme: const IconThemeData(color: AppColors.white, size: 26),
      ),

      // Bottom nav
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        clipBehavior: Clip.antiAlias,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.textTertiary.withOpacity(0.3),
          disabledForegroundColor: AppColors.textTertiary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(double.infinity, AppSizing.buttonHeight),
          textStyle: AppTypography.buttonLabel,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(double.infinity, AppSizing.buttonHeight),
          textStyle: AppTypography.buttonLabel,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.buttonLabel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTypography.inputHint,
        labelStyle: AppTypography.inputLabel,
        errorStyle: AppTypography.inputError,
        prefixIconColor: AppColors.textTertiary,
        suffixIconColor: AppColors.textTertiary,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.surfaceVariant,
        labelStyle: AppTypography.chipLabel,
        secondaryLabelStyle: AppTypography.chipLabel.copyWith(
          color: AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        side: BorderSide.none,
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.bottomSheet),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        showDragHandle: true,
        dragHandleColor: AppColors.border,
        dragHandleSize: Size(40, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dialog),
        ),
        titleTextStyle: AppTypography.dialogTitle,
        contentTextStyle: AppTypography.body,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.dark,
        contentTextStyle: AppTypography.body.copyWith(color: AppColors.white),
        actionTextColor: AppColors.gold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.snackBar),
        ),
        elevation: 4,
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.fab),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        titleTextStyle: AppTypography.listTitle,
        subtitleTextStyle: AppTypography.caption,
        leadingAndTrailingTextStyle: AppTypography.caption,
        iconColor: AppColors.textSecondary,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.white;
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.border;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.border,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.12),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: AppTypography.caption.copyWith(
          color: AppColors.white,
        ),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.border,
        circularTrackColor: AppColors.border,
        linearMinHeight: AppSizing.progressBarHeight,
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColors.border,
        labelStyle: AppTypography.tabLabel,
        unselectedLabelStyle: AppTypography.tabLabel,
        overlayColor: WidgetStateProperty.all(
          AppColors.primary.withOpacity(0.06),
        ),
      ),
    );
  }

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryFaint,
    onPrimaryContainer: AppColors.dark,
    secondary: AppColors.gold,
    onSecondary: AppColors.dark,
    secondaryContainer: AppColors.goldLight,
    onSecondaryContainer: AppColors.dark,
    tertiary: AppColors.error,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.errorLight,
    onTertiaryContainer: AppColors.dark,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.dark,
    surface: AppColors.white,
    onSurface: AppColors.dark,
    outline: AppColors.border,
    outlineVariant: Color(0xFFE0E0E0),
    shadow: Colors.black,
    scrim: Colors.black54,
    inverseSurface: AppColors.dark,
    onInverseSurface: AppColors.white,
    inversePrimary: AppColors.primaryLight,
  );
}
