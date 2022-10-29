import 'dart:convert';

import 'package:everest_group/components/currency_card.dart';
import 'package:everest_group/controller/app_controller.dart';
import 'package:everest_group/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Map<String, CurrencyCard>? cards;

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
        appBar: buildAppBar(context),
      );

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black26,
      toolbarHeight: 64,
      leadingWidth: 64,
      leading: Row(
        children: [
          const SizedBox(width: 8),
          Image.asset(
            'assets/images/everest-logo.png',
            width: 48,
            height: 48,
          ),
          const SizedBox(width: 8),
        ],
      ),
      titleSpacing: 0,
      title: Text(
        "EVEREST GROUP",
        style: GoogleFonts.arefRuqaa(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    switch (appCon.bottomNavIndex) {
      case 0:
      case 1:
        return rateTable(context);
      case 2:
        return contactUs(context);
      default:
        return Container();
    }
  }

  Widget rateTable(BuildContext context) {
    return SetState(
      builder: (context, object) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildHeader(context),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: SingleChildScrollView(
                  child: StreamBuilder(
                    stream: appCon.ws?.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 64,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      Map data = jsonDecode(snapshot.data as String);

                      if (cards == null) {
                        cards = data.map(
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
                          cards![key] = CurrencyCard(
                            key: UniqueKey(),
                            model: model,
                            updated: true,
                          );
                        });
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: cards!.values.toList(),
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

  Widget contactUs(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'İLETİŞİM BİLGİLERİ',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueGrey.shade800,
            child: Icon(Icons.phone, color: Colors.white54),
          ),
          const SizedBox(height: 12),
          Text(
            '-',
            style: GoogleFonts.cairo(
              color: Colors.white54,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          //////////////
          const SizedBox(height: 48),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueGrey.shade800,
            child: Icon(Icons.location_on, color: Colors.white54),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.fromLTRB(36, 0, 36, 0),
            child: Text(
              'Tayahatun Mahallesi Mercan Kapısı Çıkışı Tığcılar Sokak Pastırmacı Han No:10, Fatih/İstanbul',
              style: GoogleFonts.cairo(
                color: Colors.white54,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          //////////////
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueGrey.shade800,
            child: Icon(Icons.mail, color: Colors.white54),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.fromLTRB(36, 0, 36, 0),
            child: Text(
              'info.evergroup@gmail.com',
              style: GoogleFonts.cairo(
                color: Colors.white54,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          //////////////
          const SizedBox(height: 48),
          InkWell(
            onTap: () => _launchWhatsapp(),
            child: Container(
              padding: EdgeInsets.all(8),
              width: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.green,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.whatsapp, color: Colors.white, size: 48),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Text(
                        'WhatsApp',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Mesaj yollamak için tıklayın',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWhatsapp() async {
    var whatsapp = "+905318649984";
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsapp&text=Merhaba%20Everest");

    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
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
          onTap: (index) {
            cards = null;
            appCon.onNavbarChanged(index);
          },
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
              icon: Icon(Icons.mail),
              label: "İletişim",
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
                width: 64,
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
                width: 64,
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
