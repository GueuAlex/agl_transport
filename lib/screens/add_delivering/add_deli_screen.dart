import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:scanner/screens/scanner/widgets/infos_column.dart';
import 'package:scanner/screens/side_bar/open_side_dar.dart';
import 'package:scanner/widgets/all_sheet_header.dart';

import '../../bloc/options_bloc/options_bloc.dart';
import '../../bloc/options_bloc/options_event.dart';
import '../../bloc/options_bloc/options_state.dart';
import '../../bloc/piece_bloc/piece_bloc.dart';
import '../../bloc/piece_bloc/piece_event.dart';
import '../../bloc/piece_bloc/piece_state.dart';
import '../../config/app_text.dart';
import '../../config/functions.dart';
import '../../config/palette.dart';
import '../../draggable_menu.dart';
import '../../local_service/local_service.dart';
import '../../model/DeviceModel.dart';
import '../../model/agent_model.dart';
import '../../model/agl_livraison_model.dart';
import '../../model/logistic_agent_model.dart';
import '../../remote_service/remote_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/sheet_closer.dart';
import '../create_delivery/widget/logistic_member.dart';
import 'deli_verify.sucess.dart';

class AddDeliScree extends StatefulWidget {
  static String routeName = 'add_deli_screen';
  const AddDeliScree({super.key});

  @override
  State<AddDeliScree> createState() => _AddDeliScreeState();
}

class _AddDeliScreeState extends State<AddDeliScree> {
  AglLivraisonModel? _widgetDeli;
  //TracteurModel? _tracteur;
  bool showForm = false;
  String _idCardType = 'CNI';
  List<String> _pieces = [
    "CNI",
    "Permis",
    "Passeport",
    "Attestation",
  ];

  String _containerState = '';
  String _containerHeight = '';
  String _motif = '';
  String _selectedOption = '';
  List<LogisticAgent> _logisticAgents = [];
  String _selectedL = 'CNI';

  final TextEditingController _logisticAgentFirstName = TextEditingController();
  final TextEditingController _logisticAgentLastName = TextEditingController();
  final TextEditingController _logisticAgentIdCard = TextEditingController();
  List<String> _searcheOptions = [
    'Entrée',
    'Sortie',
  ];

  // Text Editing Controllers

  final TextEditingController _numTracteurController = TextEditingController();
  final TextEditingController _numRemorqueController = TextEditingController();
  // update controllers
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomsController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _commentaireController = TextEditingController();
  final TextEditingController _numConteneurController = TextEditingController();
  final TextEditingController _pieceValidController = TextEditingController();
  final TextEditingController _numPlombController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _docRefController = TextEditingController();
  final TextEditingController _typeEnginController = TextEditingController();
  final TextEditingController _marqueController = TextEditingController();

  @override
  void dispose() {
    _numTracteurController.dispose();
    _numRemorqueController.dispose();
    _numConteneurController.dispose();
    _nomController.dispose();
    _prenomsController.dispose();
    _telController.dispose();
    _pieceValidController.dispose();
    _idCardController.dispose();
    _logisticAgentFirstName.dispose();
    _logisticAgentLastName.dispose();
    _logisticAgentIdCard.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initialActions();

    super.initState();
  }

  void _initialActions() async {
    EasyLoading.show();
    await AglLivraisonModel.getTracteurListFromApi().whenComplete(() {
      EasyLoading.dismiss();
      Future.delayed(Duration.zero, () {
        _showBonCommandeSheet();
      });
    });
  }

  void _showBonCommandeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _formSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: AppText.medium('Vérifier une livraison'),
        centerTitle: true,
        leading: OpenSideBar(),
        actions: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.primaryColor,
            ),
            padding: const EdgeInsets.all(0),
            child: InkWell(
              onTap: () => _initialActions(),
              child: Center(
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),

      ///
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: double.infinity,
                    height: constraints.maxHeight,
                    child: _widgetDeli != null
                        ? _deliDetails(deli: _widgetDeli!)
                        : Container(
                            margin: EdgeInsets.only(
                              top: size.height * 0.35,
                              // bottom: size.height * 0.2,
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  children: [
                                    AppText.medium(
                                      'Aucune livraison à afficher',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    const SizedBox(height: 8),
                                    CustomButton(
                                      color: Palette.primaryColor
                                          .withOpacity(0.05),
                                      width: double.infinity,
                                      height: 35,
                                      radius: 5,
                                      text: 'Réessayer',
                                      textColor: Palette.primaryColor,
                                      onPress: () => _initialActions(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
              // Conditional rendering of DraggableMenu based on keyboard visibility
              Visibility(
                visible: !isKeyboardVisible,
                child: DraggableMenu(),
              ),
            ],
          );
        },
      ),
    );
  }

  Column _deliDetails({required AglLivraisonModel deli}) {
    return Column(
      children: [
        // _deliStatutBar(delisStatus: deli.status),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.large('Détails de la livraison'),
                  AppText.small(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
                  ),
                  const SizedBox(height: 10),
                  _cardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium('Informations du livreur'),
                        AppText.small(
                          'Veuillez completer les détails du livreur si nécessaire',
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.12,
                                label: 'Nom',
                                widget: Expanded(
                                  child: Functions.getTextField(
                                    controller: _nomController,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.12,
                                label: 'Prénoms',
                                widget: Expanded(
                                  child: Functions.getTextField(
                                    controller: _prenomsController,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.8,
                          color: Palette.separatorColor,
                        ),
                        InfosColumn(
                          label: 'N° de téléphone',
                          opacity: 0.12,
                          widget: Expanded(
                            child: Functions.getTextField(
                              controller: _telController,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.8,
                          color: Palette.separatorColor,
                        ),
                        InfosColumn(
                          label: 'Type de pièce',
                          opacity: 0.12,
                          widget: Expanded(
                            child: InkWell(
                              onTap: () => Functions.showBottomSheet(
                                ctxt: context,
                                widget: _idCardTypeSelector(),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText.medium(_idCardType),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.8,
                          color: Palette.separatorColor,
                        ),
                        InfosColumn(
                          label: 'N° de la pièce',
                          opacity: 0.12,
                          widget: Expanded(
                            child: Functions.getTextField(
                              controller: _idCardController,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.8,
                          color: Palette.separatorColor,
                        ),
                        InfosColumn(
                          label: 'Validité de la pièce (jj/mm/aaaa)',
                          opacity: 0.12,
                          widget: Expanded(
                            child: Functions.getTextField(
                              controller: _pieceValidController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _cardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium(
                          'Informations du véhicule ou du tracteur',
                        ),
                        AppText.small(
                          'Veuillez completer les champs manquant si nécessaire',
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                label: "Format du véhicule",
                                widget: Expanded(
                                  child: AppText.medium(
                                    _widgetDeli!.formatVehicule,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InfosColumn(
                                label: "Immatriculation ou n° du tracteur",
                                widget: Expanded(
                                  child: AppText.medium(
                                    _widgetDeli!.numeroImmatriculation,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                ///opacity: 0.12,
                                label: 'Type engin',
                                widget: Expanded(
                                  child: Functions.getTextField(
                                    controller: _typeEnginController,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InfosColumn(
                                // opacity: 0.12,
                                label: 'Marque',
                                widget: Expanded(
                                  child: Functions.getTextField(
                                    controller: _marqueController,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  if (_widgetDeli!.formatVehicule.toUpperCase() != 'VL')
                    _cardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.medium(
                            'Détails de la remorque et du conteneur',
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InfosColumn(
                                  opacity: 0.12,
                                  radius: 0,
                                  label: "N° de Remorque",
                                  widget: Expanded(
                                    child: Functions.getTextField(
                                      controller: _numRemorqueController,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InfosColumn(
                                  opacity: 0.12,
                                  label: "N° de Conteneur",
                                  widget: Expanded(
                                    child: Functions.getTextField(
                                      controller: _numConteneurController,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InfosColumn(
                                  opacity: 0.12,
                                  label: 'Etat du conteneur',
                                  widget: Expanded(
                                    child: InkWell(
                                      onTap: () => Functions.showBottomSheet(
                                        ctxt: context,
                                        widget: _containerStateSelector(),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child:
                                                AppText.medium(_containerState),
                                          ),
                                          Icon(Icons.arrow_drop_down)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InfosColumn(
                                  opacity: 0.12,
                                  label: 'Taille du conteneur',
                                  widget: Expanded(
                                    child: InkWell(
                                      onTap: () => Functions.showBottomSheet(
                                        ctxt: context,
                                        widget: _containerHeightSelector(),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: AppText.medium(
                                              _containerHeight,
                                            ),
                                          ),
                                          Icon(Icons.arrow_drop_down)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InfosColumn(
                                  opacity: 0.12,
                                  label: 'N° de plomb',
                                  widget: Expanded(
                                    child: Functions.getTextField(
                                        controller: _numPlombController),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 10),
                  // date et heure de livraison
                  _cardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium('Informations de la livraison'),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                label: 'Date d\'arrivée',
                                widget: Expanded(
                                  child: AppText.medium(
                                    maxLine: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                    '${DateFormat('EE dd MMM yyyy', 'fr').format(
                                      _widgetDeli!.dateEntree ?? DateTime.now(),
                                    )}',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InfosColumn(
                                label: 'Heure d\'arrivée',
                                widget: Expanded(
                                  child: AppText.medium(
                                    _widgetDeli!.heureEntree.trim().isNotEmpty
                                        ? '${_widgetDeli!.heureEntree}'
                                        : '${DateFormat('HH:mm:ss', 'fr').format(
                                            DateTime.now(),
                                          )}',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        if (_widgetDeli!.DateSortie != null)
                          Row(
                            children: [
                              Expanded(
                                child: InfosColumn(
                                  label: 'Date de sortie',
                                  widget: Expanded(
                                    child: AppText.medium(
                                      maxLine: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                      '${DateFormat('EE dd MMM yyyy', 'fr').format(
                                        _widgetDeli!.DateSortie!,
                                      )}',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InfosColumn(
                                  label: 'à',
                                  widget: Expanded(
                                    child: AppText.medium(
                                      _widgetDeli!.heureSortie,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        const SizedBox(height: 5),
                        AppText.small(
                          'Veuillez ajuster les informations ci-dessous  si nécessaire',
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                label: 'Mouvement',
                                opacity: 0.12,
                                widget: AppText.medium(_selectedOption),
                              ),
                            ),
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.12,
                                label: 'Motif',
                                widget: Expanded(
                                  child: InkWell(
                                    onTap: () => Functions.showBottomSheet(
                                      ctxt: context,
                                      widget: _motifSelector(),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(child: AppText.medium(_motif)),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                height: 55,
                                opacity: 0.12,
                                label: 'Désignation',
                                widget: Expanded(
                                  //flex: 2,
                                  child: Functions.getTextField(
                                    //maxLines: 1,
                                    controller: _designationController,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InfosColumn(
                                height: 55,
                                opacity: 0.12,
                                label: 'Ref. document',
                                widget: Expanded(
                                  child: Functions.getTextField(
                                    controller: _docRefController,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _cardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.medium(
                                    'Agents logistiques',
                                    textAlign: TextAlign.start,
                                  ),
                                  AppText.small(
                                    'Veuillez ajouter toues personnes accompagnant le chauffeur.',
                                  )
                                ],
                              ),
                            ),
                            _widgetDeli!.mouvements == 'Entrée'
                                ? InkWell(
                                    onTap: () => Functions.showBottomSheet(
                                      ctxt: context,
                                      widget: _addLogisticMember(),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(3.5),
                                      decoration: BoxDecoration(
                                        color: Palette.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.plus,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LogisticMember(
                          logisticMembers: _logisticAgents,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // entreprise et colis
                  _cardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium(
                          'Entreprise et notes',
                        ),
                        InfosColumn(
                          label: 'Entreprise',
                          widget: Expanded(
                            child: AppText.medium(
                              _widgetDeli!.entreprise,
                            ),
                          ),
                        ),
                        AppText.small(
                            'Veuillez noter toutes informations complementaire dans le champs ci-dessous'),
                        InfosColumn(
                          height: 90,
                          opacity: 0.12,
                          label: 'note (observation)',
                          widget: Expanded(
                            child: Functions.getTextField(
                              maxLines: 5,
                              controller: _commentaireController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  //vehicule de livraison

                  ///////
                  //
                  const SizedBox(height: 20),
                  CustomButton(
                    color: Palette.primaryColor,
                    width: double.infinity,
                    height: 35,
                    radius: 3,
                    text: 'Enregistrer',
                    onPress: () {
                      if (_pieceValidController.text.trim().isEmpty) {
                        Functions.showToast(
                          msg: 'Renseigner la validité de la pièce',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }
                      if (_idCardType.trim().isEmpty) {
                        Functions.showToast(
                          msg: 'Selectionner un type de pièce',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }
                      if (_idCardController.text.trim().isEmpty) {
                        Functions.showToast(
                          msg: 'Renseigner le numéro de la pièce',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }
                      if (_nomController.text.trim().isEmpty ||
                          _prenomsController.text.trim().isEmpty) {
                        Functions.showToast(
                          msg: 'Renseigner le nom du livreur',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }
                      if (_typeEnginController.text.trim().isEmpty) {
                        Functions.showToast(
                          msg: 'Renseigner le type d\'engin',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }

                      if (_marqueController.text.trim().isEmpty) {
                        Functions.showToast(
                          msg: 'Renseigner la marque de l\'engin',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }
                      Functions.showPlatformDialog(
                        context: context,
                        onCancel: () => Navigator.pop(context),
                        onConfirme: () {
                          if (_selectedOption == 'Sortie') {
                            _handleDeliOut();
                          } else {
                            _handleDeliEntry();
                          }
                        },
                        title: AppText.medium('Confirmation'),
                        content: AppText.small(
                          'Confirmer l\'enregistrement de cette ${_widgetDeli!.mouvements}',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Container _idCardTypeSelector() {
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
                        /*  color: piece == _idCardType
                            ? Palette.primaryColor
                            : Colors.white, */
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

  _handleDeliEntry() async {
    Navigator.pop(context);
    EasyLoading.show();
    String hours = DateFormat('HH:mm', 'fr_FR').format(
      DateTime.now(),
    );
    AgentModel? _agent = await Functions.fetchAgent();
    if (_agent == null) {
      Functions.showToast(
        msg: 'Une erreur s\'est produite',
        gravity: ToastGravity.TOP,
      );
      return;
    }

    if (_widgetDeli!.dateEntree != null ||
        _widgetDeli!.heureEntree.trim().isNotEmpty) {
      Functions.showToast(
        msg: 'Cette livraison a déjà été enregistrée à pour une entrée !',
        gravity: ToastGravity.TOP,
      );
      EasyLoading.dismiss();
      await Future.delayed(Duration(seconds: 2));
      _initialActions();
      return;
    }

    // UPDDATE LIVRAISON
    Map<String, dynamic> _payload = {
      //"checked_by": _agent.id,
      /*  "active": 1, */
      "nom": _nomController.text,
      "prenoms": _prenomsController.text,
      "type_piece": _idCardType.toUpperCase(),
      "numero_piece": _idCardController.text.toUpperCase(),
      "validite_piece": _pieceValidController.text.toUpperCase(),
      "numero_immatriculation":
          _widgetDeli!.numeroImmatriculation.toUpperCase(),
      "numero_remorque": _numRemorqueController.text.toUpperCase(),
      "numero_conteneur": _numConteneurController.text.toUpperCase(),
      "numero_plomb": _numPlombController.text.toUpperCase(),
      "etat_conteneur": _containerState,
      "taille_conteneur": _containerHeight,
      "motif": _motif,
      "reference_document": _docRefController.text,
      "type_engin": _typeEnginController.text,
      "marque": _marqueController.text,
      "telephone": _telController.text,
      "designation": _designationController.text,
      "date_livraison": DateTime.now().toIso8601String(),
      "heure": hours,
      "date_entree": DateTime.now().toIso8601String(),
      "heure_entree": hours,
      "observation": _commentaireController.text,
      "membre_livraisons": _logisticAgents.map((e) => e.toJson()).toList(),
    };

    print(_payload);

    await RemoteService()
        .putSomethings(
      api: 'livraisons/${_widgetDeli!.id}',
      data: _payload,
    )
        .whenComplete(() {
      EasyLoading.dismiss();
      Navigator.pushNamed(
        context,
        DeliveryVerifySucess.routeName,
        arguments: 'Vérfication',
      );
    });
  }

//
  _handleDeliOut() async {
    Navigator.pop(context);
    EasyLoading.show();
    String hours = DateFormat('HH:mm', 'fr_FR').format(
      DateTime.now(),
    );
    AgentModel? _agent = await Functions.fetchAgent();
    if (_agent == null) {
      Functions.showToast(
        msg: 'Une erreur s\'est produite',
        gravity: ToastGravity.TOP,
      );
      return;
    }

    LocalService localService = LocalService();
    DeviceModel? _device = await localService.getDevice();
    if (_device == null) {
      Functions.showToast(
        msg: 'Une erreur s\'est produite',
        gravity: ToastGravity.TOP,
      );
      return;
    }
    // UPDDATE LIVRAISON
    Map<String, dynamic> _payload = {
      "active": 0,
      /*  "date_sortie": DateTime.now().toIso8601String(),
      "heure_sortie": hours, */
    };

    var postData = {
      "user_id": _agent.id,
      "localisation_id": _device.localisationId,
      "mouvements": _selectedOption,
      "format_vehicule": _widgetDeli!.formatVehicule,
      "active": 0,
      "nom": _nomController.text,
      "prenoms": _prenomsController.text,
      "type_piece": _idCardType.toUpperCase(),
      "numero_piece": _idCardController.text.toUpperCase(),
      "validite_piece": _pieceValidController.text.toUpperCase(),
      "numero_immatriculation":
          _widgetDeli!.numeroImmatriculation.toUpperCase(),
      "numero_remorque": _numRemorqueController.text.toUpperCase(),
      "numero_conteneur": _numConteneurController.text.toUpperCase(),
      "numero_plomb": _numPlombController.text.toUpperCase(),
      "etat_conteneur": _containerState,
      "taille_conteneur": _containerHeight,
      "motif": _motif,
      "reference_document": _docRefController.text,
      "type_engin": _typeEnginController.text,
      "marque": _marqueController.text,
      "telephone": _telController.text,
      "designation": _designationController.text,
      "date_livraison": DateTime.now().toIso8601String(),
      "heure": hours,
      "date_sortie": DateTime.now().toIso8601String(),
      "heure_sortie": hours,
      "observation": _commentaireController.text,
      "membre_livraisons": _logisticAgents.map((e) => e.toJson()).toList(),
    };

    print(_payload);

    await RemoteService()
        .putSomethings(
      api: 'livraisons/${_widgetDeli!.id}',
      data: _payload,
    )
        .then((result) async {
      await RemoteService().postData(
        endpoint: 'livraisons',
        postData: {
          ...postData,
          "date_entree": result['date_entree'],
          "heure_entree": result['heure_entree'],
          "entreprise": result['entreprise'],
          "date_visite": result['date_visite'],
        },
      ).whenComplete(() {
        EasyLoading.dismiss();
        /*  Functions.showToast(
          msg: 'Enregistrement effectué avec succès',
          gravity: ToastGravity.TOP,
        ); */

        Navigator.pushNamed(
          context,
          DeliveryVerifySucess.routeName,
          arguments: 'Vérfication',
        );
      });
    });
  }

// form sheet
  Widget _formSheet() {
    return BlocBuilder<DeliveryBloc, DeliveryState>(builder: (context, state) {
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.45,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                AppText.medium(
                  'Entrée/Sortie de véhicule ou engin',
                  fontWeight: FontWeight.w400,
                ),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Palette.separatorColor,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Color.fromARGB(255, 124, 124, 124),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Column(
                children: [
                  AppText.small(
                    'Veuillez indiquer le mouvement du véhicule/tracteur et renseigner son numéro  d\'immatriculation.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: _searcheOptions.map(
                      (option) {
                        return Expanded(
                          child: InkWell(
                            onTap: () {
                              context.read<DeliveryBloc>().add(
                                    SelectDeliveryOption(option),
                                  );
                              setState(() {
                                _selectedOption = option;
                              });
                              print(_selectedOption);
                              // print(_searcheOptions);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: state.selectedOption == option
                                      ? Palette.primaryColor
                                      : Palette.separatorColor,
                                  width: 3.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: state.selectedOption == option
                                          ? Palette.primaryColor
                                          : Palette.separatorColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: AppText.medium(
                                        option,
                                        color: state.selectedOption == option
                                            ? Palette.primaryColor
                                            : const Color.fromARGB(
                                                255, 134, 134, 134),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 20),
                  InfosColumn(
                    opacity: 0.12,
                    label: 'Immatriculation véhicule/tracteur',
                    widget: Expanded(
                      child: Functions.getTextField(
                        controller: _numTracteurController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SafeArea(
              child: CustomButton(
                  color: Palette.primaryColor,
                  width: double.infinity,
                  height: 35,
                  radius: 5,
                  text: 'Continuer',
                  onPress: () async {
                    print(
                        '-----------------------------------------------> $_selectedOption');
                    if (_selectedOption.trim().isEmpty) {
                      Functions.showToast(
                        msg:
                            'Indiquer le mouvement du véhicule ou du tracteur svp',
                        gravity: ToastGravity.TOP,
                      );
                      return;
                    }
                    if (_numTracteurController.text.trim().isEmpty) {
                      Functions.showToast(
                        msg:
                            'Renseigner le numéro du d\'immatriculation du véhicule ou du tracteur',
                        gravity: ToastGravity.TOP,
                      );
                      return;
                    }

                    EasyLoading.show();
                    LocalService localService = LocalService();
                    DeviceModel? _device = await localService.getDevice();
                    if (_device == null) {
                      Functions.showToast(
                        msg: 'Une erreur s\'est produite',
                        gravity: ToastGravity.TOP,
                      );
                      EasyLoading.dismiss();
                      return;
                    }
                    AglLivraisonModel? _livraison =
                        AglLivraisonModel.findLivraison(
                      numMatricule: _numTracteurController.text,
                      localisationId: _device.localisationId,
                      mouvement: "Entrée",
                    );
                    if (_livraison == null) {
                      Functions.showToast(
                        msg: 'Livraison introuvable !',
                        gravity: ToastGravity.TOP,
                      );
                      EasyLoading.dismiss();
                      return;
                    } else {
                      EasyLoading.dismiss();
                      setState(() {
                        _widgetDeli = _livraison;
                        _logisticAgents = _livraison.logisticAgents;
                        _idCardType = _livraison.typePiece;
                        _numTracteurController.text =
                            _livraison.numeroImmatriculation;
                        _numRemorqueController.text = _livraison.numeroRemorque;
                        _nomController.text = _livraison.nom;
                        _prenomsController.text = _livraison.prenoms;
                        _telController.text = _livraison.telephone;
                        _idCardController.text = _livraison.numeroPiece;
                        _numConteneurController.text =
                            _livraison.numeroConteneur;
                        _pieceValidController.text = _livraison.validitePiece;
                        _containerState = _livraison.etatConteneur;
                        _containerHeight = _livraison.tailleConteneur;
                        _numPlombController.text = _livraison.numeroPlomb;
                        _docRefController.text = _livraison.referenceDocument;
                        _designationController.text = _livraison.designation;
                        _typeEnginController.text = _livraison.typeEngin;
                        _marqueController.text = _livraison.marque;
                        _motif = _livraison.motif;
                        _commentaireController.text = _livraison.observation;
                        ;
                      });
                      Navigator.pop(context);
                    }
                  }),
            ),
          ],
        ),
      );
    });
  }

  Widget _cardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 211, 211, 211),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  _addLogisticMember() {
    List<String> _pieces = [
      "CNI",
      "Permis",
      "Passeport",
      "Attestation",
      "Carte consulaire",
      "Carte CMU",
      "Carte professionnelle",
    ];
    return BlocBuilder<PieceBloc, PieceState>(builder: (context, state) {
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.7,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            opacity: 0.12,
                            label: 'Nom',
                            widget: Expanded(
                              child: Functions.getTextField(
                                controller: _logisticAgentFirstName,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: InfosColumn(
                            opacity: 0.12,
                            label: 'Prénoms',
                            widget: Expanded(
                              child: Functions.getTextField(
                                controller: _logisticAgentLastName,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    InfosColumn(
                      opacity: 0.12,
                      label: 'N° de pièce',
                      widget: Expanded(
                        child: Functions.getTextField(
                          controller: _logisticAgentIdCard,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    AppText.medium('Type de la pièce'),
                    AppText.small(
                      'Veuillez selectionner le type de la pièce fournie',
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      children: _pieces.map((type) {
                        bool isSelected = type == _selectedL;
                        return InkWell(
                          onTap: () {
                            context.read<PieceBloc>().add(
                                  SelectPieceOption(type),
                                );
                            setState(() {
                              _selectedL = type;
                            });
                            // print(_selectedL);
                            // print(_searcheOptions);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Palette.primaryColor
                                  : Palette.separatorColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                color: isSelected ? Colors.white : null,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      color: Palette.primaryColor,
                      width: double.infinity,
                      height: 35,
                      radius: 5,
                      text: 'Ajouter l\'agent',
                      onPress: () {
                        if (_logisticAgentFirstName.text.isEmpty) {
                          Functions.showToast(
                            msg: 'Le nom est obligatoire',
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }
                        if (_logisticAgentLastName.text.isEmpty) {
                          Functions.showToast(
                            msg: 'Le nom est obligatoire',
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }
                        if (_logisticAgentIdCard.text.isEmpty) {
                          Functions.showToast(
                            msg: 'Le numéro de pièce est obligatoire',
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }
                        final _logisticAgent = LogisticAgent(
                          id: 0,
                          nom: _logisticAgentFirstName.text,
                          prenoms: _logisticAgentLastName.text,
                          numeroCni: _logisticAgentIdCard.text,
                          typePiece: _selectedL,
                        );
                        _logisticAgents.add(_logisticAgent);
                        _logisticAgentFirstName.clear();
                        _logisticAgentLastName.clear();
                        _logisticAgentIdCard.clear();
                        _selectedL = 'CNI';
                        context.read<PieceBloc>().add(SelectPieceOption('CNI'));
                        setState(() {});
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  _containerHeightSelector() {
    List<String> _heights = [
      "20",
      "40",
    ];
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
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
                children: _heights.map((height) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _containerHeight = height;
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
                        /*  color: piece == _idCardType
                            ? Palette.primaryColor
                            : Colors.white, */
                        border: Border(
                          left: BorderSide(
                            width: 3,
                            color: height == _containerHeight
                                ? Palette.primaryColor
                                : Colors.white,
                          ),
                        ),
                      ),
                      child: AppText.medium(
                        height,
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

  _containerStateSelector() {
    List<String> _conteneurStates = [
      "Vide",
      "Plein",
    ];
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
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
                children: _conteneurStates.map((containerState) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _containerState = containerState;
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
                            color: containerState == _containerState
                                ? Palette.primaryColor
                                : Colors.white,
                          ),
                        ),
                      ),
                      child: AppText.medium(
                        containerState,
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

  _motifSelector() {
    List<String> _motifs = [
      "Récuperation de conteneur",
      "Récuperation de plateau",
      "Sortie conteneur",
      "Sortie plateau",
      "Livraison marchandise",
      "Sortie camion",
      "Chargement de marchandises",
      "Expédition de marchandises",
      "Livraison",
      "Recuperation",
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
      child: SafeArea(
        child: Column(
          children: [
            AllSheetHeader(
              opacity: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _motifs.map((motif) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _motif = motif;
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
                              color: motif == _motif
                                  ? Palette.primaryColor
                                  : Colors.white,
                            ),
                          ),
                        ),
                        child: AppText.medium(
                          motif,
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
      ),
    );
  }

  ///
}
