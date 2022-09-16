import 'dart:ui';

import 'package:everest_app/controller/currency_card_controller.dart';
import 'package:everest_app/model/currency_card_model.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyCard extends StatefulWidget {
  const CurrencyCard({
    Key? key,
    required this.model,
  }) : super(key: key);
  final Map model;

  @override
  State createState() => _CurrencyCardState();
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

  @override
  Widget build(BuildContext context) {
    Color bgColor = con.model.difference >= 0
        ? const Color(0xFF105a37).withOpacity(0.55)
        : const Color.fromARGB(255, 146, 9, 9).withOpacity(0.55);

    Color priceColor = con.model.difference >= 0
        ? const Color.fromARGB(255, 34, 221, 118)
        : const Color.fromARGB(255, 231, 27, 27);

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
            Container(
              //height: 300,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFA1B4C4).withOpacity(0.12),
                    bgColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                //borderRadius: BorderRadius.circular(8),
                //border: Border.all(
                //  width: 2,
                //  color: Colors.white70.withOpacity(0.25),
                //),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 27, 31, 34),
                        foregroundColor: Colors.white,
                        radius: 18,
                        child: Icon(
                          Icons.currency_bitcoin,
                          size: 24,
                        ),
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
                              con.model.description,
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
                          (con.model.difference.sign > 0 ? '%' : '-%') +
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
                            : Icons.arrow_drop_down,
                        size: 18,
                        color: priceColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 48,
                        child: Text(
                          con.model.buyPrice.toString(),
                          style: GoogleFonts.cairo(
                            color: priceColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      SizedBox(
                        width: 48,
                        child: Text(
                          con.model.sellPrice.toString(),
                          style: GoogleFonts.cairo(
                            color: priceColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
