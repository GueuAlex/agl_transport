import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../config/app_text.dart';
import '../../model/tracteur_modal.dart';
import 'icon_row.dart';

class FullDetails extends StatelessWidget {
  const FullDetails({
    super.key,
    required this.deli,
  });
  final DeliDetailsModel deli;

  @override
  Widget build(BuildContext context) {
    bool isFinish = deli.livraison.status.trim().toLowerCase() == 'terminée';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: AppText.medium(
            'Détails de la livraison',
            color: Color.fromARGB(255, 40, 40, 40),
          ),
        ),
        IconRow(
          icon: CupertinoIcons.person_fill,
          title: '${deli.livraison.nom} ${deli.livraison.prenoms}',
          subtitle: deli.livraison.telephone,
        ),
        IconRow(
          icon: CupertinoIcons.calendar,
          title: DateFormat("EEEE d MMMM yyyy", 'fr')
              .format(deli.livraison.dateLivraison!),
          subtitle: !isFinish
              ? 'à ${deli.livraison.heureEntree}'
              : 'De ${deli.livraison.heureEntree} à ${deli.livraison.heureSortie}',
        ),
      ],
    );
  }
}
