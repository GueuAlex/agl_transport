import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scanner/bloc/piece_bloc/piece_bloc.dart';
import 'package:scanner/bloc/piece_bloc/piece_state.dart';
import 'package:scanner/local_service/local_service.dart';
import 'package:scanner/model/DeviceModel.dart';
import 'package:scanner/model/vehicule_model.dart';
import 'package:scanner/widgets/sheet_closer.dart';

import '../../bloc/piece_bloc/piece_event.dart';
import '../../config/app_text.dart';
import '../../config/functions.dart';
import '../../config/palette.dart';
import '../../draggable_menu.dart';
import '../../emails/emails_service.dart';
import '../../model/agent_model.dart';
import '../../model/logistic_agent_model.dart';
import '../../remote_service/remote_service.dart';
import '../../widgets/all_sheet_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_middle.dart';
import '../scanner/widgets/infos_column.dart';
import 'delivery.sucess.dart';
import 'widget/logistic_member.dart';

class CreateDeliveryScreen extends StatefulWidget {
  static String routeName = 'CreateDeliveryScreen';
  const CreateDeliveryScreen({super.key});

  @override
  State<CreateDeliveryScreen> createState() => _CreateDeliveryScreenState();
}

class _CreateDeliveryScreenState extends State<CreateDeliveryScreen> {
  int activeIndex = 0;
  final PageController _pageController = PageController();
  final _entrepriseController = TextEditingController();
  final _nameController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _idCardController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _numtracteurController = TextEditingController();
  final _numConteneurController = TextEditingController();
  final _numremorqueController = TextEditingController();
  final _commentaireController = TextEditingController();
  final _badgeController = TextEditingController();
  final _designationController = TextEditingController();
  final _docRefController = TextEditingController();
  final _numPlombController = TextEditingController();
  final _typeEnginController = TextEditingController();
  final _marqueController = TextEditingController();
  final _pieceValidController = TextEditingController();

  ///
  final _logisticAgentFirstName = TextEditingController();
  final _logisticAgentLastName = TextEditingController();
  final _logisticAgentIdCard = TextEditingController();
/*   final _logisticAgentIdCardType = TextEditingController();
  final _logisticAgentIdCardValidity = TextEditingController(); */

  String? _containerState = null;
  String? _containerHeight = null;
  String _mouvement = 'Entrée';
  String _motif = 'Récuperation de conteneur';
  String _formatVehicule = 'Tracteur';
  String _idCardType = 'CNI';
  DateTime _startDate = DateTime.now();
  bool _isWithTracteur = true;

  List<LogisticAgent> _logisticAgents = [];
  VehiculeModel? _selectedVehicule;
  // type de piece pour les agents logistique.
  String _selectedL = 'CNI';

  Future<List<VehiculeModel>> _getVehicules() async {
    final v = await RemoteService().getVehicules();
    //print(motifs);
    setState(() {
      _selectedVehicule = v[0];
    });
    return v;
  }

  @override
  void dispose() {
    _entrepriseController.dispose();
    _nameController.dispose();
    _prenomsController.dispose();
    _idCardController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _numtracteurController.dispose();
    _numConteneurController.dispose();
    _numremorqueController.dispose();
    _commentaireController.dispose();
    _badgeController.dispose();
    _designationController.dispose();
    _docRefController.dispose();
    _numPlombController.dispose();
    _typeEnginController.dispose();
    _marqueController.dispose();
    _pieceValidController.dispose();
    _logisticAgentFirstName.dispose();
    _logisticAgentLastName.dispose();
    _logisticAgentIdCard.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: AppText.medium('Nouvelle livraison'),
        leading: Container(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressIndicator(),
                      _buildPageView(constraints: constraints),
                      _buildNavigationButtons()
                    ],
                  ),
                ),
              );
            },
          ),
          // Conditional rendering of DraggableMenu based on keyboard visibility
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom.isFinite,
            child: DraggableMenu(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (activeIndex > 0)
            Expanded(
              child: CustomButton(
                color: Palette.primaryColor,
                textColor: Colors.white,
                width: double.infinity,
                height: 35,
                radius: 5,
                text: 'Précédent',
                onPress: () => _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomButton(
              color: Palette.primaryColor,
              textColor: Colors.white,
              width: double.infinity,
              height: 35,
              radius: 5,
              text: activeIndex < 2 ? 'Suivant' : 'Terminer',
              onPress: () {
                if (activeIndex == 0) {
                  if (_numtracteurController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Le n° d\'immatriculation requise',
                        gravity: ToastGravity.TOP);
                    return;
                  }

                  if (_typeEnginController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Le type d\'engin requis',
                        gravity: ToastGravity.TOP);
                    return;
                  }
                  if (_marqueController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'La marque de l\'engin requise',
                        gravity: ToastGravity.TOP);
                    return;
                  }

                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                if (activeIndex == 1) {
                  if (_nameController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Renseigner le nom du livreur',
                        gravity: ToastGravity.TOP);
                    return;
                  }
                  if (_prenomsController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Renseigner le prénom du livreur',
                        gravity: ToastGravity.TOP);
                    return;
                  }
                  if (_pieceValidController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Renseigner la validité de la piece',
                        gravity: ToastGravity.TOP);
                    return;
                  }
                  if (_idCardController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Renseigner le numéro de la pièce',
                        gravity: ToastGravity.TOP);
                    return;
                  }
                  if (_entrepriseController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Renseigner l\'entreprise',
                        gravity: ToastGravity.TOP);
                    return;
                  }
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                if (activeIndex == 2) {
                  Functions.showBottomSheet(
                    ctxt: context,
                    widget: _recapSheet(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Container(
            width: index <= activeIndex ? 30 : 15,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 8.0,
            decoration: BoxDecoration(
              color: index <= activeIndex ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPageView({required BoxConstraints constraints}) {
    return SizedBox(
      height: constraints.maxHeight *
          0.75, // Hauteur fixe pour le PageView, à ajuster si nécessaire
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            activeIndex = index;
          });
        },
        children: [
          _deliGeneraleInfos(),
          _deliBoyInfos(),
          _logisticMembers(),
        ],
      ),
    );
  }

  SingleChildScrollView _logisticMembers() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText.large(
                    'Agents logistiques',
                    textAlign: TextAlign.start,
                  ),
                ),
                InkWell(
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
              ],
            ),
            AppText.small(
              'Veuillez renseigner les informations de toute personne accompagnant le chauffeur',
            ),
            const SizedBox(height: 15),
            LogisticMember(logisticMembers: _logisticAgents),
          ],
        ),
      );

  SingleChildScrollView _deliBoyInfos() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large('Informations du livreur'),
            AppText.small(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: _cardContainer(
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
                                controller: _nameController,
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
                          controller: _phoneController,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: _cardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.medium('Entreprise'),
                    const SizedBox(height: 10),
                    InfosColumn(
                      opacity: 0.12,
                      label: 'Entreprise',
                      widget: Expanded(
                        child: Functions.getTextField(
                          controller: _entrepriseController,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
            ),
          ],
        ),
      );

  SingleChildScrollView _deliGeneraleInfos() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large('Informations de livraison'),
            AppText.small(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: _cardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.medium('Date et heure de livraison'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            label: 'Date',
                            widget: Expanded(
                              child: AppText.medium(
                                maxLine: 1,
                                textOverflow: TextOverflow.ellipsis,
                                DateFormat('EE dd MMM yyyy', 'fr')
                                    .format(_startDate),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InfosColumn(
                            label: 'Heure',
                            widget: Expanded(
                              child: AppText.medium(
                                DateFormat('HH:mm:ss', 'fr').format(
                                  DateTime.now(),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: _cardContainer(
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
                            opacity: 0.12,
                            label: 'Format du véhicule',
                            widget: Expanded(
                              child: InkWell(
                                onTap: () => Functions.showBottomSheet(
                                  ctxt: context,
                                  widget: _formatVehiculeSelector(),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: AppText.medium(_formatVehicule)),
                                    Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InfosColumn(
                            opacity: 0.12,
                            label: "Immatriculation ou n° du tracteur",
                            widget: Expanded(
                              child: InkWell(
                                  onTap: () => Functions.showBottomSheet(
                                        ctxt: context,
                                        widget: _vehiculeSelector(),
                                      ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: AppText.medium(
                                              _numtracteurController.text)),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  )),
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
                    Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            opacity: 0.12,
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
                            opacity: 0.12,
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
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_isWithTracteur)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: _cardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.medium(
                        'Détails de la remorque et du conteneur',
                      ),
                      AppText.small(
                        'Veuillez completer les champs manquant si nécessaire',
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: InfosColumn(
                              opacity: 0.12,
                              radius: 0,
                              label: "N° de Remorque",
                              widget: Expanded(
                                child: Functions.getTextField(
                                  controller: _numremorqueController,
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
                      Container(
                        width: double.infinity,
                        height: 0.8,
                        color: Palette.separatorColor,
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
                                        child: AppText.medium(
                                            _containerState ?? ''),
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
                                          _containerHeight ?? '',
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
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: _cardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.medium(
                      'Détails',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            opacity: 0.12,
                            label: 'Mouvement',
                            widget: InkWell(
                                onTap:
                                    () => /* Functions.showBottomSheet(
                                      ctxt: context,
                                      widget: _mouvementSelector(),
                                    ) */
                                        Functions.showToast(
                                          msg:
                                              'La création d\'une livraison est uniquement possible pour un mouvement Entrée',
                                          gravity: ToastGravity.TOP,
                                        ),
                                child: Row(
                                  children: [
                                    Expanded(child: AppText.medium(_mouvement)),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                )),
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
                                    Expanded(
                                        child: AppText.medium(
                                      _motif,
                                      maxLine: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    )),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
                    ),
                    InfosColumn(
                      opacity: 0.12,
                      label: 'Désignation',
                      widget: Expanded(
                        child: Functions.getTextField(
                          controller: _designationController,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
                    ),
                    InfosColumn(
                      opacity: 0.12,
                      label: 'Ref. document',
                      widget: Expanded(
                        child: Functions.getTextField(
                          controller: _docRefController,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      );

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

  Container _recapSheet() => Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.medium('Informations du livreur'),
                    Row(
                      children: [
                        Expanded(
                            child: InfosColumn(
                          label: 'Noms',
                          //opacity: 0.12,
                          widget: Expanded(
                            child: AppText.medium(
                              _nameController.text,
                              maxLine: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )),
                        Expanded(
                          child: InfosColumn(
                            label: 'Prénoms',
                            //opacity: 0.12,
                            widget: Expanded(
                              child: AppText.medium(
                                _prenomsController.text,
                                maxLine: 1,
                                textOverflow: TextOverflow.ellipsis,
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
                      label: 'n° de la pièce',
                      widget: Expanded(
                        child: AppText.medium(
                          _idCardController.text,
                        ),
                      ),
                      // opacity: 0.12,
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: InfosColumn(
                          label: 'Type de pièce',
                          widget: Expanded(
                            child: AppText.medium(
                              _idCardType,
                            ),
                          ),
                          // opacity: 0.12,
                        )),
                        Expanded(
                          child: InfosColumn(
                            label: 'Validité de la pièce (jj/mm/aaaa)',
                            widget: Expanded(
                              child: AppText.medium(
                                maxLine: 1,
                                textOverflow: TextOverflow.ellipsis,
                                _pieceValidController.text,
                              ),
                            ),
                            // opacity: 0.12,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
                    ),
                    const SizedBox(height: 10),
                    AppText.medium('Détails de la livraison'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            label: 'Date',
                            widget: Expanded(
                              child: AppText.medium(
                                  DateFormat('EE dd MMM yyyy', 'fr')
                                      .format(_startDate)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InfosColumn(
                            label: 'Heure',
                            widget: Expanded(
                              child: AppText.medium(
                                DateFormat('HH:mm:ss', 'fr').format(
                                  DateTime.now(),
                                ),
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
                    Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            label: 'Immatriculation/ N° tracteur',
                            widget: Expanded(
                              child: AppText.medium(
                                _numtracteurController.text,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InfosColumn(
                            label: 'Format du véhicule',
                            widget: Expanded(
                              child: AppText.medium(
                                _formatVehicule,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_isWithTracteur)
                      Row(
                        children: [
                          Expanded(
                            child: InfosColumn(
                              label: 'N° remorque',
                              widget: Expanded(
                                child: AppText.medium(
                                  _numremorqueController.text,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InfosColumn(
                              label: 'N° conteneur',
                              widget: Expanded(
                                child: AppText.medium(
                                  _numConteneurController.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (_isWithTracteur)
                      Row(
                        children: [
                          Expanded(
                            child: InfosColumn(
                              label: 'Etat du conteneur',
                              widget: Expanded(
                                child: AppText.medium(_containerState ?? ''),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InfosColumn(
                              label: 'Taille du conteneur',
                              widget: Expanded(
                                child: AppText.medium(
                                  _containerHeight ?? '',
                                  maxLine: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InfosColumn(
                              label: 'N° de plomb',
                              widget: Expanded(
                                child: AppText.medium(
                                  _numPlombController.text,
                                  maxLine: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            label: 'Mouvement',
                            widget: Expanded(
                              child: AppText.medium(_mouvement),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InfosColumn(
                            label: 'Motif',
                            widget: Expanded(
                              child: AppText.medium(_motif),
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
                    Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            label: 'Designation',
                            widget: Expanded(
                              child:
                                  AppText.medium(_designationController.text),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InfosColumn(
                            label: 'Entreprise',
                            widget: Expanded(
                              child: AppText.medium(_entrepriseController.text),
                            ),
                          ),
                        )
                      ],
                    ),
                    if (_logisticAgents.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          AppText.medium('Membres du convoyage'),
                          LogisticMember(
                            logisticMembers: _logisticAgents,
                            shwoTrash: false,
                          ),
                        ],
                      ),
                    InfosColumn(
                      label: 'Note (observation)',
                      widget: Expanded(
                        child: AppText.medium(
                          _commentaireController.text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: CustomButton(
                color: Palette.primaryColor,
                textColor: Colors.white,
                width: double.infinity,
                height: 35,
                radius: 5,
                text: 'Valider',
                onPress: () {
                  Navigator.pop(context);
                  Functions.showPlatformDialog(
                    context: context,
                    onCancel: () => Navigator.pop(context),
                    onConfirme: () async {
                      LocalService localService = LocalService();
                      DeviceModel? _device = await localService.getDevice();
                      AgentModel? _agent = await Functions.fetchAgent();
                      if (_device == null) {
                        Functions.showToast(
                          msg: 'Une erreur s\'est produite',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }
                      if (_agent == null) {
                        Functions.showToast(
                          msg: 'Une erreur s\'est produite',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }
                      _postVisit(agent: _agent, device: _device);
                    },
                    title: AppText.medium('Confirmation'),
                    content: AppText.small(
                      'Veuillez confirmer l\'enregistrement de cette ${_mouvement.toLowerCase()}',
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );

  Container _vehiculeSelector() => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: FutureBuilder(
          future: _getVehicules(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        Expanded(child: AppText.medium('Véhicule')),
                        SheetCloser(paddingV: 0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: AppText.small(
                      'Veuillez saisir ou sélectionner le numéro d\'immatriculation ou le numéro du tracteur',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InfosColumn(
                      opacity: 0.12,
                      label: 'Immatriculation ou n° du tracteur',
                      widget: Expanded(
                        child: Functions.getTextField(
                          controller: _numtracteurController,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 65,
                      vertical: 10,
                    ),
                    child: textMidleLine(text: 'ou'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                              Text(snapshot.data![index].numeroImmatriculation),
                          selected:
                              _selectedVehicule!.id == snapshot.data![index].id,
                          selectedColor: Palette.primaryColor,
                          onTap: () {
                            _setIfons(v: snapshot.data![index]);
                            setState(() {
                              _selectedVehicule = snapshot.data![index];
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: CustomButton(
                        color: Palette.primaryColor,
                        width: double.infinity,
                        height: 35,
                        radius: 5,
                        text: 'Continuer',
                        onPress: () {
                          setState(() {
                            ///_selectedVehicule = _selectedVehicule;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          },
        ),
      );

  //
  void _postVisit(
      {required AgentModel agent, required DeviceModel device}) async {
    // création d'une visite par un agent de sécurité
    final String hours = DateFormat('HH:mm:ss', 'fr_FR').format(
      DateTime.now(),
    );
    var postData = {
      "user_id": agent.id,
      "localisation_id": device.localisationId,
      "mouvements": _mouvement,
      "format_vehicule": _formatVehicule,
      "active": 1,
      "nom": _nameController.text,
      "prenoms": _prenomsController.text,
      "type_piece": _idCardType,
      "numero_piece": _idCardController.text.toUpperCase(),
      "validite_piece": _pieceValidController.text.toUpperCase(),
      "numero_immatriculation": _numtracteurController.text.toUpperCase(),
      "numero_remorque": _numremorqueController.text.toUpperCase(),
      "numero_conteneur": _numConteneurController.text.toUpperCase(),
      "numero_plomb": _numPlombController.text.toUpperCase(),
      "etat_conteneur": _containerState,
      "taille_conteneur": _containerHeight,
      "motif": _motif,
      "reference_document": _docRefController.text.toUpperCase(),
      "type_engin": _typeEnginController.text,
      "marque": _marqueController.text,
      "telephone": _phoneController.text,
      "entreprise": _entrepriseController.text,
      "designation": _designationController.text,
      "date_visite": DateTime.now().toIso8601String(),
      "date_livraison": DateTime.now().toIso8601String(),
      "heure": hours,
      "observation": _commentaireController.text,
      "date_entree": DateTime.now().toIso8601String(),
      "heure_entree": hours,
      "membre_livraisons": _logisticAgents.map((e) => e.toJson()).toList(),
    };
    print(postData);
    //return;
    /* print(postData);
    sendErrorEmail('ceci est un test ');
    EasyLoading.dismiss();
    return; */
    Navigator.pop(context);
    EasyLoading.show(status: 'Envoie de la livraison...');
    await RemoteService()
        .postData(
      endpoint: 'livraisons',
      postData: postData,
    )
        .then((response) async {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _logisticAgents.clear();
        Functions.showToast(
          msg: 'Livraison enregistrée avec succès',
          gravity: ToastGravity.TOP,
        );
        // recuperer l'id dans response.body
        //var data = jsonDecode(response.body);
        //var id = data['data']['id'];

        ////////////////////////
        ///pas necessaire

        ////////////////////////
        EasyLoading.dismiss();
        _pageController.animateToPage(
          0,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
        );
        _clearControllers();
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushNamed(
          context,
          DeliverySucess.routeName,
          arguments: _motif,
        );
      } else {
        sendErrorEmail(
          subject: 'Erreur d\'enregistrement de livraison',
          title:
              'Une erreur s\'est produite lors de l\'enregistrement d\'une livraison',
          errorDetails:
              '\n\nPosted data: $postData\n\nStatus code: ${response.statusCode}\n\nResponse body: ${response.body}',
        );
        Functions.showToast(
          msg: 'Une erreur s\'est produite',
          gravity: ToastGravity.TOP,
        );
      }
    });
    EasyLoading.dismiss();
  }

  // AgentModel? _agent;

  void _clearControllers() {
    setState(() {
      _entrepriseController.clear();
      _nameController.clear();
      _prenomsController.clear();
      _idCardController.clear();
      _phoneController.clear();
      _emailController.clear();
      _numtracteurController.clear();
      _numConteneurController.clear();
      _numremorqueController.clear();
      _commentaireController.clear();
      _badgeController.clear();
      _designationController.clear();
      _docRefController.clear();
      _numPlombController.clear();
      _typeEnginController.clear();
      _marqueController.clear();
      _pieceValidController.clear();
    });
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

  /* _mouvementSelector() {
    List<String> _mouvements = [
      "Entrée",
      "Sortie",
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
                children: _mouvements.map((mouvement) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _mouvement = mouvement;
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
                            color: mouvement == _mouvement
                                ? Palette.primaryColor
                                : Colors.white,
                          ),
                        ),
                      ),
                      child: AppText.medium(
                        mouvement,
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
 */
  _formatVehiculeSelector() {
    List<Map<String, dynamic>> _formatVehicules = [
      {
        "label": "Avec tracteur",
        "value": "Tracteur",
        "desc":
            "Ceci concerne les entrées/sorties de livraisons lorsque l'engin est composé d'un tracteur et ou une remorque et un conteneur.",
      },
      {
        "label": "Sans tracteur",
        "value": "VL",
        "desc":
            "Ceci concerne les entrées/sorties de livraisons lorsque l'engin est composé d'un simple véhicule. (ex: véhicule léger, moto, véhicule poids lourd, etc.)",
      }
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
                children: _formatVehicules.map((format) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _formatVehicule = format['value'];
                        _isWithTracteur = format['value'] == 'Tracteur';
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      //height: 40,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 3,
                            color: format['value'] == _formatVehicule
                                ? Palette.primaryColor
                                : Colors.white,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.medium(
                            format['label'],
                            textAlign: TextAlign.left,
                          ),
                          AppText.small(format['desc']),
                        ],
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

  Container _idCardTypeSelector() {
    List<String> _pieces = [
      "CNI",
      "Permis",
      "Passeport",
      "Attestation",
      "Carte consulaire",
      "Carte CMU",
      "Carte professionnelle",
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

  void _setIfons({required VehiculeModel v}) {
    setState(() {
      _numtracteurController.text = v.numeroImmatriculation;
      _nameController.text = v.nom ?? '';
      _prenomsController.text = v.prenoms ?? '';
      _idCardType = v.typePiece ?? 'CNI';
      _idCardController.text = v.numeroPiece ?? '';
      _pieceValidController.text = v.validitePiece?.toString() ?? '';
      _numremorqueController.text = v.numeroRemorque ?? '';
      _numConteneurController.text = v.numeroConteneur ?? '';
      _typeEnginController.text = v.typeEngin ?? '';
      _marqueController.text = v.marque ?? '';
      _entrepriseController.text = v.entreprise ?? '';
    });
  }
}
