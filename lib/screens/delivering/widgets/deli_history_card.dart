import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../model/tracteur_modal.dart';
import '../../../widgets/profil_picture_container.dart';
import '../../deli_details/deli_details_sheet.dart';

class DeliHistoryCard extends StatelessWidget {
  final DeliDetailsModel livraison;
  const DeliHistoryCard({
    super.key,
    required this.livraison,
  });

  @override
  Widget build(BuildContext context) {
    // User user = qrCodeModel.user;
    //final size = MediaQuery.of(context).size;
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.all(2.5),
      child: Container(
        width: double.infinity,
        child: ListTile(
          onTap: () => Functions.showBottomSheet(
            ctxt: context,
            widget: DeliDetailSheet(
              deli: livraison,
            ),
          ),
          leading: ProfilPictureContaire(asset: 'assets/images/deli.jpg'),
          title: AppText.medium(
            '${livraison.numeroTracteur} - ${livraison.livraison.typeColis}',
            textOverflow: TextOverflow.fade,
            fontSize: 12,
          ),
          subtitle: AppText.small(
            '${livraison.livraison.heureEntree}  \u2022 Par ${livraison.livraison.nom}  ',
            textOverflow: TextOverflow.fade,
          ),
          trailing: FittedBox(
            child: Row(
              children: [
                AppText.small(livraison.livraison.status),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 15,
                  color: Palette.greyColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
