import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/app_text.dart';
import '../../model/tracteur_modal.dart';

class BoxRow extends StatelessWidget {
  const BoxRow({
    super.key,
    required this.deli,
  });
  final DeliDetailsModel deli;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _box(
          title: 'Type de colis',
          subtitle: deli.livraison.typeColis,
          color: Color.fromARGB(255, 3, 152, 137),
          asset: 'assets/icons/chargement-de-camion.svg',
        ),
        _box(
          title: 'Entreprise',
          subtitle: deli.livraison.entreprise,
          color: Color.fromARGB(255, 19, 5, 112),
          asset: 'assets/icons/construction-de-maison.svg',
        ),
        _box(
          title: 'Localisation',
          subtitle: deli.livraison.localisation.libelle,
          color: Color.fromARGB(255, 168, 22, 200),
          asset: 'assets/icons/map-marker-home.svg',
        ),
      ],
    );
  }

  Container _box({
    required String title,
    required String subtitle,
    required Color color,
    required String asset,
  }) =>
      Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.12),
          border: Border.all(
            width: 0.5,
            color: color,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              asset,
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            AppText.small(
              title,
              color: Color.fromARGB(255, 160, 160, 160),
              fontWeight: FontWeight.w600,
            ),
            AppText.medium(
              subtitle,
              color: color,
            )
          ],
        ),
      );
}
