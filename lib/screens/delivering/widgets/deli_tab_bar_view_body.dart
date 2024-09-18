import 'package:flutter/material.dart';
import 'package:scanner/model/agl_livraison_model.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import 'deli_history_card.dart';

class DeliTabBarViewBody extends StatelessWidget {
  const DeliTabBarViewBody({
    super.key,
    required this.size,
    required this.date,
    /* required this.status, */
  });

  final DateTime date;
  final Size size;
  /* final String status; */

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AglLivraisonModel>>(
      future: AglLivraisonModel.getDeli(date: date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement pendant que les données sont en cours de chargement
          return Center(child: CircularProgressIndicator.adaptive());
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
              'Aucune livraison enregistrée\npour cette date !',
              textAlign: TextAlign.center,
            ),
          );
        }

        List<AglLivraisonModel> livraisons = snapshot.data!;

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
                      child: livraisons.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: livraisons
                                      .map(
                                        (livraisonDetail) => DeliHistoryCard(
                                          livraison: livraisonDetail,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          : Center(
                              child: AppText.medium(
                                'Aucune livraison enregistrée\npour cette date !',
                                textAlign: TextAlign.center,
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
