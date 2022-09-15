import 'package:everest_app/components/currency_card.dart';
import 'package:everest_app/controller/app_controller.dart';
import 'package:everest_app/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import 'package:google_fonts/google_fonts.dart';

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
        body: Column(
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
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      const SizedBox(height: 0),
                      const CurrencyCard(
                        model: {
                          "name": "USDTRY",
                          "description": "Amerikan Doları",
                          "buy_price": 18.384,
                          "sell_price": 18.452,
                          "difference": 0.12,
                        },
                      ),
                      const SizedBox(height: 8),
                      const CurrencyCard(
                        model: {
                          "name": "EURTRY",
                          "description": "Euro",
                          "buy_price": 18.345,
                          "sell_price": 18.447,
                          "difference": 0.31,
                        },
                      ),
                      const SizedBox(height: 8),
                      const CurrencyCard(
                        model: {
                          "name": "EURUSD",
                          "description": "Euro/Dolar",
                          "buy_price": 0.997,
                          "sell_price": 0.999,
                          "difference": 0.18,
                        },
                      ),
                      const SizedBox(height: 8),
                      const CurrencyCard(
                        model: {
                          "name": "JPYTRY",
                          "description": "Japon Yeni",
                          "buy_price": 0.127,
                          "sell_price": 0.128,
                          "difference": -0.08,
                        },
                      ),
                      const SizedBox(height: 8),
                      const CurrencyCard(
                        model: {
                          "name": "GBPTRY",
                          "description": "İngiliz Sterlini",
                          "buy_price": 20.998,
                          "sell_price": 21.168,
                          "difference": -0.47,
                        },
                      ),
                      const SizedBox(height: 8),
                      const CurrencyCard(
                        model: {
                          "name": "DKKTRY",
                          "description": "Danimarka Kronu",
                          "buy_price": 2.44,
                          "sell_price": 2.481,
                          "difference": 0.32,
                        },
                      ),
                      const SizedBox(height: 8),
                      const CurrencyCard(
                        model: {
                          "name": "SEKTRY",
                          "description": "İsveç Kronu",
                          "buy_price": 1.696,
                          "sell_price": 1.716,
                          "difference": -0.06,
                        },
                      ),
                      const SizedBox(height: 8),
                      const CurrencyCard(
                        model: {
                          "name": "NOKTRY",
                          "description": "Norveç Kronu",
                          "buy_price": 1.793,
                          "sell_price": 1.803,
                          "difference": -0.61,
                        },
                      ),
                      const SizedBox(height: 8),
                      const CurrencyCard(
                        model: {
                          "name": "CHFTRY",
                          "description": "İsviçre Frangı",
                          "buy_price": 19.006,
                          "sell_price": 19.187,
                          "difference": 0.27,
                        },
                      ),
                      const SizedBox(height: 8),
                      const CurrencyCard(
                        model: {
                          "name": "AUDTRY",
                          "description": "Avustralya Doları",
                          "buy_price": 12.079,
                          "sell_price": 12.329,
                          "difference": -0.40,
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SetState(
          builder: (context, object) => BottomNavigationBar(
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
            backgroundColor: const Color(0xff202529),
            currentIndex: appCon.bottomNavIndex,
            onTap: (index) => appCon.onNavbarChanged(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.auto_graph,
                ),
                label: "Piyasa",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.currency_exchange,
                ),
                label: "Çevirici",
              ),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
              SizedBox(
                width: 48,
                child: Text(
                  "Fark",
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
