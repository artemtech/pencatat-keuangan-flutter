import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pencatat_keuangan/config/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstRunPage extends StatefulWidget {
  const FirstRunPage({Key? key}) : super(key: key);

  @override
  _FirstRunPageState createState() => _FirstRunPageState();
}

class _FirstRunPageState extends State<FirstRunPage> {
  PageController _pageController = new PageController();
  int _currentPage = 0;

  void onPageChanged(int idx) {
    setState(() {
      _currentPage = idx;
    });
  }

  List<Widget> buildDaftarHalaman() {
    print(MediaQuery.of(context).size.width * 0.3);
    return <Widget>[
      Container(
        color: blackTextColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  "Catat Pengeluaran dan Pemasukanmu dengan Mudah!",
                  textAlign: TextAlign.center,
                  style: textStyle(textColor: whiteTextColor, isBold: true),
                ),
              ),
            ]),
      ),
      Container(
        color: primarySolid,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  "Pantau pengeluaran dan pemasukanmu sekarang juga!",
                  textAlign: TextAlign.center,
                  style: textStyle(textColor: whiteTextColor, isBold: true),
                ),
              ),
            ]),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> daftarHalaman = buildDaftarHalaman();

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: onPageChanged,
            controller: _pageController,
            children: daftarHalaman,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                      daftarHalaman.length,
                      (index) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                margin: EdgeInsets.only(right: 5, left: 5),
                                duration: Duration(milliseconds: 300),
                                height: 20,
                                width: (_currentPage == index) ? 50 : 20,
                                decoration: BoxDecoration(
                                    color: (_currentPage == index)
                                        ? Colors.white
                                        : Colors.white.withOpacity(.4),
                                    borderRadius: BorderRadius.circular(20)),
                              )
                            ],
                          ))),
              SizedBox(
                height: 20,
              ),
              Material(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    splashColor: Colors.red,
                    onTap: () async {
                      if (_currentPage == daftarHalaman.length - 1) {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setBool("isfirstrun", false);
                        Navigator.pushReplacementNamed(context, dashboardPage);
                        return;
                      }
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeInOutQuint);
                    },
                    child: AnimatedContainer(
                      width:
                          (_currentPage == daftarHalaman.length - 1) ? 120 : 48,
                      height: 48,
                      duration: Duration(milliseconds: 300),
                      alignment: Alignment.center,
                      child: (_currentPage == daftarHalaman.length - 1)
                          ? Text(
                              "Mulai!",
                              textAlign: TextAlign.center,
                            )
                          : Icon(Icons.navigate_next),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
