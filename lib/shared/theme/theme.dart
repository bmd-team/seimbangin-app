import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color darkPrimaryColor;
  final Color buttonColor;
  final Color statusBarPrimaryColor;
  final Color sliderOnboardingColor;
  final Color backgroundWhiteColor;
  final Color backgroundGreyColor;
  final Color backgroundGreySecondaryColor;
  final Color backgroundBlueColor;
  final Color backgroundWarningColor;
  final Color backgroundPinkColor;
  final Color backgroundGreenColor;
  final Color backgroundOldGreenColor;
  final Color backgroundOldWarningColor;
  final Color gradientBlueStartColor;
  final Color gradientBlueEndColor;
  final Color skyBlueColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color textWhiteColor;
  final Color textBlueColor;
  final Color textButtonColor;
  final Color textWarningColor;
  final Color textGreenColor;
  final Color buttonEducationColor;
  final Color buttonShoppingColor;
  final Color buttonInternetColor;
  final Color buttonTransportationColor;
  final Color buttonHousingColor;
  final Color buttonFoodColor;
  final Color buttonSalaryColor;
  final Color buttonFreelanceColor;
  final Color buttonParentColor;
  final Color buttonGiftColor;
  final Color buttonBonusColor;
  final Color buttonHealthColor;

  const AppColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.darkPrimaryColor,
    required this.buttonColor,
    required this.statusBarPrimaryColor,
    required this.sliderOnboardingColor,
    required this.backgroundWhiteColor,
    required this.backgroundGreyColor,
    required this.backgroundGreySecondaryColor,
    required this.backgroundBlueColor,
    required this.backgroundWarningColor,
    required this.backgroundPinkColor,
    required this.backgroundGreenColor,
    required this.backgroundOldGreenColor,
    required this.backgroundOldWarningColor,
    required this.gradientBlueStartColor,
    required this.gradientBlueEndColor,
    required this.skyBlueColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.textWhiteColor,
    required this.textBlueColor,
    required this.textButtonColor,
    required this.textWarningColor,
    required this.textGreenColor,
    required this.buttonEducationColor,
    required this.buttonShoppingColor,
    required this.buttonInternetColor,
    required this.buttonTransportationColor,
    required this.buttonHousingColor,
    required this.buttonFoodColor,
    required this.buttonSalaryColor,
    required this.buttonFreelanceColor,
    required this.buttonParentColor,
    required this.buttonGiftColor,
    required this.buttonBonusColor,
    required this.buttonHealthColor,
  });

  @override
  AppColors copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? darkPrimaryColor,
    Color? buttonColor,
    Color? statusBarPrimaryColor,
    Color? sliderOnboardingColor,
    Color? backgroundWhiteColor,
    Color? backgroundGreyColor,
    Color? backgroundGreySecondaryColor,
    Color? backgroundBlueColor,
    Color? backgroundWarningColor,
    Color? backgroundPinkColor,
    Color? backgroundGreenColor,
    Color? backgroundOldGreenColor,
    Color? backgroundOldWarningColor,
    Color? gradientBlueStartColor,
    Color? gradientBlueEndColor,
    Color? skyBlueColor,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? textWhiteColor,
    Color? textBlueColor,
    Color? textButtonColor,
    Color? textWarningColor,
    Color? textGreenColor,
    Color? buttonEducationColor,
    Color? buttonShoppingColor,
    Color? buttonInternetColor,
    Color? buttonTransportationColor,
    Color? buttonHousingColor,
    Color? buttonFoodColor,
    Color? buttonSalaryColor,
    Color? buttonFreelanceColor,
    Color? buttonParentColor,
    Color? buttonGiftColor,
    Color? buttonBonusColor,
    Color? buttonHealthColor,
  }) {
    return AppColors(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      darkPrimaryColor: darkPrimaryColor ?? this.darkPrimaryColor,
      buttonColor: buttonColor ?? this.buttonColor,
      statusBarPrimaryColor: statusBarPrimaryColor ?? this.statusBarPrimaryColor,
      sliderOnboardingColor: sliderOnboardingColor ?? this.sliderOnboardingColor,
      backgroundWhiteColor: backgroundWhiteColor ?? this.backgroundWhiteColor,
      backgroundGreyColor: backgroundGreyColor ?? this.backgroundGreyColor,
      backgroundGreySecondaryColor: backgroundGreySecondaryColor ?? this.backgroundGreySecondaryColor,
      backgroundBlueColor: backgroundBlueColor ?? this.backgroundBlueColor,
      backgroundWarningColor: backgroundWarningColor ?? this.backgroundWarningColor,
      backgroundPinkColor: backgroundPinkColor ?? this.backgroundPinkColor,
      backgroundGreenColor: backgroundGreenColor ?? this.backgroundGreenColor,
      backgroundOldGreenColor: backgroundOldGreenColor ?? this.backgroundOldGreenColor,
      backgroundOldWarningColor: backgroundOldWarningColor ?? this.backgroundOldWarningColor,
      gradientBlueStartColor: gradientBlueStartColor ?? this.gradientBlueStartColor,
      gradientBlueEndColor: gradientBlueEndColor ?? this.gradientBlueEndColor,
      skyBlueColor: skyBlueColor ?? this.skyBlueColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      textWhiteColor: textWhiteColor ?? this.textWhiteColor,
      textBlueColor: textBlueColor ?? this.textBlueColor,
      textButtonColor: textButtonColor ?? this.textButtonColor,
      textWarningColor: textWarningColor ?? this.textWarningColor,
      textGreenColor: textGreenColor ?? this.textGreenColor,
      buttonEducationColor: buttonEducationColor ?? this.buttonEducationColor,
      buttonShoppingColor: buttonShoppingColor ?? this.buttonShoppingColor,
      buttonInternetColor: buttonInternetColor ?? this.buttonInternetColor,
      buttonTransportationColor: buttonTransportationColor ?? this.buttonTransportationColor,
      buttonHousingColor: buttonHousingColor ?? this.buttonHousingColor,
      buttonFoodColor: buttonFoodColor ?? this.buttonFoodColor,
      buttonSalaryColor: buttonSalaryColor ?? this.buttonSalaryColor,
      buttonFreelanceColor: buttonFreelanceColor ?? this.buttonFreelanceColor,
      buttonParentColor: buttonParentColor ?? this.buttonParentColor,
      buttonGiftColor: buttonGiftColor ?? this.buttonGiftColor,
      buttonBonusColor: buttonBonusColor ?? this.buttonBonusColor,
      buttonHealthColor: buttonHealthColor ?? this.buttonHealthColor,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      darkPrimaryColor: Color.lerp(darkPrimaryColor, other.darkPrimaryColor, t)!,
      buttonColor: Color.lerp(buttonColor, other.buttonColor, t)!,
      statusBarPrimaryColor: Color.lerp(statusBarPrimaryColor, other.statusBarPrimaryColor, t)!,
      sliderOnboardingColor: Color.lerp(sliderOnboardingColor, other.sliderOnboardingColor, t)!,
      backgroundWhiteColor: Color.lerp(backgroundWhiteColor, other.backgroundWhiteColor, t)!,
      backgroundGreyColor: Color.lerp(backgroundGreyColor, other.backgroundGreyColor, t)!,
      backgroundGreySecondaryColor: Color.lerp(backgroundGreySecondaryColor, other.backgroundGreySecondaryColor, t)!,
      backgroundBlueColor: Color.lerp(backgroundBlueColor, other.backgroundBlueColor, t)!,
      backgroundWarningColor: Color.lerp(backgroundWarningColor, other.backgroundWarningColor, t)!,
      backgroundPinkColor: Color.lerp(backgroundPinkColor, other.backgroundPinkColor, t)!,
      backgroundGreenColor: Color.lerp(backgroundGreenColor, other.backgroundGreenColor, t)!,
      backgroundOldGreenColor: Color.lerp(backgroundOldGreenColor, other.backgroundOldGreenColor, t)!,
      backgroundOldWarningColor: Color.lerp(backgroundOldWarningColor, other.backgroundOldWarningColor, t)!,
      gradientBlueStartColor: Color.lerp(gradientBlueStartColor, other.gradientBlueStartColor, t)!,
      gradientBlueEndColor: Color.lerp(gradientBlueEndColor, other.gradientBlueEndColor, t)!,
      skyBlueColor: Color.lerp(skyBlueColor, other.skyBlueColor, t)!,
      textPrimaryColor: Color.lerp(textPrimaryColor, other.textPrimaryColor, t)!,
      textSecondaryColor: Color.lerp(textSecondaryColor, other.textSecondaryColor, t)!,
      textWhiteColor: Color.lerp(textWhiteColor, other.textWhiteColor, t)!,
      textBlueColor: Color.lerp(textBlueColor, other.textBlueColor, t)!,
      textButtonColor: Color.lerp(textButtonColor, other.textButtonColor, t)!,
      textWarningColor: Color.lerp(textWarningColor, other.textWarningColor, t)!,
      textGreenColor: Color.lerp(textGreenColor, other.textGreenColor, t)!,
      buttonEducationColor: Color.lerp(buttonEducationColor, other.buttonEducationColor, t)!,
      buttonShoppingColor: Color.lerp(buttonShoppingColor, other.buttonShoppingColor, t)!,
      buttonInternetColor: Color.lerp(buttonInternetColor, other.buttonInternetColor, t)!,
      buttonTransportationColor: Color.lerp(buttonTransportationColor, other.buttonTransportationColor, t)!,
      buttonHousingColor: Color.lerp(buttonHousingColor, other.buttonHousingColor, t)!,
      buttonFoodColor: Color.lerp(buttonFoodColor, other.buttonFoodColor, t)!,
      buttonSalaryColor: Color.lerp(buttonSalaryColor, other.buttonSalaryColor, t)!,
      buttonFreelanceColor: Color.lerp(buttonFreelanceColor, other.buttonFreelanceColor, t)!,
      buttonParentColor: Color.lerp(buttonParentColor, other.buttonParentColor, t)!,
      buttonGiftColor: Color.lerp(buttonGiftColor, other.buttonGiftColor, t)!,
      buttonBonusColor: Color.lerp(buttonBonusColor, other.buttonBonusColor, t)!,
      buttonHealthColor: Color.lerp(buttonHealthColor, other.buttonHealthColor, t)!,
    );
  }
}

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle blackTextStyle;
  final TextStyle blueTextStyle;
  final TextStyle whiteTextStyle;
  final TextStyle greyTextStyle;
  final TextStyle greenTextStyle;
  final TextStyle warningTextStyle;
  final TextStyle buttonTextStyle;

  const AppTextStyles({
    required this.blackTextStyle,
    required this.blueTextStyle,
    required this.whiteTextStyle,
    required this.greyTextStyle,
    required this.greenTextStyle,
    required this.warningTextStyle,
    required this.buttonTextStyle,
  });

  @override
  AppTextStyles copyWith({
    TextStyle? blackTextStyle,
    TextStyle? blueTextStyle,
    TextStyle? whiteTextStyle,
    TextStyle? greyTextStyle,
    TextStyle? greenTextStyle,
    TextStyle? warningTextStyle,
    TextStyle? buttonTextStyle,
  }) {
    return AppTextStyles(
      blackTextStyle: blackTextStyle ?? this.blackTextStyle,
      blueTextStyle: blueTextStyle ?? this.blueTextStyle,
      whiteTextStyle: whiteTextStyle ?? this.whiteTextStyle,
      greyTextStyle: greyTextStyle ?? this.greyTextStyle,
      greenTextStyle: greenTextStyle ?? this.greenTextStyle,
      warningTextStyle: warningTextStyle ?? this.warningTextStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
    );
  }

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      blackTextStyle: TextStyle.lerp(blackTextStyle, other.blackTextStyle, t)!,
      blueTextStyle: TextStyle.lerp(blueTextStyle, other.blueTextStyle, t)!,
      whiteTextStyle: TextStyle.lerp(whiteTextStyle, other.whiteTextStyle, t)!,
      greyTextStyle: TextStyle.lerp(greyTextStyle, other.greyTextStyle, t)!,
      greenTextStyle: TextStyle.lerp(greenTextStyle, other.greenTextStyle, t)!,
      warningTextStyle: TextStyle.lerp(warningTextStyle, other.warningTextStyle, t)!,
      buttonTextStyle: TextStyle.lerp(buttonTextStyle, other.buttonTextStyle, t)!,
    );
  }
}

const lightColors = AppColors(
  primaryColor: Color(0xFF1976D2),
  secondaryColor: Color.fromRGBO(0, 72, 255, 1),
  darkPrimaryColor: Color(0xFF001E6B),
  buttonColor: Color(0xFF2885FF),
  statusBarPrimaryColor: Colors.transparent,
  sliderOnboardingColor: Color(0xFF9AB7FF),
  backgroundWhiteColor: Color(0xFFFFFFFF),
  backgroundGreyColor: Color(0xFFECECEC),
  backgroundGreySecondaryColor: Color(0xFFF4F4F4),
  backgroundBlueColor: Color(0xFFCBE1FF),
  backgroundWarningColor: Color(0xFFEA1763),
  backgroundPinkColor: Color(0xFFFFCBDE),
  backgroundGreenColor: Color(0xFF20E828),
  backgroundOldGreenColor: Color(0xFF4CAF50),
  backgroundOldWarningColor: Color(0xFFEA1763),
  gradientBlueStartColor: Color(0xFF60A5FF),
  gradientBlueEndColor: Color(0xFFB1D3FF),
  skyBlueColor: Color(0xFFE0EDFF),
  textPrimaryColor: Color(0xFF000000),
  textSecondaryColor: Color(0xFF555555),
  textWhiteColor: Color(0xFFFFFFFF),
  textBlueColor: Color(0xFF2885FF),
  textButtonColor: Color(0xFF0048FF),
  textWarningColor: Color(0xFFEA1763),
  textGreenColor: Color(0xFF20E828),
  buttonEducationColor: Color(0xFF86D3FF),
  buttonShoppingColor: Color(0xFF2885FF),
  buttonInternetColor: Color(0xFF01DDB0),
  buttonTransportationColor: Color(0xFFA377FF),
  buttonHousingColor: Color(0xFFFFF694),
  buttonFoodColor: Color(0xFFC1E45B),
  buttonSalaryColor: Color(0xFFFFC107),
  buttonFreelanceColor: Color(0xFFFFEA01),
  buttonParentColor: Color(0xFF4CAF50),
  buttonGiftColor: Color(0xFFFFA600),
  buttonBonusColor: Color(0xFFFF6A00),
  buttonHealthColor: Color(0xFFFF3D00),
);

final lightTextStyles = AppTextStyles(
  blackTextStyle: GoogleFonts.plusJakartaSans(color: lightColors.textPrimaryColor),
  blueTextStyle: GoogleFonts.plusJakartaSans(color: lightColors.textBlueColor),
  whiteTextStyle: GoogleFonts.plusJakartaSans(color: lightColors.textWhiteColor),
  greyTextStyle: GoogleFonts.plusJakartaSans(color: lightColors.textSecondaryColor),
  greenTextStyle: GoogleFonts.plusJakartaSans(color: lightColors.textGreenColor),
  warningTextStyle: GoogleFonts.plusJakartaSans(color: lightColors.textWarningColor),
  buttonTextStyle: GoogleFonts.plusJakartaSans(color: lightColors.textButtonColor),
);

const darkColors = AppColors(
  primaryColor: Color(0xFFEA1763), // Red for dark mode
  secondaryColor: Color.fromRGBO(0, 72, 255, 1),
  darkPrimaryColor: Color(0xFFC2185B),
  buttonColor: Color(0xFFEA1763), // Red for dark mode
  statusBarPrimaryColor: Colors.transparent,
  sliderOnboardingColor: Color(0xFF9AB7FF),
  backgroundWhiteColor: Color(0xFF1E1E1E), // Dark Gray instead of white
  backgroundGreyColor: Color(0xFF2C2C2C),
  backgroundGreySecondaryColor: Color(0xFF121212),
  backgroundBlueColor: Color(0xFFCBE1FF),
  backgroundWarningColor: Color(0xFFEA1763),
  backgroundPinkColor: Color(0xFFFFCBDE),
  backgroundGreenColor: Color(0xFF20E828),
  backgroundOldGreenColor: Color(0xFF4CAF50),
  backgroundOldWarningColor: Color(0xFFEA1763),
  gradientBlueStartColor: Color(0xFF60A5FF),
  gradientBlueEndColor: Color(0xFFB1D3FF),
  skyBlueColor: Color(0xFFE0EDFF),
  textPrimaryColor: Color(0xFFFFFFFF), // White text
  textSecondaryColor: Color(0xFFAAAAAA), // Lighter secondary
  textWhiteColor: Color(0xFFFFFFFF),
  textBlueColor: Color(0xFFEA1763), // Replace blue texts with red
  textButtonColor: Color(0xFFEA1763),
  textWarningColor: Color(0xFFEA1763),
  textGreenColor: Color(0xFF20E828),
  buttonEducationColor: Color(0xFF86D3FF),
  buttonShoppingColor: Color(0xFF2885FF),
  buttonInternetColor: Color(0xFF01DDB0),
  buttonTransportationColor: Color(0xFFA377FF),
  buttonHousingColor: Color(0xFFFFF694),
  buttonFoodColor: Color(0xFFC1E45B),
  buttonSalaryColor: Color(0xFFFFC107),
  buttonFreelanceColor: Color(0xFFFFEA01),
  buttonParentColor: Color(0xFF4CAF50),
  buttonGiftColor: Color(0xFFFFA600),
  buttonBonusColor: Color(0xFFFF6A00),
  buttonHealthColor: Color(0xFFFF3D00),
);

final darkTextStyles = AppTextStyles(
  blackTextStyle: GoogleFonts.plusJakartaSans(color: darkColors.textPrimaryColor),
  blueTextStyle: GoogleFonts.plusJakartaSans(color: darkColors.textBlueColor),
  whiteTextStyle: GoogleFonts.plusJakartaSans(color: darkColors.textWhiteColor),
  greyTextStyle: GoogleFonts.plusJakartaSans(color: darkColors.textSecondaryColor),
  greenTextStyle: GoogleFonts.plusJakartaSans(color: darkColors.textGreenColor),
  warningTextStyle: GoogleFonts.plusJakartaSans(color: darkColors.textWarningColor),
  buttonTextStyle: GoogleFonts.plusJakartaSans(color: darkColors.textButtonColor),
);


ThemeData get lightTheme => ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: lightColors.primaryColor,
    surface: lightColors.backgroundWhiteColor,
  ),
  scaffoldBackgroundColor: lightColors.backgroundWhiteColor,
  extensions: <ThemeExtension<dynamic>>[
    lightColors,
    lightTextStyles,
  ],
);

ThemeData get darkTheme => ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: darkColors.primaryColor,
    surface: darkColors.backgroundWhiteColor,
  ),
  scaffoldBackgroundColor: darkColors.backgroundWhiteColor,
  extensions: <ThemeExtension<dynamic>>[
    darkColors,
    darkTextStyles,
  ],
);

extension ThemeContextExtension on BuildContext {
  AppColors get color => Theme.of(this).extension<AppColors>()!;
  AppTextStyles get text => Theme.of(this).extension<AppTextStyles>()!;
}
