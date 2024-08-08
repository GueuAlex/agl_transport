import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import '../../../model/user.dart';
import '../../../model/visite_model.dart';
import '../../scanner/widgets/infos_column.dart';

class DetailsHeader extends StatelessWidget {
  final bool isQrcodeInfos;
  final User user;
  final VisiteModel visite;
  const DetailsHeader({
    this.isQrcodeInfos = false,
    required this.visite,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black.withOpacity(0.12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Palette.primaryColor,
                  ),
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Icon(
                      isQrcodeInfos
                          ? CupertinoIcons.qrcode
                          : CupertinoIcons.person,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            AppText.medium(
              isQrcodeInfos ? user.motifVisite : '${user.nom} ${user.prenoms}',
              textOverflow: TextOverflow.ellipsis,
              color: Palette.whiteColor,
              fontSize: 11,
            ),
            isQrcodeInfos
                ? AppText.small(
                    visite.codeVisite,
                    textOverflow: TextOverflow.fade,
                    color: Palette.whiteColor,
                  )
                : AppText.small(
                    user.entreprise,
                    textOverflow: TextOverflow.fade,
                    fontWeight: FontWeight.w500,
                    color: Palette.whiteColor,
                    fontSize: 10,
                  ),
            isQrcodeInfos
                ? Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            opacity: 0.3,
                            label: /* qrCodeModel.type == 'temporaire' */

                                'Depuis',
                            widget: FittedBox(
                              child: AppText.medium(
                                DateFormat('dd/MM/yyyy')
                                    .format(visite.dateVisite),
                                color: Palette.whiteColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Container()
                      ],
                    ),
                  )
                : AppText.small(
                    user.number,
                    textOverflow: TextOverflow.fade,
                    color: Palette.whiteColor,
                  )
          ],
        ),
      ),
    );
  }
}
