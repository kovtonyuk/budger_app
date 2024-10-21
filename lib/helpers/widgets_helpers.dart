import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

Widget buildPeriodContainer(
    String label, Color backgroundColor, Color textColor) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8), // Заокруглені краї
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: textColor,
        ),
      ),
    ),
  );
}
