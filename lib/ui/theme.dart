import 'dart:ui';

import 'package:flutter/material.dart';

ThemeData buildTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: TextStyle(
        fontFamily: 'Merriweather',
        fontSize: 40.0,
        color: const Color(0xFF807A6B),
      ),
      // Used for the recipes' title:
      subtitle1: TextStyle(
        fontFamily: 'Merriweather',
        fontSize: 15.0,
        color: const Color(0xFF807A6B),
      ),
      // Used for the recipes' duration:
      caption: TextStyle(
        color: const Color(0xFFCCC5AF),
      ),
      bodyText1: TextStyle(color: const Color(0xFF807A6B)),
    );
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.light();

  // And apply changes on it:
  return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      primaryColor: const Color(0xFFFFF8E1),
      indicatorColor: const Color(0xFF807A6B),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      iconTheme: IconThemeData(
        color: const Color(0xFFCCC5AF),
        size: 20.0,
      ),
      backgroundColor: Colors.white,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: const Color(0xFF807A6B),
        unselectedLabelColor: const Color(0xFFCCC5AF),
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: const Color(0xFFFFF8E1)));
}
