import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner/screens/scanner/widgets/error_sheet_container.dart';
import 'package:vibration/vibration.dart';

import '../../../config/functions.dart';
import '../../../config/overlay.dart';
import 'sheet_container.dart';

class ScannerContainer extends StatefulWidget {
  const ScannerContainer({
    super.key,
    required this.mobileScannerController,
  });
  final MobileScannerController mobileScannerController;

  @override
  State<ScannerContainer> createState() => _ScannerContainerState();
}

class _ScannerContainerState extends State<ScannerContainer> {
  bool isScanCompleted = false;
  //bool isFlashOn = false;
  //bool isFontCamera = false;
  //bool isTextFieldVisible = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  //bool showLabel1 = true;
  //final TextEditingController codeController = TextEditingController();

  //////////////////
  void closeScreen() {
    isScanCompleted = false;
  }

  ////////////////
  ///
  AudioCache player = AudioCache();
  ///////////////////////
  ///
  @override
  void dispose() {
    widget.mobileScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: widget.mobileScannerController,
          allowDuplicates: true,
          ////////////////
          // onDetect: fonction lancée lorsqu'un rq code est
          // detecté par la cam
          ////////////////////
          onDetect: (barcodes, args) {
            if (!isScanCompleted) {
              ////////////////
              /// code =  données que le qrcode continet
              String code = barcodes.rawValue ?? '...';
              print('qr code value is : $code');
              //////////////
              /// booleen permettant de connaitre l'etat
              /// du process de scanning
              isScanCompleted = true;
              //////////////////////////
              /// on attend un int
              /// donc on int.tryParse code pour etre sur de
              /// son type
              int? id = int.tryParse(code);

              ///
              /////////////////////////////
              ///id represente l'id du qrcode dans notre DB
              /// si id n'est pas null, on envoie id
              /// a SheetContainer .....
              if (id != null) {
                player.play('images/soung.mp3');
                Functions.showBottomSheet(
                  ctxt: context,
                  widget: SheetContainer(qrValue: code),
                ).whenComplete(() {
                  Future.delayed(const Duration(seconds: 5)).then((_) {
                    setState(() {
                      isScanCompleted = false;
                    });
                  });
                });
              } else {
                ///////////////////////
                ///sinon on fait vibrer le device
                ///et on afficher un message d'erreur
                ///
                Vibration.vibrate(duration: 200);
                Functions.showBottomSheet(
                  ctxt: context,
                  widget: const ErrorSheetContainer(
                    text: 'Qr code invalide !',
                  ),
                ).whenComplete(() {
                  Future.delayed(const Duration(seconds: 5)).then((_) {
                    setState(() {
                      isScanCompleted = false;
                    });
                  });
                });
              }

              ///////////////////
              /// finalement on temporise 5s et
              /// on initialise (isScanCompleted) a false
              /// pour permettre un scan
            }
          },
        ),
        const QRScannerOverlay(overlayColour: Colors.white),
      ],
    );
  }
}
