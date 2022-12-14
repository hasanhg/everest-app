import 'dart:ui';

import 'package:everest_group/controller/currency_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import 'package:google_fonts/google_fonts.dart';

Map descMap = {
  "USDTRY": "Amerikan Doları",
  "EURTRY": "Euro",
  "EURUSD": "Euro/Dolar",
  "JPYTRY": "Japon Yeni",
  "GBPTRY": "İngiliz Sterlini",
  "DKKTRY": "Danimarka Kronu",
  "SEKTRY": "İsveç Kronu",
  "NOKTRY": "Norveç Kronu",
  "CHFTRY": "İsviçre Frangı",
  "AUDTRY": "Avustralya Doları",
  "ALTIN": "Altın/TL (gr)",
  "ONS": "Altın/USD (ons)",
  "KULCEALTIN": "Külçe Altın (gr)",
  "CEYREK_YENI": "Çeyrek Altın",
  "GUMUSTRY": "Gümüş (gr)",
  "GUMUSUSD": "Gümüş (kg)",
  "XPTUSD": "Platinyum (ons)",
  "XPDUSD": "Paladyum (ons)",
  "PLATIN": "Platinyum (kg)",
  "PALADYUM": "Paladyum (kg)",
};

Map<String, List<IconData>> iconMap = {
  "USDTRY": [Icons.attach_money, Icons.currency_lira],
  "EURTRY": [Icons.euro_symbol, Icons.currency_lira],
  "EURUSD": [Icons.euro_symbol, Icons.currency_lira],
  "JPYTRY": [Icons.currency_yen, Icons.currency_lira],
  "GBPTRY": [Icons.currency_pound, Icons.currency_lira],
  "CHFTRY": [Icons.currency_franc, Icons.currency_lira],
  "AUDTRY": [Icons.attach_money, Icons.currency_lira],
};

Map<String, String> iconMapFallback = {
  "DKKTRY": "kr.",
  "SEKTRY": "kr",
  "NOKTRY": "kr",
  "ALTIN": "Au",
  "ONS": "Au",
  "KULCEALTIN": "Au",
  "CEYREK_YENI": "Au",
  "GUMUSTRY": "Ag",
  "GUMUSUSD": "Ag",
  "XPTUSD": "Pt",
  "XPDUSD": "Pd",
  "PLATIN": "Pt",
  "PALADYUM": "Pd",
};

class CurrencyCard extends StatefulWidget {
  const CurrencyCard({
    Key? key,
    required this.model,
    this.updated = false,
  }) : super(key: key);

  final Map model;
  final bool updated;

  @override
  State createState() => _CurrencyCardState();

  @override
  String toString({DiagnosticLevel? minLevel}) => "${model}";
}

class _CurrencyCardState extends StateX<CurrencyCard> {
  _CurrencyCardState() : super(CurrencyCardController()) {
    con = controller as CurrencyCardController;
  }

  late CurrencyCardController con;
  late AppStateX appState;

  @override
  void initState() {
    /// Look inside the parent function and see it calls
    /// all it's Controllers if any.
    super.initState();

    con.setModel(widget.model);

    /// Retrieve the 'app level' State object
    appState = rootState!;
  }

  Widget buildIcon() {
    IconData? iconData = iconMap[con.model.name]?[0];

    return Stack(
      children: [
        Positioned(
          child: iconData != null
              ? Icon(
                  iconData,
                  size: 24,
                )
              : Text(
                  iconMapFallback[con.model.name] ?? '',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
          //top: 12,
          //left: 6,
        ),
        /*
        Positioned(
          child: Icon(
            iconMap[con.model.name]?[1] ?? Icons.priority_high,
            size: 16,
          ),
          top: 12,
          right: 6,
        ),
        */
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.grey.shade800.withOpacity(0.75);

    if (con.model.difference > 0) {
      bgColor = const Color(0xFF105a37).withOpacity(0.55);
    } else if (con.model.difference < 0) {
      bgColor = const Color.fromARGB(255, 146, 9, 9).withOpacity(0.55);
    }

    return ClipRRect(
      //borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Stack(
          children: [
            Positioned(
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.white54,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${con.model.lastUpdatedAt.hour.toString().padLeft(2, "0")}:${con.model.lastUpdatedAt.minute.toString().padLeft(2, "0")}',
                    style: GoogleFonts.cairo(
                      color: Colors.white54,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              right: 6,
              bottom: 6,
            ),
            FutureBuilder(
              future: Future.delayed(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                bool updated = widget.updated &&
                    snapshot.connectionState == ConnectionState.waiting;

                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  decoration: BoxDecoration(
                    gradient: updated
                        ? LinearGradient(
                            colors: [
                              Colors.blueGrey.shade400.withOpacity(0.5),
                              Colors.blueGrey.withOpacity(0.5),
                              Colors.blueGrey.shade400.withOpacity(0.5),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : LinearGradient(
                            colors: [
                              const Color(0xFFA1B4C4).withOpacity(0.12),
                              bgColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    border: Border.all(
                      width: 1,
                      color: updated
                          ? Colors.blueGrey.shade300
                          : const Color.fromARGB(255, 27, 31, 34),
                    ),
                  ),
                  child: buildCard(context),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context) {
    Color priceColor = Colors.grey;

    if (con.model.difference > 0) {
      priceColor = const Color.fromARGB(255, 34, 221, 118);
    } else if (con.model.difference < 0) {
      priceColor = const Color.fromARGB(255, 231, 27, 27);
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 27, 31, 34),
              foregroundColor: Colors.white,
              radius: 20,
              child: buildIcon(),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    con.model.name,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    con.model.description ?? descMap[con.model.name] ?? "",
                    style: GoogleFonts.cairo(
                      color: Colors.white54,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 0),
            SizedBox(
              width: 36,
              child: Text(
                (con.model.difference.sign >= 0 ? '%' : '-%') +
                    con.model.difference.abs().toString(),
                style: GoogleFonts.cairo(
                  color: priceColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            Icon(
              con.model.difference.sign > 0
                  ? Icons.arrow_drop_up
                  : con.model.difference.sign < 0
                      ? Icons.arrow_drop_down
                      : Icons.remove,
              size: 18,
              color: priceColor,
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 64,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  FutureBuilder(
                    future: Future.delayed(
                      const Duration(seconds: 2),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          con.model.buyDir != null) {
                        bool isUp = con.model.buyDir == "up";
                        Color color = isUp
                            ? const Color.fromARGB(255, 34, 221, 118)
                            : const Color.fromARGB(255, 231, 27, 27);

                        return Icon(
                          isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 16,
                          color: color,
                        );
                      }

                      return Container();
                    },
                  ),
                  Text(
                    con.model.buyPrice.toString(),
                    style: GoogleFonts.cairo(
                      color: priceColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 64,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  FutureBuilder(
                    future: Future.delayed(
                      const Duration(seconds: 2),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          con.model.sellDir != null) {
                        bool isUp = con.model.sellDir == "up";
                        Color color = isUp
                            ? const Color.fromARGB(255, 34, 221, 118)
                            : const Color.fromARGB(255, 231, 27, 27);

                        return Icon(
                          isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 16,
                          color: color,
                        );
                      }

                      return Container();
                    },
                  ),
                  Text(
                    con.model.sellPrice.toString(),
                    style: GoogleFonts.cairo(
                      color: priceColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
