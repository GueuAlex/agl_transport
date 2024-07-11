import 'package:flutter/material.dart';

import '../config/app_text.dart';

class CopyRight extends StatelessWidget {
  const CopyRight({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5.0),
          child: SizedBox(
            height: 25,
            child: Image.asset('assets/images/alg-logo-min-nobg.png'),
          ),
        ),
        AppText.small(
          'Copyright © 2024 \u2022 AGL | Secure Scan \u2022 Tous droits réservés.',
          fontSize: 10,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        AppText.small(
          'Developed by DIGIFAZ ®',
          fontSize: 8,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(
          height: 4.0,
        )
      ],
    );
  }
}
