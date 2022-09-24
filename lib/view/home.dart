import 'dart:convert';

import 'package:everest_app/components/currency_card.dart';
import 'package:everest_app/controller/app_controller.dart';
import 'package:everest_app/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    this.title = 'Flutter Demo',
  }) : super(key: key);

  // Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  State createState() => _MyHomePageState();
}

/// This 'MVC version' is a subclass of the State class.
/// This version is linked to the App's lifecycle using [WidgetsBindingObserver]
class _MyHomePageState extends StateX<MyHomePage> {
  /// Let the 'business logic' run in a Controller
  _MyHomePageState() : super(HomeController()) {
    /// Acquire a reference to the passed Controller.
    con = controller as HomeController;
  }
  late HomeController con;
  late AppStateX appState;
  late AppController appCon;

  @override
  void initState() {
    /// Look inside the parent function and see it calls
    /// all it's Controllers if any.
    super.initState();

    /// Retrieve the 'app level' State object
    appState = rootState!;

    appCon = appState.controller as AppController;
  }

  /// This is 'the View'; the interface of the home page.
  @override
  Widget build(BuildContext context) => Scaffold(
        //appBar: AppBar(
        //  title: Text(widget.title),
        //),
        backgroundColor: const Color.fromARGB(255, 27, 31, 34),
        body: SetState(builder: (context, object) => content(context)),
        bottomNavigationBar: buildBottomNavbar(context),
      );

  Widget content(BuildContext context) {
    switch (appCon.bottomNavIndex) {
      case 0:
      case 1:
        return rateTable(context);
      default:
        return Container();
    }
  }

  Widget rateTable(BuildContext context) {
    return SetState(
      builder: (context, object) {
        return Column(
          children: [
            const SizedBox(height: 32),
            buildHeader(context),
            Flexible(
              //decoration: BoxDecoration(
              //image: DecorationImage(
              //  image: AssetImage("assets/images/bg.png"),
              //  fit: BoxFit.cover,
              //),
              //),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: SingleChildScrollView(
                  child: StreamBuilder(
                    stream: appCon.ws?.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      Map data = jsonDecode(snapshot.data as String);

                      var _cards = appCon.cards;
                      if (_cards == null) {
                        _cards = data.map(
                          (key, model) => MapEntry(
                            key,
                            CurrencyCard(
                              key: UniqueKey(),
                              model: model,
                            ),
                          ),
                        );
                      } else {
                        data.forEach((key, model) {
                          _cards![key] = CurrencyCard(
                            key: UniqueKey(),
                            model: model,
                          );
                        });
                      }

                      return SetState(
                        builder: (context, object) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _cards!.values.toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildBottomNavbar(BuildContext context) {
    return SetState(
      builder: (context, object) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 45, 54, 65),
              Color.fromARGB(255, 21, 26, 32),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border(
            top: BorderSide(width: 1, color: Color.fromARGB(255, 25, 37, 49)),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xff1BC6B4),
          selectedLabelStyle: GoogleFonts.aBeeZee(
            color: const Color(0xff1BC6B4),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 2,
          ),
          unselectedLabelStyle: GoogleFonts.aBeeZee(
            color: const Color(0xffA1B4C4),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 2,
          ),
          unselectedItemColor: const Color(0xffA1B4C4),
          backgroundColor: const Color.fromARGB(0, 12, 14, 15),
          currentIndex: appCon.bottomNavIndex,
          onTap: (index) => appCon.onNavbarChanged(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph),
              label: "Döviz",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.balance_rounded),
              label: "Maden",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_bitcoin),
              label: "Kripto",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              label: "Çevirici",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      //margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey.withOpacity(0.125),
            Colors.blueGrey.shade800.withOpacity(0.75),
            Colors.blueGrey.withOpacity(0.125),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Birim",
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  "Alış",
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                width: 48,
                child: Text(
                  "Satış",
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Supply an error handler for Unit Testing.
  @override
  void onError(FlutterErrorDetails details) {
    /// Error is now handled.
    super.onError(details);
  }
}
