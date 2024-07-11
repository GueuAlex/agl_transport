import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../model/qr_code_model.dart';
import '../../../widgets/all_sheet_header.dart';
import '../../../widgets/custom_button.dart';
import '../../draggable_menu.dart';
import '../scanner/widgets/error_sheet_container.dart';
import '../scanner/widgets/infos_column.dart';
import '../scanner/widgets/sheet_container.dart';
import '../side_bar/open_side_dar.dart';

class VerifyByCodeSheet extends StatefulWidget {
  static const routeName = 'verifyByCodeSheet';
  const VerifyByCodeSheet({
    super.key,
  });

  @override
  State<VerifyByCodeSheet> createState() => _VerifyByCodeSheetState();
}

class _VerifyByCodeSheetState extends State<VerifyByCodeSheet> {
  ////////////////
  ///
  AudioCache player = AudioCache();
  ///////////////:
  ///
  bool showLabel1 = true;
  final TextEditingController codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final String prefix = 'AG-';
    final Widget codeTextField = TextField(
      controller: codeController,
      keyboardType: TextInputType.text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      onTap: () {
        setState(() {
          showLabel1 = false;
        });
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefix: AppText.medium(prefix),
        label: showLabel1
            ? AppText.medium('Entrer le code de vérification')
            : Container(),
        border: InputBorder.none,
      ),
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: const OpenSideBar(),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: Palette.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    //const AllSheetHeader(),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          AppText.medium('Vérifier le code'),
                          AppText.small(
                            'Utiliser le code pour afficher les infos du visiteur',
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 35, left: 35, top: 30),
                            child: InfosColumn(
                              height: 50,
                              opacity: 0.2,
                              label: 'Code',
                              widget: Expanded(
                                child: codeTextField,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 35, left: 35, top: 10),
                            child: CustomButton(
                              color: Palette.primaryColor,
                              width: double.infinity,
                              height: 35,
                              radius: 5,
                              text: 'Vérifier',
                              onPress: () {
                                if (codeController.text.trim().isEmpty) {
                                  Functions.showToast(
                                    msg: 'Le champ code est obligatoire !',
                                  );
                                } else {
                                  final codePattern = RegExp(r'^AG-\d{2}-\d+$');
                                  ;
                                  String code = '$prefix${codeController.text}';
                                  QrCodeModel? qrCodeModel;
                                  if (codePattern.hasMatch(code)) {
                                    for (QrCodeModel element
                                        in QrCodeModel.qrCodeList) {
                                      if (element.codeAssociate == code) {
                                        qrCodeModel = element;
                                      }
                                    }

                                    if (qrCodeModel != null) {
                                      player.play('images/soung.mp3');
                                      Functions.showBottomSheet(
                                        ctxt: context,
                                        widget: SheetContainer(
                                          qrValue: qrCodeModel.id.toString(),
                                        ),
                                      );
                                    } else {
                                      ///////////////////////
                                      ///sinon on fait vibrer le device
                                      ///et on afficher un message d'erreur
                                      ///
                                      Vibration.vibrate(duration: 200);
                                      Functions.showBottomSheet(
                                        ctxt: context,
                                        widget: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          decoration: BoxDecoration(
                                            color: Palette.whiteColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              AllSheetHeader(),
                                              Functions.widget404(
                                                size: size,
                                                ctxt: context,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    ///////////////////////
                                    ///sinon on fait vibrer le device
                                    ///et on afficher un message d'erreur
                                    ///
                                    Vibration.vibrate(duration: 200);
                                    Functions.showBottomSheet(
                                      ctxt: context,
                                      widget: const ErrorSheetContainer(
                                          text: 'Code Invalide!'),
                                    );
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          DraggableMenu()
        ],
      ),
    );
  }
}
