import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanner/config/app_text.dart';
import 'package:scanner/model/agl_livraison_model.dart';

class DeliRow extends StatelessWidget {
  const DeliRow({super.key, required this.deli});
  final AglLivraisonModel deli;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/images/deli.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.medium(deli.numeroImmatriculation),
                AppText.medium(
                  maxLine: 1,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  textOverflow: TextOverflow.ellipsis,
                  '${deli.nom} ${deli.prenoms} \u2022 ${deli.numeroPiece}',
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 16,
          )
        ],
      ),
    );
  }
}
