import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

import '../../../config/functions.dart';
import '../../../config/overlay.dart';
import '../../../config/palette.dart';
import '../../../emails/emails_service.dart';
import '../../../model/agent_model.dart';
import '../../../model/visite_model.dart';
import '../../../remote_service/remote_service.dart';
import '../../../widgets/all_sheet_header.dart';
import 'error_sheet_container.dart';
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
  AgentModel? _agent;
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
  final AudioPlayer player = AudioPlayer();
  ///////////////////////
  ///
  @override
  void dispose() {
    player.dispose();
    widget.mobileScannerController.dispose();
    super.dispose();
  }

  void _fetchAgent() async {
    _agent = await Functions.fetchAgent();
  }

  @override
  void initState() {
    _fetchAgent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        MobileScanner(
          controller: widget.mobileScannerController,
          allowDuplicates: true,
          ////////////////
          // onDetect: fonction lancée lorsqu'un rq code est
          // detecté par la cam
          ////////////////////
          onDetect: (barcodes, args) async {
            if (!isScanCompleted) {
              ////////////////
              /// code =  données que le qrcode continet
              String code = barcodes.rawValue ?? '...';
              // print('qr code value is : $code');
              //////////////
              final codePattern = RegExp(r'^AGL-\d{2}-\d+$');

              /// booleen permettant de connaitre l'etat
              /// du process de scanning
              isScanCompleted = true;
              //////////////////////////
              /// on attend un int
              /// donc on int.tryParse code pour etre sur de
              /// son type
              // int? id = int.tryParse(code);
              if (codePattern.hasMatch(code)) {
                EasyLoading.show();

                await player.play(AssetSource('images/soung.mp3'));

                try {
                  // Récupération de la visite avec le code
                  VisiteModel? visite = await VisiteModel.getVisite(code: code);

                  if (visite != null) {
                    // Visite trouvée, jouer le son et afficher le bottom sheet

                    Functions.showBottomSheet(
                      ctxt: context,
                      widget: SheetContainer(visite: visite, agent: _agent!),
                    ).whenComplete(() {
                      //Future.delayed(const Duration(seconds: 3)).then((_) {
                      setState(() {
                        isScanCompleted = false;
                      });
                      //});
                    });
                  } else {
                    // Si la visite n'est pas trouvée, envoyer une requête à l'API
                    var postData = {"code_visite": code};

                    http.Response r = await RemoteService()
                        .postData(
                            endpoint: 'visiteurs/verifications',
                            postData: postData)
                        .timeout(const Duration(seconds: 10));

                    if (r.statusCode == 200 || r.statusCode == 210) {
                      // Visite trouvée via l'API
                      VisiteModel visite = visiteModelFromJson(r.body);
                      Functions.showBottomSheet(
                        ctxt: context,
                        widget: SheetContainer(visite: visite, agent: _agent!),
                      ).whenComplete(() {
                        // Future.delayed(const Duration(seconds: 3)).then((_) {
                        setState(() {
                          isScanCompleted = false;
                        });
                        //});
                      });
                    } else {
                      // Erreur de réponse API, envoyer un email d'erreur et afficher une alerte
                      sendErrorEmail(
                        subject: 'Erreur lors d\'un scan',
                        title:
                            'Un qr code  a été scanné mais aucune visite trouvée\n\n',
                        errorDetails: 'Code: $code',
                      );
                      await _error(size: size);
                      setState(() {
                        isScanCompleted = false;
                      });
                    }
                  }
                } on TimeoutException catch (t) {
                  // Gestion de l'exception Timeout
                  Functions.showToast(
                      msg: 'Problème de connexion internet',
                      gravity: ToastGravity.TOP);
                  sendErrorEmail(
                    subject: 'Erreur lors d\'une vérification',
                    title:
                        'Une requête a pris trop de temps dû une connexio lente\n\n',
                    errorDetails:
                        'Code: $code\n\nErreur: ${t.message.toString()}',
                  );
                } on http.ClientException catch (e) {
                  // Gestion des erreurs réseau
                  Functions.showToast(
                    msg: 'Problème de connexion internet',
                    gravity: ToastGravity.TOP,
                  );
                  sendErrorEmail(
                    subject: 'Erreur lors d\'un scan',
                    title: 'Une requête a échoué dû à une connexio lente\n\n',
                    errorDetails:
                        'Code: $code\n\nErreur: ${e.message.toString()}',
                  );
                } catch (e) {
                  // Gestion des autres exceptions
                  Functions.showToast(
                      msg: 'Problème de connexion internet',
                      gravity: ToastGravity.TOP);
                  sendErrorEmail(
                    subject: 'Erreur lors d\'un scan',
                    title: 'Un problème est survenu\n\n',
                    errorDetails: 'Code: $code\n\nErreur: ${e.toString()}',
                  );
                } finally {
                  // Toujours arrêter EasyLoading
                  EasyLoading.dismiss();
                }
              }

              ///
              /////////////////////////////

              else {
                ///////////////////////
                ///sinon on fait vibrer le device
                ///et on afficher un message d'erreur
                ///
                Vibration.vibrate(duration: 200);
                sendErrorEmail(
                  subject: 'Erreur lors d\'un scan',
                  title: 'Un Qr code invalide à été scanné\n\n',
                  errorDetails: 'Code: $code',
                );
                Functions.showBottomSheet(
                  ctxt: context,
                  widget: const ErrorSheetContainer(
                    text: 'Qr code invalide !',
                  ),
                ).whenComplete(() {
                  // Future.delayed(const Duration(seconds: 5)).then((_) {
                  setState(() {
                    isScanCompleted = false;
                  });
                  //});
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

  //
  Future<void> _error({required Size size}) async {
    ///////////////////////
    ///sinon on fait vibrer le device
    ///et on afficher un message d'erreur
    ///
    Vibration.vibrate(duration: 200);
    return Functions.showBottomSheet(
      ctxt: context,
      widget: Container(
        height: MediaQuery.of(context).size.height / 2,
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
}
