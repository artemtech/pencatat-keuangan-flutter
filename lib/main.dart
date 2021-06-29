import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pencatat_keuangan/config/constant.dart';
import 'package:pencatat_keuangan/config/routes.dart';
import 'package:pencatat_keuangan/models/report.dart';
import 'package:pencatat_keuangan/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(ReportAdapter());
  initializeDateFormatting('id_ID');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool?> getFirstRun() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("isfirstrun");
  }

  Future<String> checkIsFirstRun() async {
    var _firstRun = await getFirstRun();
    if (_firstRun == null) {
      _firstRun = true;
    }
    if (_firstRun) {
      return firstRunPage;
    } else {
      return dashboardPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: checkIsFirstRun(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: primarySolid,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return MaterialApp(
            onGenerateRoute: Routes().onGenerateRoute,
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            initialRoute: snapshot.data,
          );
        }
      },
    );
  }
}
