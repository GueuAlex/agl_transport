import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/palette.dart';
import '../../../model/visite_model.dart';

//affiche un alerte dialogue de confirmation en cas de modification
Future<Null> alert({
  required BuildContext ctxt,
  bool isEntree = true,
  required Function() confirm,
  required Function() cancel,
  required VisiteModel visite,
}) async {
  return showDialog(
    barrierDismissible: false,
    context: ctxt,
    builder: (BuildContext context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text('Confirmation'),
          content: Text(
            isEntree
                ? 'Enregistrer une entrée pour ${visite.nom} ${visite.prenoms} ?'
                : 'Enregistrer une sortie pour ${visite.nom} ${visite.prenoms} ?',
            textAlign: TextAlign.left,
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: cancel,
              child: Text(
                'Annuler',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.destructiveRed,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: confirm,
              child: Text(
                'Confirmer',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
          ],
        );
      } else {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Confirmation'),
          content: Text(
            isEntree
                ? 'Enregistrer une entrée pour ${visite.nom} ${visite.prenoms} ?'
                : 'Enregistrer une sortie pour ${visite.nom} ${visite.prenoms} ?',
            textAlign: TextAlign.left,
          ),
          contentPadding: const EdgeInsets.only(
            top: 5.0,
            right: 15.0,
            left: 15.0,
          ),
          titlePadding: const EdgeInsets.only(
            top: 10,
            left: 15,
          ),
          actions: [
            TextButton(
              onPressed: cancel,
              child: Text(
                'Annuler',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 198, 51, 41),
                ),
              ),
            ),
            TextButton(
              onPressed: confirm,
              child: Text(
                'Confirmer',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Palette.primaryColor,
                ),
              ),
            ),
          ],
        );
      }
    },
  );
}
