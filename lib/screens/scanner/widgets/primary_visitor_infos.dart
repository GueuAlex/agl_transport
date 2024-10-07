import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../model/visite_model.dart';
import 'infos_column.dart';

Widget PrimaryVisitorInfos({
  required VisiteModel visite,
  required TextEditingController badgeController,
  required TextEditingController cardIddController,
  required TextEditingController giletController,
  required TextEditingController iDController,
  required String idCardType,
  required Future<void> selectIdCardType,
}) {
  /////////////////
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: InfosColumn(
              label: 'Date début',
              widget: AppText.medium(
                DateFormat(
                  'dd MMM yyyy',
                  'fr_FR',
                ).format(
                  visite.dateVisite,
                ),
              ),
            ),
          ),
          Expanded(
            child: InfosColumn(
              label: 'Heure d\'entrée',
              widget: AppText.medium(
                visite.heureVisite ?? '',
              ),
            ),
          ),
        ],
      ), //
      Row(
        children: [
          Expanded(
            child: InfosColumn(
              radius: 0,
              opacity: 0.12,
              label: 'n° de pièce',
              widget: Expanded(
                child: Functions.getTextField(controller: iDController),
              ),
            ),
          ),
          Expanded(
            child: InfosColumn(
              radius: 0,
              opacity: 0.12,
              label: 'type de pièce',
              widget: InkWell(
                onTap: () => selectIdCardType,
                child: Row(
                  children: [
                    Expanded(
                      child: AppText.medium(idCardType),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InfosColumn(
              radius: 0,
              opacity: 0.12,
              label: 'n° d\'immatriculation véhicule',
              widget: Expanded(
                child: Functions.getTextField(controller: cardIddController),
              ),
            ),
          ),
        ],
      ), //
      Container(
        width: double.infinity,
        height: 0.8,
        color: Palette.separatorColor,
      ),
      const SizedBox(height: 10),
      AppText.medium(
        'Accessoires de visite',
        textAlign: TextAlign.center,
      ),
      AppText.small(
        textAlign: TextAlign.center,
        'Veuillez fournir au visiteur les accessoires de visite (badge et gilet) si necessaire',
      ),
      const SizedBox(
        height: 5,
      ),
      Row(
        children: [
          Expanded(
            child: InfosColumn(
              radius: 0,
              opacity: 0.12,
              label: 'Entrer le n° du badge',
              widget: Expanded(
                child: Functions.getTextField(controller: badgeController),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: InfosColumn(
              radius: 0,
              opacity: 0.12,
              label: 'Entrer le n° du gilet',
              widget: Expanded(
                child: Functions.getTextField(controller: giletController),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 40,
      ),

      ///
    ],
  );
}
