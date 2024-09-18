import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/app_text.dart';
import '../../model/agl_livraison_model.dart';

class BoxRow extends StatelessWidget {
  const BoxRow({
    super.key,
    required this.deli,
  });
  final AglLivraisonModel deli;

  @override
  Widget build(BuildContext context) {
    final designation =
        deli.designation.trim().isNotEmpty ? deli.designation : '-';

    return Row(
      children: [
        Expanded(
          child: _box(
            title: 'Type de colis (Désignation)',
            subtitle: '${designation}',
            color: Color.fromARGB(255, 3, 152, 137),
            asset: 'assets/icons/chargement-de-camion.svg',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _box(
            title: 'Entreprise',
            subtitle: deli.entreprise,
            color: Color.fromARGB(255, 19, 5, 112),
            asset: 'assets/icons/construction-de-maison.svg',
          ),
        ),
        /*  _box(
          title: 'Localisation',
          subtitle: '${localisation}',
          color: Color.fromARGB(255, 168, 22, 200),
          asset: 'assets/icons/map-marker-home.svg',
        ), */
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
        //margin: const EdgeInsets.only(right: 15),
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
              maxLine: 1,
              textOverflow: TextOverflow.ellipsis,
              color: Color.fromARGB(255, 160, 160, 160),
              fontWeight: FontWeight.w600,
            ),
            AppText.medium(
              subtitle,
              color: color,
              maxLine: 1,
              textOverflow: TextOverflow.ellipsis,
            )
          ],
        ),
      );
}
