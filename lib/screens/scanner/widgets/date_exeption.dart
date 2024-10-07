//widget retourné si la date de visite n'est pas encore atteinte
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scanner/config/app_text.dart';

import '../../../config/palette.dart';
import '../../../widgets/custom_button.dart';

Widget dateException({
  required DateTime dateDebut,
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
    child: Center(
      child: Column(
        children: [
          AppText.medium('Date de visite !'),
          const SizedBox(
            height: 5,
          ),
          AppText.small(
            'La date de visite pour ce code est prévue pour le\n${DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(dateDebut)}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            color: Palette.primaryColor,
            width: double.infinity,
            height: 35,
            radius: 5,
            text: 'Retour',
            onPress: () => Navigator.pop(context),
          )
        ],
      ),
    ),
  );
}
