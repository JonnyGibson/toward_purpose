import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color primaryColor = Color.fromRGBO(243, 198, 152, 1.0);
final Color secondaryColor = Color.fromRGBO(140, 148, 89, 1.0);
final Color accentColor = Color.fromRGBO(210, 130, 90, 1.0);
final Color redyColor = Color.fromRGBO(209, 48, 32, 1.0);

TextStyle myTextStyle() {
  return TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
}

TextStyle GruppoSmall() {
  return GoogleFonts.gruppo(
      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
}

TextStyle GruppoMedium() {
  return GoogleFonts.gruppo(
      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24));
}

TextStyle Gruppolarge() {
  return GoogleFonts.gruppo(
      textStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 30, letterSpacing: 5));
}
