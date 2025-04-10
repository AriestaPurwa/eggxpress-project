import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF004CFF);
  static const Color textColor = Color(0xFF202020);
  static const Color backgroundColor = Colors.white;

  static TextStyle get titleStyle => GoogleFonts.raleway(
    fontSize: 52,
    fontWeight: FontWeight.w700,
    color: textColor,
    letterSpacing: -0.52,
  );

  static TextStyle get subtitleStyle => GoogleFonts.nunitoSans(
    fontSize: 19,
    fontWeight: FontWeight.w300,
    color: textColor,
    height: 1.7,
  );

  static TextStyle get buttonTextStyle => GoogleFonts.nunitoSans(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );

  static TextStyle get linkTextStyle => GoogleFonts.nunitoSans(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    color: textColor.withOpacity(0.9),
  );

  static TextStyle get statusBarTimeStyle => GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
}