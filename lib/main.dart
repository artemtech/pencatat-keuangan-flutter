import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pencatat_keuangan/config/constant.dart';
import 'package:pencatat_keuangan/config/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
