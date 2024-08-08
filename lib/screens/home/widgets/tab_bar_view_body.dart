import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../model/scan_history_model.dart';
import '../../../model/visite_model.dart';
import 'scan_history_card.dart';

class TabBarViewBody extends StatelessWidget {
  const TabBarViewBody({
    super.key,
    required this.size,
    required this.date,
  });

  final DateTime date;
  final Size size;

  Future<List<VisiteModel>> _loadData() async {
    // Obtient la liste des ScanHistoryModel pour la date sélectionnée
    List<ScanHistoryModel> scanList =
        await Functions.getSelectedDateScanHistory(selectedDate: date);
    // Utilise cette liste pour obtenir les VisiteModel
    return await Functions.getScannedQrCode(scanList: scanList);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VisiteModel>>(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement pendant que les données sont en cours de chargement
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Afficher un message d'erreur si une erreur s'est produite lors du chargement des données
          print(snapshot.error);
          return Center(
            child: AppText.medium(
              'Erreur lors du chargement des données !',
              textAlign: TextAlign.center,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Afficher un message si aucune donnée n'est disponible pour la date sélectionnée
          return Center(
            child: AppText.medium(
              'Pas de scan enregistré\npour cette date !',
              textAlign: TextAlign.center,
            ),
          );
        }

        List<VisiteModel> qrCodesList = snapshot.data!;

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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              qrCodesList.length,
                              (index) => ScanHistoryCard(
                                visite: qrCodesList[index],
                              ),
                            ),
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
      },
    );
  }
}
