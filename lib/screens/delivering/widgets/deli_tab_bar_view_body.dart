import 'package:flutter/material.dart';
import 'package:scanner/model/livraison_model.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import 'deli_history_card.dart';

class DeliTabBarViewBody extends StatelessWidget {
  const DeliTabBarViewBody({
    super.key,
    required this.size,
    required this.date,
    this.status = 'en cours',
  });
  final DateTime date;

  final Size size;
  final String status;

  @override
  Widget build(BuildContext context) {
    /*   List<QrCodeModel> qrCodesList = Functions.getScannedQrCode(
      scanList: Functions.getSelectedDateScanHistory(selectedDate: date),
    ); */

    List<Livraison> livraisons =
        Functions.getSelectedDateLivraisons(selectedDate: date, status: status);
    for (Livraison element in livraisons) {
      print('\n livraison ==> :${element.entreprise} \n');
    }
    return Container(
      height: size.height,
      width: double.infinity,
      color: Palette.whiteColor,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Functions.getSelectedDateLivraisons(selectedDate: date)
                          .isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SingleChildScrollView(
                              child: Column(
                                  children: livraisons
                                      .map((livraison) =>
                                          DeliHistoryCard(livraison: livraison))
                                      .toList()) /* List.generate(
                                livraisons.length,
                                (index) => DeliHistoryCard(
                                  //qrCodeModel: qrCodesList[index],
                                  livraison: livraisons[index],
                                ),
                              ), */
                              ),
                        )
                      : Container(
                          child: Center(
                            child: AppText.medium(
                              'Aucune livraison enregistrée\npour cette date !',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
