import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import '../../../widgets/custom_button.dart';

Widget inactifQrCode({required BuildContext context}) {
  return Container(
    padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
    child: Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/disconnect.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        AppText.medium('Oops !'),
        AppText.small('Cette visite n\'est pas encore active !'),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          color: Palette.primaryColor,
          width: double.infinity,
          height: 35,
          radius: 5,
          text: 'Retour',
          onPress: () => Navigator.pop(context), //Get.back(),
        )
      ],
    ),
  );
}
