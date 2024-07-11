/* import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../config/app_text.dart';
import '../../widgets/copy_rigtht.dart';

afeArea()=> SafeArea(
            child: SizedBox(
              width: double.infinity,
              //padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText.medium('Placez le code QR dans la zone'),
                        AppText.small('La numérisation démarre automatiquement')
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        MobileScanner(
                          controller: mobileScannerController,
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
                                  Future.delayed(const Duration(seconds: 5))
                                      .then((_) {
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
                                  Future.delayed(const Duration(seconds: 5))
                                      .then((_) {
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
                        const QRScannerOverlay(overlayColour: Colors.white)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      width: double.infinity,
                      //color: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: () {
                                          setState(() {
                                            isFlashOn = !isFlashOn;
                                          });
                                          mobileScannerController.toggleTorch();
                                        },
                                        child: ActionButton(
                                          child: 'assets/icons/flash_on.svg',
                                          isOn: isFlashOn,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: () {
                                          setState(() {
                                            isFontCamera = !isFontCamera;
                                          });
                                          mobileScannerController.switchCamera();
                                        },
                                        child: ActionButton(
                                          child: 'assets/icons/rotate_camera.svg',
                                          isOn: isFontCamera,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                AppText.medium('ou'),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, right: 35, left: 35),
                                  child: CustomButton(
                                    color: Palette.primaryColor,
                                    width: double.infinity,
                                    height: 35,
                                    radius: 5,
                                    isSetting: true,
                                    fontsize:
                                        MediaQuery.of(context).size.width * 0.03,
                                    text: 'Utiliser un code de vérification',
                                    onPress: () async {
                                      setState(() {
                                        showLabel1 = true;
                                      });
            
                                      Navigator.of(context).pushNamed(
                                        VerifyByCodeSheet.routeName,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            //height: 130,
                            width: double.infinity,
                            decoration: const BoxDecoration(),
                            child: const CopyRight(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ), */