import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scanner/model/visite_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../local_service/local_service.dart';
import '../../../model/DeviceModel.dart';
import '../../../model/agent_model.dart';
import '../../../remote_service/remote_service.dart';
import '../../../widgets/all_sheet_header.dart';
import '../../../widgets/custom_button.dart';
import 'alert_agl.dart';
import 'infos_column.dart';

class SingleVisitor extends StatefulWidget {
  const SingleVisitor({
    super.key,
    required this.visite,
    required this.agent,
  });
  final VisiteModel visite;
  final AgentModel agent;
  @override
  State<SingleVisitor> createState() => _SingleVisitorState();
}

class _SingleVisitorState extends State<SingleVisitor> {
  DateTime _today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  String _hours = DateFormat('HH:mm').format(DateTime.now());

  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _carIdController = TextEditingController();
  final TextEditingController _bageController = TextEditingController();
  final TextEditingController _giletController = TextEditingController();
  int _switchIndex = 0;
  String _idCardType = '';
  @override
  void initState() {
    _idCardType = widget.visite.typePiece;
    _idCardController.text = widget.visite.numeroCni;
    super.initState();
  }

  @override
  void dispose() {
    _bageController.dispose();
    _idCardController.dispose();
    _carIdController.dispose();
    _giletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfosColumn(
                label: 'Date début',
                widget: AppText.medium(
                  DateFormat(
                    'dd MMM yyyy',
                    'fr_FR',
                  ).format(
                    widget.visite.dateVisite,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InfosColumn(
                label: 'Heure d\'entrée',
                widget: AppText.medium(
                  widget.visite.heureVisite ?? '',
                ),
              ),
            ),
          ],
        ), //

        Row(
          children: [
            Expanded(
              child: InfosColumn(
                radius: 0,
                opacity: 0.12,
                label: 'n° de pièce',
                widget: Expanded(
                  child: Functions.getTextField(
                    controller: _idCardController,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InfosColumn(
                radius: 0,
                opacity: 0.12,
                label: 'Type de pièce',
                widget: Expanded(
                  child: InkWell(
                    onTap: () => Functions.showBottomSheet(
                      ctxt: context,
                      widget: _idCardTypeSelector(),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: AppText.medium(_idCardType)),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InfosColumn(
                radius: 0,
                opacity: 0.12,
                label: 'n° d\'immatriculation véhicule',
                widget: Expanded(
                  child: Functions.getTextField(
                    controller: _carIdController,
                  ),
                ),
              ),
            ),
          ],
        ),
        //
        Container(
          width: double.infinity,
          height: 0.8,
          color: Palette.separatorColor,
        ),
        const SizedBox(
          height: 10,
        ),
        ToggleSwitch(
          cornerRadius: 7.0,
          minWidth: 120,
          minHeight: 40,
          initialLabelIndex: _switchIndex,
          totalSwitches: 2,
          //labels: ['Avec baget', 'Sans baget'],
          customWidgets: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 30,
              decoration: BoxDecoration(
                color: _switchIndex == 0
                    ? Palette.primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: AppText.medium(
                'Avec badge',
                color: _switchIndex == 0 ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 30,
              decoration: BoxDecoration(
                color: _switchIndex == 1
                    ? Palette.primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: AppText.medium(
                'Sans badge',
                color: _switchIndex == 1 ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
          ],
          inactiveBgColor: Palette.separatorColor,
          activeBgColor: [Palette.separatorColor],
          onToggle: (index) {
            //print('switched to: $index');
            setState(() {
              _switchIndex = index!;
            });
          },
        ),
        if (_switchIndex == 0)
          Column(
            children: [
              const SizedBox(height: 15),
              AppText.medium(
                'Accessoires de visite',
                textAlign: TextAlign.center,
              ),
              AppText.small(
                textAlign: TextAlign.center,
                'Veuillez fournir au visiteur les accessoires de visite (badge et gilet) si necessaire',
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            radius: 0,
                            opacity: 0.12,
                            label: 'Entrer le n° du badge',
                            widget: Expanded(
                              child: Functions.getTextField(
                                  controller: _bageController),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            radius: 0,
                            opacity: 0.12,
                            label: 'Entrer le n° du gilet',
                            widget: Expanded(
                              child: Functions.getTextField(
                                  controller: _giletController),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        const SizedBox(
          height: 40,
        ),

        ///
        CustomButton(
          color: Palette.primaryColor,
          width: double.infinity,
          height: 35,
          radius: 5,
          text: 'Sauvegarder le scan',
          //////////////////////////////////////////////////
          ///on a besoin update le n° CNI et le n° d'immatricule du user
          ///anisi l'attribut iSAlreadyScanned du qr code qu'on vient de scanné
          onPress: () async {
            LocalService localService = LocalService();
            DeviceModel? _device = await localService.getDevice();
            if (_device == null) {
              Functions.showToast(
                msg: 'Une erreur s\'est produite',
                gravity: ToastGravity.TOP,
              );
              return;
            }
            if (_device.localisationId != widget.visite.localisation.id) {
              Functions.showToast(
                msg: 'Cette visite n\'a pas lieu ici !',
                gravity: ToastGravity.TOP,
              );
              return;
            }
            if (_idCardController.text.isEmpty) {
              Functions.showToast(
                msg: 'Le n° de pièce d\'identité est obligatoire !',
                gravity: ToastGravity.TOP,
              );
              return;
            }

            if (_switchIndex == 0) {
              if (_bageController.text.isEmpty) {
                Functions.showToast(
                  msg: 'Le n° du badge est obligatoire !',
                  gravity: ToastGravity.TOP,
                );
                return;
              }
            }
            ////////////////////////////////////////////////////////////
            //préparation des données pour update les tables visiteurs et scan_history
            ///
            ///PUT VISITE DATA
            Map<String, dynamic> visitData = {
              "is_already_scanned": 1,
              "numero_piece": _idCardController.text.toUpperCase(),
              /* "heure_visite": _hours, */
              "type_piece": _idCardType,
              "badge": _switchIndex == 0 ? 1 : 0
              //"numero_piece": iDController.text.toUpperCase(),
            };
            /////////////////////////
            ///

            ////////////
            ///SCAN HISTORY DATA
            Map<String, dynamic> scanHistoryData = {
              "visite_id": widget.visite.id,
              "user_id": widget.agent.id,
              "scan_date": _today.toIso8601String(),
              "scan_hour": _hours,
              "motif": "Entrée",
              "badge": _switchIndex == 0 ? 1 : 0,
              "numero_badge": _bageController.text.toUpperCase(),
              "numero_gilet": _giletController.text.toUpperCase(),
              "plaque_immatriculation": _carIdController.text.toUpperCase(),
            };

            alert(
              ctxt: context,
              visite: widget.visite,
              confirm: () async {
                // Functions.showLoadingSheet(ctxt: context);
                EasyLoading.show(status: 'sauvegarde en cours...');
                await Functions.upDateVisit(
                  data: visitData,
                  visiteId: widget.visite.id,
                ).whenComplete(() async {
                  await RemoteService()
                      .postData(
                    endpoint: 'scanCounters',
                    postData: scanHistoryData,
                  )
                      .then((res) {
                    //visite.plaqueVehicule = cariDController.text;

                    Future.delayed(const Duration(seconds: 2)).then(
                      (_) {
                        widget.visite.isAlreadyScanned = true;
                        widget.visite.numeroCni = _idCardController.text;
                        EasyLoading.dismiss();
                        //Get.back();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Functions.showToast(
                          msg: 'Scan sauvegardé !',
                          gravity: ToastGravity.TOP,
                        );
                      },
                    );
                  });
                });
              },
              cancel: () => Navigator.pop(context), //Get.back(),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        CustomButton(
          color: Palette.secondaryColor,
          width: double.infinity,
          height: 35,
          radius: 5,
          text: 'Annuler',
          onPress: () => Navigator.pop(context), //Get.back(),
        ),
      ],
    );
  }

  Container _idCardTypeSelector() {
    List<String> _pieces = [
      "CNI",
      "Permis",
      "Passeport",
      "Attestation",
    ];
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          )),
      child: Column(
        children: [
          AllSheetHeader(
            opacity: 0,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _pieces.map((piece) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _idCardType = piece;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 3,
                            color: piece == _idCardType
                                ? Palette.primaryColor
                                : Colors.white,
                          ),
                        ),
                      ),
                      child: AppText.medium(
                        piece.toUpperCase(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
