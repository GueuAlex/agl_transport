import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import '../../../widgets/custom_button.dart';

Widget outsideAccessHours({
  required String text,
  required BuildContext context,
}) {
  return Column(
    children: [
      Container(
        width: 200,
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Image.asset('assets/images/timer2.webp'),
      ),
      AppText.large('Oops !'),
      Text(
        'Accès non autorisé en dehors des horaires.\n----\n$text',
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 25,
      ),
      CustomButton(
        color: Palette.primaryColor,
        width: double.infinity,
        height: 35,
        radius: 5,
        text: 'Retour',
        onPress: () => Navigator.pop(context), //Get.back(),
      ),
    ],
  );
}
