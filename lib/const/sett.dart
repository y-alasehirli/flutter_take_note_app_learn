import 'package:flutter/material.dart';

class Setts {
  static final primaryColor = Colors.deepPurple;
  static final secondColor = Colors.deepOrange;
  static final ignoreColor = Colors.blueGrey;
  static final emergeColor = Colors.red.shade800;
  static final headTitle1 = TextStyle(
    color: primaryColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static final headTitle2 = TextStyle(
    color: primaryColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static final subTitle1 = TextStyle(
    color: secondColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static final ignoreTextS = TextStyle(
    color: ignoreColor,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static final mainTheme = ThemeData(
    iconTheme: IconThemeData(color: emergeColor),
    primaryIconTheme: IconThemeData(color: secondColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 2,
      foregroundColor: Colors.white,
      backgroundColor: secondColor,
    ),
    primarySwatch: primaryColor,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: secondColor),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
      ),
    ),
  );
  static final kategoriEkleDeco = InputDecoration(
    hintText: "...",
    fillColor: secondColor.withOpacity(0.2),
    filled: true,
    border: InputBorder.none,
    /* border: OutlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.none,
        color: secondColor,
      ),
      borderRadius: BorderRadius.circular(10),
    ), */
  );
  static final dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
  );
  static final emergeButtonStyle =
      ElevatedButton.styleFrom(primary: emergeColor);
}
