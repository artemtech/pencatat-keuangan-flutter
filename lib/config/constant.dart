import 'package:flutter/material.dart';
import 'package:pencatat_keuangan/components/appdrawer.dart';

// named route
const String dashboardPage = '/dashboard';
const String firstRunPage = '/firstRun';
const String addNewTransactionPage = '/transaction/new';
const String reportPage = '/report';

// styles
const Color blackTextColor = Color(0xFF334455);
const Color whiteTextColor = Color(0xffffffff);
const Color whiteShadeColor = Color(0xffcdd8e3);
const Color primarySolid = Color(0xffad1457);

ThemeData appTheme = ThemeData(
  primaryColor: primarySolid,
);

TextStyle textStyle({Color textColor = Colors.green, bool isBold = false}) {
  return TextStyle(
      fontSize: 18,
      color: textColor,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal);
}

AppDrawer navDrawer = AppDrawer();
