// widget retourné si un qr code a deja été scané
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scanner/model/scan_history_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../model/agent_model.dart';
import '../../../model/visite_model.dart';
import '../../../widgets/custom_button.dart';
import 'infos_column.dart';
import 'show_members_row.dart';
import 'uddate_scan_history.dart';

class IsAlreadyScaned extends StatefulWidget {
  const IsAlreadyScaned({
    super.key,
    required this.visite,
    required this.agent,
  });
  final VisiteModel visite;
  final AgentModel agent;

  @override
  State<IsAlreadyScaned> createState() => _IsAlreadyScanedState();
}

class _IsAlreadyScanedState extends State<IsAlreadyScaned> {
  final TextEditingController _badgeController = TextEditingController();
  final TextEditingController _giletController = TextEditingController();
  final TextEditingController _cariDController2 = TextEditingController();
  int _switchIndex = 0;
  @override
  void dispose() {
    _badgeController.dispose();
    _giletController.dispose();
    _cariDController2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initializeVisite();
    super.initState();
  }

  void _initializeVisite() {
    ScanHistoryModel? oldScan;

    // Vérifie si 'scanHistories' est vide avant d'accéder à l'élément 'last' ou 'lastWhere'
    if (widget.visite.scanHistories.isNotEmpty) {
      if (widget.visite.members.isEmpty) {
        oldScan = widget.visite.scanHistories.last;
      } else {
        oldScan = widget.visite.scanHistories
            .lastWhere((scan) => scan.isPrimaryVisitor == true);
      }
    } else {
      oldScan = null; // Ou toute autre valeur par défaut si nécessaire
    }

    // Si un scan valide est trouvé, mettre à jour les contrôleurs

    setState(() {
      _cariDController2.text = oldScan!.carId; // Gérer les nullités
      _giletController.text = oldScan.numeroGilet;
      // Si le visiteur est de type permanent, utiliser le numéro CNI pour le badge
      if (widget.visite.typeVisiteur.toLowerCase() == 'permanent') {
        _badgeController.text = widget.visite.numeroCni;
      } else {
        _badgeController.text = oldScan.numeroBaget;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPermanet = widget.visite.typeVisiteur.toLowerCase() == 'permanent';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 15,
        ),
        if (!isPermanet)
          Row(
            children: [
              Expanded(
                child: InfosColumn(
                  radius: 0,
                  //opacity: 0.12,
                  label: 'n° de pièce',
                  widget: AppText.medium(widget.visite.numeroCni),
                ),
              ),
              Expanded(
                child: InfosColumn(
                  radius: 0,
                  //opacity: 0.12,
                  label: 'Type de pièce',
                  widget: Expanded(
                    child: AppText.medium(widget.visite.typePiece),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 15),
        if (!isPermanet)
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
        const SizedBox(
          height: 20,
        ),
        if (_switchIndex == 0)
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: AppText.medium(
                  'Attention',
                  textAlign: TextAlign.center,
                ),
              ),
              AppText.small(
                "Rassurez-vous que le visiteur a bien reçu ses accessoires de visite (badge et/ou gilet) s'il s'agit d'une entrée ou s'il les a rendus s'il s'agit d'une sortie.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InfosColumn(
                      opacity: 0.12,
                      label: 'Entrer le n° du badge',
                      widget: Expanded(
                        child: Functions.getTextField(
                          controller: _badgeController,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: InfosColumn(
                      opacity: 0.12,
                      label: 'Entrer le n° du gilet',
                      widget: Expanded(
                        child: Functions.getTextField(
                          controller: _giletController,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        const SizedBox(height: 20),
        if (widget.visite.members.isNotEmpty)
          AppText.medium(
            'Personnes associées à la visite (${widget.visite.members.length})',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        if (widget.visite.members.isNotEmpty)
          showMemberRow(
            members: widget.visite.members,
            context: context,
          ),
        const SizedBox(height: 10),
        CustomButton(
          color: Palette.primaryColor,
          width: double.infinity,
          height: 35,
          radius: 5,
          text: 'Entrée ?',
          onPress: () {
            /////////////// on cree une instance de scanHistoryModel  //////////
            /// de motif: "Entrée"///
            ///
            String hours = DateFormat('HH:mm', 'fr_FR').format(
              DateTime.now(),
            );
            if (_switchIndex == 0 && _badgeController.text.trim().isEmpty) {
              Functions.showToast(
                msg: 'Renseigner le n° de badge !',
                gravity: ToastGravity.TOP,
              );
              return;
            }

            /*  setState(() {
              cariDController2.text = visite.plaqueVehicule;
            }); */
            /////////////////////////////////////////////////
            /// on affiche une alerte modale pour la
            /// confirmation
            Functions.IsAllRedyScanalert(
              /*  carIdField: getTextfiel(
                controller: _cariDController2,
                //hintext: user.plaqueVehicule,
              ), */
              ctxt: context,
              visite: widget.visite,
              confirm: () {
                ////////////
                ///scan_history
                Map<String, dynamic> scanHistoryData = {
                  "visite_id": widget.visite.id,
                  "user_id": widget.agent.id,
                  "scan_date": DateTime.now().toIso8601String(),
                  "scan_hour": hours,
                  "motif": "Entrée",
                  "badge": _switchIndex == 0 ? 1 : 0,
                  "numero_badge": _badgeController.text,
                  "numero_gilet": _giletController.text,
                  "plaque_immatriculation": _cariDController2.text,
                };
                upDateScanHistory(
                  // carID: cariDController2.text,
                  scanHistoryData: scanHistoryData,
                  context: context,
                );
              },
              cancel: () => Navigator.pop(context), //Get.back(),
            );
          },
        ),
        const SizedBox(
          height: 15,
        ),
        CustomButton(
          textColor: Palette.secondaryColor,
          color: Palette.secondaryColor.withOpacity(0.05),
          width: double.infinity,
          height: 35,
          radius: 5,
          text: 'Sortie ?',
          onPress: () {
            /////////////// on cree une instance de scanHistoryModel  //////////
            /// de motif: "Sortie"///
            ///
            String hours = DateFormat('HH:mm', 'fr_FR').format(
              DateTime.now(),
            );
            if (_switchIndex == 0 && _badgeController.text.trim().isEmpty) {
              Functions.showToast(
                msg: 'Renseigner le n° de badge !',
                gravity: ToastGravity.TOP,
              );
              return;
            }

            Map<String, dynamic> scanHistoryData = {
              "visite_id": widget.visite.id,
              "user_id": widget.agent.id,
              "scan_date": DateTime.now().toIso8601String(),
              "scan_hour": hours,
              "motif": "Sortie",
              "badge": _switchIndex == 0 ? 1 : 0,
              "numero_badge": _badgeController.text,
              "numero_gilet": _giletController.text,
              "plaque_immatriculation": _cariDController2.text,
            };

            /////////////////////////////////////////////////
            /// on affiche une alerte modale pour la
            /// confirmation
            Functions.IsAllRedyScanalert(
              /*  carIdField: getTextfiel(
                controller: _cariDController2,
                // hintext: user.plaqueVehicule,
              ), */
              ctxt: context,
              isEntree: false,
              visite: widget.visite,
              confirm: () => upDateScanHistory(
                // on appel upDateScanHistory() si c'est confirmé
                // carID: cariDController2.text,
                scanHistoryData: scanHistoryData,
                isEntree: false,
                context: context,
              ),
              cancel: () => Navigator.pop(context), //Get.back(),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
