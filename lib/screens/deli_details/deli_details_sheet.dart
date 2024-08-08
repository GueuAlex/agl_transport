import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../config/app_text.dart';
import '../../config/functions.dart';
import '../../config/palette.dart';
import '../../model/agent_model.dart';
import '../../model/tracteur_modal.dart';
import '../../remote_service/remote_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/sheet_closer.dart';
import '../scanner/widgets/infos_column.dart';
import 'full_details.dart';
import 'row_box.dart';
import 'shipping_info.dart';

class DeliDetailSheet extends StatefulWidget {
  final DeliDetailsModel deli;
  //final bool isFinish;
  const DeliDetailSheet({required this.deli, super.key});

  @override
  State<DeliDetailSheet> createState() => _DeliDetailSheetState();
}

class _DeliDetailSheetState extends State<DeliDetailSheet> {
  bool isRegisterProcess = false;
  TextEditingController _noteController = TextEditingController();
  TextEditingController _badgeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isFinish =
        widget.deli.livraison.status.trim().toLowerCase() == 'terminée';

    return Container(
      height: size.height / 1.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Column(
        children: [
          SheetCloser(),
          ShippingInfo(
            tracteurNum: widget.deli.numeroTracteur,
            remorqueNum: widget.deli.livraison.numeroRemorque,
          ),
          Expanded(
            child: !isRegisterProcess
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: AppText.medium(
                              'Colis, Entreprise & Lieu',
                              color: Color.fromARGB(255, 40, 40, 40),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: BoxRow(
                              deli: widget.deli,
                            ),
                          ),
                          const SizedBox(height: 5),
                          FullDetails(deli: widget.deli),
                          const SizedBox(height: 25),
                          !isFinish
                              ? CustomButton(
                                  color: Palette.primaryColor,
                                  width: double.infinity,
                                  height: 35,
                                  radius: 5,
                                  text: 'Livraison terminée ?',
                                  onPress: () {
                                    setState(
                                      () {
                                        isRegisterProcess = true;
                                      },
                                    );
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.medium('Quelque chose à noter ?'),
                          AppText.small(
                            'Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page ',
                          ),
                          const SizedBox(height: 15),
                          InfosColumn(
                            height: 95,
                            opacity: 0.12,
                            label: 'Écrire une note',
                            widget: Expanded(
                              child: Functions.getTextField(
                                maxLines: 5,
                                controller: _noteController,
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  color: Colors.red.withOpacity(0.05),
                                  width: double.infinity,
                                  height: 35,
                                  radius: 5,
                                  text: 'Annuler',
                                  textColor: Colors.red,
                                  onPress: () => setState(() {
                                    isRegisterProcess = false;
                                  }),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomButton(
                                    color: Palette.primaryColor,
                                    width: double.infinity,
                                    height: 35,
                                    radius: 5,
                                    text: 'Valider',
                                    onPress: () {
                                      //Navigator.pop(context);
                                      Functions.showPlatformDialog(
                                        context: context,
                                        onCancel: () => Navigator.pop(context),
                                        onConfirme: () {
                                          _handleDeliOut();
                                        },
                                        title: AppText.medium(
                                          'Confirmation',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              AppText.small(
                                                'Veuillez saisir le numéro du badge si le livreur en dispose',
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 5),
                                              InfosColumn(
                                                opacity: 0.12,
                                                label: 'N° badge',
                                                widget: Expanded(
                                                  child: Functions.getTextField(
                                                    controller:
                                                        _badgeController,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  ////
  _handleDeliOut() async {
    Navigator.pop(context);
    EasyLoading.show();
    String hours = DateFormat('HH:mm', 'fr_FR').format(
      DateTime.now(),
    );

    AgentModel? _agent = await Functions.fetchAgent();
    if (_agent == null) {
      Functions.showToast(
        msg: 'Veuillez une erreur s\'est produite',
        gravity: ToastGravity.TOP,
      );
      return;
    }

    // UPDDATE LIVRAISON
    Map<String, dynamic> _payload = {
      "heure_sortie": hours,
      "status": "Terminée",
    };

    // CREATE HISTORY
    Map<String, dynamic> _livraisonCount = {
      "livraison_id": widget.deli.livraison.id,
      "user_id": _agent.id,
      "scan_date": DateTime.now().toIso8601String(),
      "scan_hour": hours,
      "motif": "Sortie",
      "plaque_immatriculation": widget.deli.numeroTracteur,
      "commentaire": _noteController.text,
      "numero_badge": _badgeController.text,
    };

    await RemoteService()
        .putSomethings(
      api: 'livraisons/${widget.deli.livraison.id}',
      data: _payload,
    )
        .whenComplete(() {
      RemoteService()
          .postData(endpoint: 'scanLivraisons', postData: _livraisonCount)
          .whenComplete(() {
        EasyLoading.dismiss();
        Functions.showToast(
          msg: 'Enregistrement effectué avec succès',
          gravity: ToastGravity.TOP,
        );
        setState(() {
          //_widgetDeli!.statutLivraison = true;
          widget.deli.livraison.status = 'Terminée';
        });
        Navigator.pop(context);
      });
    });
  }
}
