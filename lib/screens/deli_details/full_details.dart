import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:scanner/screens/scanner/widgets/infos_column.dart';

import '../../config/app_text.dart';
import '../../model/agl_livraison_model.dart';
import 'icon_row.dart';

class FullDetails extends StatelessWidget {
  const FullDetails({
    super.key,
    required this.deli,
  });
  final AglLivraisonModel deli;

  @override
  Widget build(BuildContext context) {
    bool isEntry = deli.mouvements == 'Entrée';
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
          title: '${deli.nom} ${deli.prenoms}',
          subtitle: "${deli.typePiece}  n°  ${deli.numeroPiece} ",
        ),
        IconRow(
          icon: CupertinoIcons.calendar,
          title: DateFormat("EEEE d MMMM yyyy", 'fr')
              .format(isEntry ? deli.dateEntree! : deli.DateSortie!),
          subtitle: 'à ${isEntry ? deli.heureEntree : deli.heureSortie}',
        ),
        const SizedBox(height: 20),
        InfosColumn(
          height: 250,
          opacity: 0.12,
          label: 'Note associée (observation)',
          widget: AppText.medium(deli.observation),
        )
      ],
    );
  }
}
