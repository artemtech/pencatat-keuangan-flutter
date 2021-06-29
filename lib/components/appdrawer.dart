import 'package:flutter/material.dart';
import 'package:pencatat_keuangan/config/constant.dart';

class AppDrawer extends StatelessWidget {
  void goToDashboard(BuildContext context) {
    if (ModalRoute.of(context)!.settings.name == dashboardPage) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(dashboardPage, (route) => false);
    }
  }

  void goToReport(BuildContext context) {
    if (ModalRoute.of(context)!.settings.name == reportPage) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(reportPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        DrawerHeader(
          padding: EdgeInsets.only(bottom: 20, left: 20),
          decoration: BoxDecoration(color: primarySolid),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Pencatat Keuangan v1.0",
                style: TextStyle(color: whiteTextColor),
              )),
        ),
        ListTile(
          leading: Icon(
            Icons.insert_drive_file_outlined,
            color: (ModalRoute.of(context)!.settings.name == dashboardPage)
                ? whiteTextColor
                : primarySolid.withOpacity(0.8),
          ),
          selected: (ModalRoute.of(context)!.settings.name == dashboardPage)
              ? true
              : false,
          selectedTileColor:
              (ModalRoute.of(context)!.settings.name == dashboardPage)
                  ? primarySolid.withOpacity(0.8)
                  : whiteTextColor,
          title: Text(
            "Transaksi Hari ini",
            style: textStyle(
                textColor:
                    (ModalRoute.of(context)!.settings.name == dashboardPage)
                        ? whiteTextColor
                        : primarySolid.withOpacity(0.8)),
          ),
          onTap: () => goToDashboard(context),
        ),
        ListTile(
          leading: Icon(
            Icons.date_range_outlined,
            color: (ModalRoute.of(context)!.settings.name == reportPage)
                ? whiteTextColor
                : primarySolid.withOpacity(0.8),
          ),
          selected: (ModalRoute.of(context)!.settings.name == reportPage)
              ? true
              : false,
          selectedTileColor:
              (ModalRoute.of(context)!.settings.name == reportPage)
                  ? primarySolid.withOpacity(0.8)
                  : whiteTextColor,
          title: Text(
            "Rekap Bulanan",
            style: textStyle(
                textColor: (ModalRoute.of(context)!.settings.name == reportPage)
                    ? whiteTextColor
                    : primarySolid.withOpacity(0.8)),
          ),
          onTap: () => goToReport(context),
        ),
      ],
    ));
  }
}
