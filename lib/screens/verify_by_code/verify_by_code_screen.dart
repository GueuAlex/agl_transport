import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../widgets/all_sheet_header.dart';
import '../../../widgets/custom_button.dart';
import '../../draggable_menu.dart';
import '../../emails/emails_service.dart';
import '../../model/agent_model.dart';
import '../../model/visite_model.dart';
import '../../remote_service/remote_service.dart';
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
  AgentModel? _agent;
  ////////////////
  ///
  final AudioPlayer player = AudioPlayer();
  ///////////////:
  ///
  bool showLabel1 = true;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    _fetchAgent();
    super.initState();
  }

  void _fetchAgent() async {
    _agent = await Functions.fetchAgent();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String prefix = 'AGL-';
    final Widget codeTextField = TextField(
      controller: _codeController,
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
                              onPress: () async {
                                // Vérifier si le champ code est vide
                                if (_codeController.text.trim().isEmpty) {
                                  Functions.showToast(
                                      msg: 'Le champ code est obligatoire !');
                                  return;
                                }

                                final codePattern = RegExp(r'^AGL-\d{2}-\d+$');
                                String code = '$prefix${_codeController.text}';

                                // Vérifier si le code correspond au pattern attendu
                                if (!codePattern.hasMatch(code)) {
                                  // Code invalide, affichage d'un message d'erreur et vibration
                                  EasyLoading.dismiss();
                                  Vibration.vibrate(duration: 200);
                                  Functions.showBottomSheet(
                                    ctxt: context,
                                    widget: const ErrorSheetContainer(
                                        text: 'Code Invalide!'),
                                  );
                                  return;
                                }

                                // Affichage du chargement
                                EasyLoading.show();

                                await player
                                    .play(AssetSource('images/soung.mp3'));

                                try {
                                  // Récupération de la visite avec le code
                                  VisiteModel? visite =
                                      await VisiteModel.getVisite(code: code);

                                  if (visite != null) {
                                    // Visite trouvée, jouer le son et afficher le bottom sheet

                                    Functions.showBottomSheet(
                                      ctxt: context,
                                      widget: SheetContainer(
                                          visite: visite, agent: _agent!),
                                    );
                                  } else {
                                    // Si la visite n'est pas trouvée, envoyer une requête à l'API
                                    var postData = {"code_visite": code};

                                    http.Response r = await RemoteService()
                                        .postData(
                                            endpoint: 'visiteurs/verifications',
                                            postData: postData)
                                        .timeout(const Duration(seconds: 10));

                                    if (r.statusCode == 200 ||
                                        r.statusCode == 210) {
                                      // Visite trouvée via l'API
                                      VisiteModel visite =
                                          visiteModelFromJson(r.body);
                                      Functions.showBottomSheet(
                                        ctxt: context,
                                        widget: SheetContainer(
                                            visite: visite, agent: _agent!),
                                      );
                                    } else {
                                      // Erreur de réponse API, envoyer un email d'erreur et afficher une alerte
                                      sendErrorEmail(
                                        subject:
                                            'Erreur lors d\'une vérification',
                                        title:
                                            'Un code de visite a été utilisé pour une vérification mais aucune visite trouvée\n\n',
                                        errorDetails: 'Code: $code',
                                      );
                                      _error(size: size);
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
                                    subject: 'Erreur lors d\'une vérification',
                                    title:
                                        'Une requête a échoué dû une connexio lente\n\n',
                                    errorDetails:
                                        'Code: $code\n\nErreur: ${e.message.toString()}',
                                  );
                                } catch (e) {
                                  // Gestion des autres exceptions
                                  Functions.showToast(
                                      msg: 'Problème de connexion internet',
                                      gravity: ToastGravity.TOP);
                                  sendErrorEmail(
                                    subject: 'Erreur lors d\'une vérification',
                                    title: 'Un problème est survenu\n\n',
                                    errorDetails:
                                        'Code: $code\n\nErreur: ${e.toString()}',
                                  );
                                } finally {
                                  // Toujours arrêter EasyLoading
                                  EasyLoading.dismiss();
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

  void _error({required Size size}) {
    ///////////////////////
    ///sinon on fait vibrer le device
    ///et on afficher un message d'erreur
    ///
    Vibration.vibrate(duration: 200);
    Functions.showBottomSheet(
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
