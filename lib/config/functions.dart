import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../local_service/local_service.dart';
import '../model/agent_model.dart';
import '../model/entreprise_model.dart';
import '../model/livraison_model.dart';
import '../model/localisation_model.dart';
import '../model/scan_history_model.dart';
import '../model/visite_model.dart';
import '../remote_service/remote_service.dart';
import '../widgets/custom_button.dart';
import 'app_text.dart';
import 'palette.dart';

class Functions {
  static void showSnackBar(
      {required BuildContext ctxt, required String messeage}) {
    ScaffoldMessenger.of(ctxt).showSnackBar(
      SnackBar(
        content: AppText.medium(
          messeage,
          color: Colors.white70,
        ),
        duration: const Duration(seconds: 3),
        elevation: 5,
      ),
    );
  }

  /// bottom sheet preconfiguré
  static Future<void> showBottomSheet({
    required BuildContext ctxt,
    required Widget widget,
  }) async {
    return await showModalBottomSheet(
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      context: ctxt,
      builder: (context) {
        return widget;
      },
    );
  }

// gift de chargement
  static showLoadingSheet({required BuildContext ctxt}) {
    return showDialog(
      context: ctxt,
      //backgroundColor: Colors.transparent,
      builder: (ctxt) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(ctxt).size.height,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Image.asset('assets/images/loading.gif'),
              ),
              const SizedBox(
                height: 230,
              )
            ],
          ),
        );
      },
    );
  }

  static DateTime getToday() {
    // renvoi la date du jour
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
  }

  static bool isToday(DateTime dateStr) {
    // Parse the input date string to a DateTime object
    //DateTime inputDate = DateTime.parse(dateStr);

    // Get today's date
    DateTime today = DateTime.now();

    // Compare the input date with today's date
    return dateStr.year == today.year &&
        dateStr.month == today.month &&
        dateStr.day == today.day;
  }

  /// renvoi un widget avec a l'intérieur un érreur 404
  static Widget widget404({required Size size, required BuildContext ctxt}) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      //height: size.height / 1.5,
      width: size.width,
      child: Center(
        child: Column(
          children: [
            Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset('assets/icons/404.svg'),
            ),
            //AppText.medium('Not found !'),
            AppText.small('Aucune correspondance !'),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              color: Palette.primaryColor,
              width: double.infinity,
              height: 35,
              radius: 5,
              text: 'Retour',
              onPress: () => Navigator.pop(ctxt),
            )
          ],
        ),
      ),
    );
  }

// Retourne une liste des visites où le QR code est déjà scanné en se basant
// sur la liste des historiques de scan
  static Future<List<VisiteModel>> getScannedQrCode({
    required List<ScanHistoryModel> scanList,
  }) async {
    Set<VisiteModel> qrs = {};
    List<VisiteModel> allVisites = await VisiteModel.visites;

    for (VisiteModel qrCodes in allVisites) {
      for (ScanHistoryModel element in scanList) {
        if (qrCodes.id == element.visiteId) {
          qrs.add(qrCodes);
        }
      }
    }
    return qrs.toList();
  }

// Retourne la liste des historiques de scan
// en se basant sur selectedDate
  static Future<List<ScanHistoryModel>> getSelectedDateScanHistory({
    required DateTime selectedDate,
  }) async {
    // AgentModel? _agent = await Functions.fetchAgent();
    List<ScanHistoryModel> scanList = [];
    List<ScanHistoryModel> allScanHistories =
        await ScanHistoryModel.scanHistories;

    for (ScanHistoryModel element in allScanHistories) {
      if (element.scandDate.year == selectedDate.year &&
          element.scandDate.month == selectedDate.month &&
          element.scandDate.day == selectedDate.day) {
        scanList.add(element);
      }
    }
    return scanList;
  }

  static List<Livraison> getSelectedDateLivraisons({
    required DateTime selectedDate,
    String status = 'en cours',
  }) {
    print('selectedDate : ${selectedDate}');
    List<Livraison> deliList = [];
    deliList.clear();
    for (Livraison element in Livraison.livraisonList) {
      print(element.dateLivraison);
      if (element.dateLivraison == selectedDate &&
          element.status != 'en attente' &&
          element.status == status) {
        deliList.add(element);
      }
    }
    return deliList;
  }

  // met a jour un qr code
  static Future<dynamic> upDateVisit({
    required Map<String, dynamic> data,
    required int visiteId,
  }) async {
    await RemoteService().putSomethings(
      api: 'visiteurs/${visiteId}',
      data: data,
    );
  }

  // met a jour un user
  static Future<dynamic> updateUser({
    required Map<String, dynamic> data,
    required int userId,
  }) async {
    RemoteService().putSomethings(
      api: 'visiteurs/${userId}',
      data: data,
    );
  }

// post un nouveau historique de scan
  static Future<dynamic> postScanHistory(
      {required ScanHistoryModel scanHistoryModel}) async {
    RemoteService().postScanHistory(scanHistoryModel: scanHistoryModel);
  }

// retourne la liste des qr code depuis l'api
/*   static getQrcodesFromApi() async {
    QrCodeModel.qrCodeList = await RemoteService().getQrcodes();
  } */

// retourne l'historique des qr code depuis l'api
  /*  static getScanHistoriesFromApi() async {
    ScanHistoryModel.scanHistories = await RemoteService().getScanHistories();
  } */

  //retourne la liste de toutes les entreprise
  static allEntrepise() async {
    Entreprise.entrepriseList = await RemoteService().getEntrepriseList();
  }

  //retourne la liste de toutes les entreprise
  static Future<void> allLivrason() async {
    Livraison.livraisonList = await RemoteService().getLivraisonList();
  }

  /////////////////////////////////
  ///
  ///
  static Future<Null> IsAllRedyScanalert({
    required BuildContext ctxt,
    bool isEntree = true,
    required Function() confirm,
    required Function() cancel,
    required VisiteModel visite,
    required TextField carIdField,
  }) async {
    return showDialog(
        barrierDismissible: false,
        context: ctxt,
        builder: (BuildContext ctxt) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text('Confirmation'),
              content: ConstrainedBox(
                constraints: BoxConstraints.expand(height: isEntree ? 90 : 30),
                child: Column(
                  children: [
                    Expanded(
                      child: AppText.small(
                        isEntree
                            ? 'Saisire la plaque d\'immatriculation si ${visite.nom} est véhiculé sinon laissez le champs vide'
                            : 'Veuillez confirmer la sortie de ${visite.nom}',
                        textAlign: TextAlign.center,
                        fontSize: 10,
                      ),
                    ),
                    isEntree
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            margin: const EdgeInsets.only(top: 5),
                            width: double.infinity,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: carIdField,
                          )
                        : Container(),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: confirm,
                  child: Text(
                    'Confirmer',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: cancel,
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.destructiveRed,
                    ),
                  ),
                )
              ],
            );
          } else {
            return AlertDialog(
              backgroundColor: Colors.grey.shade200,
              title: AppText.medium(
                'Confirmation',
                fontSize: 12,
              ),
              /* content: AppText.small(
            isEntree
                ? 'Enregistrer une entrée pour ${user.nom} ${user.prenoms} ?'
                : 'Enregistrer une sortie pour ${user.nom} ${user.prenoms} ?',
            textAlign: TextAlign.left,
          ), */
              content: ConstrainedBox(
                constraints: BoxConstraints.expand(height: isEntree ? 70 : 30),
                child: Column(
                  children: [
                    Expanded(
                      child: AppText.small(
                        isEntree
                            ? 'Saisire la plaque d\'immatriculation si ${visite.nom} est véhiculé sinon laissez le champs vide'
                            : 'Veuillez confirmer la sortie de ${visite.nom}',
                        textAlign: TextAlign.center,
                        fontSize: 10,
                      ),
                    ),
                    isEntree
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            margin: const EdgeInsets.only(top: 5),
                            width: double.infinity,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: carIdField,
                          )
                        : Container(),
                  ],
                ),
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
                  onPressed: confirm,
                  child: AppText.small(
                    'Confirmer',
                    fontWeight: FontWeight.w500,
                    color: Palette.primaryColor,
                  ),
                ),
                TextButton(
                  onPressed: cancel,
                  child: AppText.small(
                    'Annuler',
                    fontWeight: FontWeight.w500,
                    color: Palette.primaryColor,
                  ),
                )
              ],
            );
          }
        });
  }

  static showToast({
    required String msg,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: Palette.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Widget getTextField(
      {required TextEditingController controller,
      bool isActive = true,
      int? maxLines = 1}) {
    return TextField(
      enabled: isActive,
      maxLines: maxLines,
      controller: controller,
      keyboardType: TextInputType.text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
    );
  }

  //
  static Future<AgentModel?> fetchAgent() async {
    final userMap = await LocalService().getUser();
    if (userMap != null) {
      AgentModel _agent = AgentModel(
        id: userMap['id'],
        name: userMap['name'],
        email: userMap['email'],
        telephone: userMap['telephone'],
        actif: userMap['actif'] == 1,
        matricule: userMap['matricule'],
        localisationId: userMap['localisation_id'],
        avatar: userMap['avatar'],
        localisation: LocalisationModel(
          id: userMap['localisation_id'],
          siteId: userMap['localisation_id'],
          libelle: userMap['localisation_name'],
        ),
      );
      return _agent;
    } else {
      return null;
    }
  }

  static Future<void> showPlatformDialog({
    required BuildContext context,
    required VoidCallback onCancel,
    required VoidCallback onConfirme,
    required Widget title,
    required Widget content,
  }) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: title,
            content: content,
            actions: [
              CupertinoDialogAction(
                onPressed: onCancel,
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    color: CupertinoColors.systemRed,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: onConfirme,
                child: Text(
                  'Confirmer',
                  style: TextStyle(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title,
            content: content,
            actions: [
              TextButton(
                onPressed: onCancel,
                child: Text('Annuler', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: onConfirme,
                child: Text(
                  'Confirmer',
                  style: TextStyle(
                    color: Palette.primaryColor,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
