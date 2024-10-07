import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scanner/screens/scanner/widgets/single_visitor.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../local_service/local_service.dart';
import '../../../model/DeviceModel.dart';
import '../../../model/agent_model.dart';
import '../../../model/visite_model.dart';
import '../../../remote_service/remote_service.dart';
import '../../../widgets/all_sheet_header.dart';
import '../../../widgets/custom_button.dart';
import 'alert_agl.dart';
import 'infos_column.dart';

class FirstScanWidget extends StatefulWidget {
  const FirstScanWidget({
    super.key,
    required this.agent,
    required this.visite,
  });
  final VisiteModel visite;
  final AgentModel agent;

  @override
  State<FirstScanWidget> createState() => _FirstScanWidgetState();
}

class _FirstScanWidgetState extends State<FirstScanWidget> {
  int _currentIndex = 0;
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _carIdController = TextEditingController();
  final TextEditingController _badgeController = TextEditingController();
  final TextEditingController _giletController = TextEditingController();

  // Members controllers list
  List<TextEditingController> _mIdCardControllers = [];
  List<TextEditingController> _mBadgeControllers = [];
  List<TextEditingController> _mGiletControllers = [];
  List<String> _membersIdCardTypes = [];

  String _idCardType = '';
  int _switchIndex = 0;

  DateTime _today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  String _hours = DateFormat('HH:mm').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _idCardType = widget.visite.typePiece;
    _idCardController.text = widget.visite.numeroCni;

    // Initialize controllers for each member
    for (var member in widget.visite.members) {
      _mIdCardControllers.add(TextEditingController(text: member.idCard));
      _mBadgeControllers.add(TextEditingController(text: member.badge));
      _mGiletControllers.add(TextEditingController(text: member.gilet));
      _membersIdCardTypes.add(member.typePiece);
    }
  }

  @override
  void dispose() {
    _idCardController.dispose();
    _carIdController.dispose();
    _badgeController.dispose();
    _giletController.dispose();
    for (var controller in _mIdCardControllers) {
      controller.dispose();
    }
    for (var controller in _mBadgeControllers) {
      controller.dispose();
    }
    for (var controller in _mGiletControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.visite.members.isEmpty
        ? SingleVisitor(agent: widget.agent, visite: widget.visite)
        : Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildPrimaryVisitor(), // For primary visitor
                      ..._buildMembersPages(), // For members
                    ],
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
          );
  }

  Widget _buildPrimaryVisitor() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfosColumn(
                label: 'Date visie',
                widget: AppText.medium(
                  DateFormat('dd MMM yyyy', 'fr_FR')
                      .format(widget.visite.dateVisite),
                ),
              ),
            ),
            Expanded(
              child: InfosColumn(
                label: 'Heure d\'entrée',
                widget: AppText.medium(widget.visite.heureVisite ?? ''),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InfosColumn(
                opacity: 0.12,
                label: 'n° de pièce',
                widget: Expanded(
                    child:
                        Functions.getTextField(controller: _idCardController)),
              ),
            ),
            Expanded(
              child: InfosColumn(
                opacity: 0.12,
                label: 'type de pièce',
                widget: InkWell(
                  onTap: () => Functions.showBottomSheet(
                    ctxt: context,
                    widget: _idCardTypeSelector(),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: AppText.medium(_idCardType)),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InfosColumn(
                opacity: 0.12,
                label: 'n° d\'immatriculation véhicule',
                widget: Expanded(
                    child:
                        Functions.getTextField(controller: _carIdController)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
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
          _buildAccessoriesSection(_badgeController, _giletController)
      ],
    );
  }

  List<Widget> _buildMembersPages() {
    return List.generate(widget.visite.members.length, (index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.medium(
              'Personnes associées à la visite (${widget.visite.members.length})'),
          Row(
            children: [
              Expanded(
                child: InfosColumn(
                  label: 'Nom',
                  widget: AppText.medium(widget.visite.members[index].nom),
                ),
              ),
              Expanded(
                child: InfosColumn(
                  label: 'Prénoms',
                  widget: AppText.medium(widget.visite.members[index].prenoms),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: InfosColumn(
                  opacity: 0.12,
                  label: 'N° de la pièce',
                  widget: Expanded(
                    child: Functions.getTextField(
                        controller: _mIdCardControllers[index]),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: InfosColumn(
                  opacity: 0.12,
                  label: 'type de pièce',
                  widget: InkWell(
                    onTap: () => Functions.showBottomSheet(
                      ctxt: context,
                      widget: _membersIdCardTypeSelector(index),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: AppText.medium(_membersIdCardTypes[index])),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_switchIndex == 0)
            _buildAccessoriesSection(
                _mBadgeControllers[index], _mGiletControllers[index]),
        ],
      );
    });
  }

  Widget _buildAccessoriesSection(TextEditingController badgeController,
      TextEditingController giletController) {
    return Column(
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
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: InfosColumn(
                opacity: 0.12,
                label: 'Entrer le n° du badge',
                widget: Expanded(
                    child: Functions.getTextField(controller: badgeController)),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: InfosColumn(
                opacity: 0.12,
                label: 'Entrer le n° du gilet',
                widget: Expanded(
                    child: Functions.getTextField(controller: giletController)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentIndex > 0)
          Expanded(
            child: CustomButton(
              width: double.infinity,
              height: 35,
              radius: 5,
              color: Palette.secondaryColor,
              text: 'Précédent',
              onPress: () {
                if (_currentIndex > 0) {
                  setState(() {
                    _currentIndex--;
                  });
                }
              },
            ),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomButton(
            width: double.infinity,
            height: 35,
            radius: 5,
            color: Palette.primaryColor,
            text: 'Suivant',
            onPress: () {
              if (_currentIndex < widget.visite.members.length) {
                setState(() {
                  _currentIndex++;
                });
              } else {
                _submitData();
              }
            },
          ),
        ),
      ],
    );
  }

  void _submitData() async {
    // Initialisation du service local
    LocalService localService = LocalService();
    DeviceModel? _device = await localService.getDevice();

    // Vérifier si le dispositif est valide
    if (_device == null) {
      Functions.showToast(
        msg:
            'Une erreur s\'est produite lors de la récupération de l\'appareil',
        gravity: ToastGravity.TOP,
      );
      return;
    }

    // Vérifier si la localisation correspond à la visite
    if (_device.localisationId != widget.visite.localisation.id) {
      Functions.showToast(
        msg: 'Cette visite n\'a pas lieu ici !',
        gravity: ToastGravity.TOP,
      );
      return;
    }

    // Vérification des champs du visiteur principal
    if (_idCardController.text.isEmpty) {
      Functions.showToast(
        msg:
            'Le n° de pièce d\'identité est obligatoire pour le visiteur principal !',
        gravity: ToastGravity.TOP,
      );
      return;
    }
    if (_switchIndex == 0 && _badgeController.text.trim().isEmpty) {
      Functions.showToast(
        msg: 'Renseigner le n° de badge !',
        gravity: ToastGravity.TOP,
      );
      return;
    }
    // Parcourir les membres associés pour vérifier les données et les ajouter
    for (int i = 0; i < widget.visite.members.length; i++) {
      //final member = widget.visite.members[i];

      // Valider chaque membre
      if (_mIdCardControllers[i].text.isEmpty) {
        Functions.showToast(
          msg: 'Le n° de pièce d\'identité est obligatoire pour ce membre !',
          gravity: ToastGravity.TOP,
        );
        return;
      }

      // Mettre à jour les informations du membre
      widget.visite.members[i].idCard = _mIdCardControllers[i].text;
      widget.visite.members[i].badge = _mBadgeControllers[i].text;
      widget.visite.members[i].gilet = _mGiletControllers[i].text;
      /*  widget.visite.members[i].typePiece = _membersIdCardType; */
    }

    // Préparer les données du visiteur principal
    Map<String, dynamic> visitData = {
      "is_already_scanned": 1,
      /* "numero_cni": _idCardController.text.toUpperCase(), */
      "type_piece": _idCardType,
      /* "heure_visite": _hours, */
      "numero_piece": _idCardController.text.toUpperCase(),
      "badge": _switchIndex == 0 ? 1 : 0,
      "membre_visites":
          widget.visite.members.map((member) => member.toJson()).toList(),
    };
    //print(visitData);

    ////////////
    ///SCAN HISTORY DATA
    Map<String, dynamic> scanHistoryData = {
      "visite_id": widget.visite.id,
      "user_id": widget.agent.id,
      "scan_date": _today.toIso8601String(),
      "scan_hour": _hours,
      "badge": _switchIndex == 0 ? 1 : 0,
      "motif": "Entrée",
      "numero_badge": _badgeController.text.toUpperCase(),
      "numero_gilet": _giletController.text.toUpperCase(),
      "plaque_immatriculation": _carIdController.text.toUpperCase(),
    };

    //print(scanHistoryData);
    //return;

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
      cancel: () => Navigator.pop(context),
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

  Container _membersIdCardTypeSelector(int index) {
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
        ),
      ),
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
                        // Met à jour le type de pièce du membre correspondant à l'index
                        widget.visite.members[index].typePiece = piece;
                        _membersIdCardTypes[index] = piece;
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
                            color:
                                piece == widget.visite.members[index].typePiece
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
          ),
        ],
      ),
    );
  }
}
