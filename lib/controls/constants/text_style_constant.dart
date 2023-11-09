import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

dynamic keniaTextStyle({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  Color? backgroundColor,
  TextDecoration? textDecoration,
  FontStyle? fontStyle,
  double? wordSpacing,
  TextBaseline? textBaseline,
}) {
  dynamic textStyle = GoogleFonts.kenia(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    backgroundColor: backgroundColor,
    decoration: textDecoration,
    fontStyle: fontStyle,
    wordSpacing: wordSpacing,
    textBaseline: textBaseline,
  );
  return textStyle;
}
