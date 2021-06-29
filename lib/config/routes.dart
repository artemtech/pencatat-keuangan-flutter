import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pencatat_keuangan/config/constant.dart';
import 'package:pencatat_keuangan/screens/dashboard_screen.dart';
import 'package:pencatat_keuangan/screens/firstrun_screen.dart';
import 'package:pencatat_keuangan/screens/new_transaction_screen.dart';
import 'package:pencatat_keuangan/screens/report_screen.dart';

class Routes {
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboardPage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => DashboardPage());
      case firstRunPage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => FirstRunPage());
      case addNewTransactionPage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => NewTransactionScreen());
      case reportPage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => ReportScreen());
      default:
        return null;
    }
  }
}
