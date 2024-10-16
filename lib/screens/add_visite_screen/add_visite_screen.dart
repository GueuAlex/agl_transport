import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scanner/widgets/sheet_closer.dart';

import '../../config/app_text.dart';
import '../../config/functions.dart';
import '../../config/palette.dart';
import '../../draggable_menu.dart';
import '../../emails/emails_service.dart';
import '../../local_service/local_service.dart';
import '../../model/DeviceModel.dart';
import '../../model/agent_model.dart';
import '../../model/motif_model.dart';
import '../../remote_service/remote_service.dart';
import '../../widgets/all_sheet_header.dart';
import '../../widgets/custom_button.dart';
import '../scanner/widgets/infos_column.dart';

class AddVisiteScreen extends StatefulWidget {
  static const routeName = 'CreateVisitScreen';
  const AddVisiteScreen({super.key});

  @override
  State<AddVisiteScreen> createState() => _AddVisiteScreenState();
}

class _AddVisiteScreenState extends State<AddVisiteScreen> {
  int activeIndex = 0;
  final PageController _pageController = PageController();
  String _selectedGenre = 'Monsieur';

  final _nameController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idcardController = TextEditingController();
  final _cardIdController = TextEditingController();
  //final _motifController = TextEditingController();
  final _entrepriseController = TextEditingController();
  //final _badgeController = TextEditingController();
  //final _giletController = TextEditingController();

  //
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _idCardType = 'CNI';

  MotifModel _selectedMotif = MotifModel.glogalModitif[0];
  AgentModel _selectedAmin = AgentModel.globalAgent[0];
  // List<MotifModel> _motifs = [];
/*   Future<List<MotifModel>> _getMotifs() async {
    final motifs = await RemoteService().getMotifList();
    //print(motifs);
    setState(() {
      _selectedMotif = motifs[0];
    });
    return motifs;
  } */

  /*  Future<List<AgentModel>> _admins() async {
    final admins = await RemoteService().getAdmins();
    //print(motifs);
    setState(() {
      _selectedAmin = admins[0];
    });
    return admins;
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Prevent keyboard from resizing the content
      appBar: AppBar(
        title: AppText.medium('Nouvelle visite'),
        leading: Container(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraint) {
              return SizedBox.expand(
                child: Column(
                  children: [
                    _buildProgressIndicator(),
                    _buildPageView(constraints: constraint),
                    _buildNavigationButtons(),
                  ],
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
      height: constraints.maxHeight * 0.7,
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            activeIndex = index;
          });
        },
        children: [
          _buildPageContent(child: _generaInfo()),
          _buildPageContent(child: _coordonnees()),
          _buildPageContent(child: _visiteDetails()),
        ],
      ),
    );
  }

  Widget _visiteDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large('Détails de la visite'),
            AppText.small(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
            ),
            const SizedBox(height: 10),
            _cardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium('Date et heure de la visite'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InfosColumn(
                          label: 'Date début',
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
                              DateFormat('HH:mm:ss').format(DateTime.now()),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  /*  CustomButton(
                    color: Palette.primaryColor.withOpacity(0.06),
                    textColor: Palette.primaryColor,
                    width: double.infinity,
                    height: 35,
                    radius: 5,
                    text: 'Changer les dates',
                    //onPress: () => _pickDateRange(context),
                    onPress: () => Functions.showToast(
                      msg:
                          'Veuillez contacter votre responsable pour la création d\'une visite planifiée',
                      gravity: ToastGravity.TOP,
                    ),
                  ) */
                ],
              ),
            ),
            const SizedBox(height: 10),
            _cardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium('Entreprise, motif & accessoires'),
                  InfosColumn(
                    label: 'Entreprise',
                    opacity: 0.12,
                    widget: Expanded(
                      child: Functions.getTextField(
                          controller: _entrepriseController),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.8,
                    color: Palette.separatorColor,
                  ),
                  InkWell(
                    onTap: () => Functions.showBottomSheet(
                      ctxt: context,
                      widget: _motifSelector(),
                    ),
                    child: InfosColumn(
                      // height: 80,
                      label: 'Motif de la visitée',
                      opacity: 0.12,
                      widget: Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: AppText.medium(
                                  maxLine: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                  //_selectedMotif != null
                                  //?
                                  _selectedMotif.libelle
                                  // : "Selectionner un motif",
                                  ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
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
                  AppText.medium('Qui autorise cette visite ?'),
                  AppText.small(
                      'Vuillez indiquer l\'administrateur qui autorise la visite'),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () => Functions.showBottomSheet(
                      ctxt: context,
                      widget: _adminSelector(),
                    ),
                    child: InfosColumn(
                      // height: 80,
                      label: 'Admin',
                      opacity: 0.12,
                      widget: Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: AppText.medium(
                                  maxLine: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                  //_selectedAmin != null
                                  //?
                                  _selectedAmin.name
                                  //: "Selectionner un admin",
                                  ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _adminSelector() => Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
            child: ListView.builder(
              itemCount: AgentModel.globalAgent.length,
              itemBuilder: (context, index) {
                AgentModel agent = AgentModel.globalAgent[index];
                return ListTile(
                  title: Text(agent.name),
                  selected: _selectedAmin.id == agent.id,
                  selectedColor: Palette.primaryColor,
                  onTap: () {
                    setState(() {
                      _selectedAmin = agent;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ));

  Container _motifSelector() => Container(
      height: MediaQuery.of(context).size.height * 0.45,
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
            child: ListView.builder(
              itemCount: MotifModel.glogalModitif.length,
              itemBuilder: (context, index) {
                MotifModel motif = MotifModel.glogalModitif[index];
                return ListTile(
                  title: Text(motif.libelle),
                  selected: _selectedMotif.libelle == motif.libelle,
                  selectedColor: Palette.primaryColor,
                  onTap: () {
                    setState(() {
                      _selectedMotif = motif;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ));

  Padding _coordonnees() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large('Coordonnées'),
            AppText.small(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
            ),
            const SizedBox(height: 10),
            _cardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium('Email et/ou numéro de téléphone'),
                  const SizedBox(height: 10),
                  InfosColumn(
                    label: 'Email',
                    widget: Expanded(
                      child:
                          Functions.getTextField(controller: _emailController),
                    ),
                    opacity: 0.12,
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.8,
                    color: Palette.separatorColor,
                  ),
                  InfosColumn(
                    label: 'n° de téléphone',
                    widget: Expanded(
                      child:
                          Functions.getTextField(controller: _phoneController),
                    ),
                    opacity: 0.12,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            _cardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium('Identifiants'),
                  const SizedBox(height: 10),
                  InfosColumn(
                    label: 'N° de la piéce',
                    widget: Expanded(
                      child:
                          Functions.getTextField(controller: _idcardController),
                    ),
                    opacity: 0.12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InfosColumn(
                          label: 'Type de pièce',
                          widget: Expanded(
                            child: InkWell(
                              onTap: () => Functions.showBottomSheet(
                                ctxt: context,
                                widget: _idCardTypeSelector(),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AppText.medium(_idCardType),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          opacity: 0.12,
                        ),
                      ),
                      Expanded(
                          child: InfosColumn(
                        label: 'Palaque d\'immatriculation',
                        widget: Expanded(
                          child: Functions.getTextField(
                              controller: _cardIdController),
                        ),
                        opacity: 0.12,
                      ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _generaInfo() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.large('Informations générales'),
              AppText.small(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
              ),
              const SizedBox(height: 10),
              _cardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.medium('Genre'),
                    const SizedBox(height: 10),
                    _genderSelector(genre: 'Monsieur'),
                    _genderSelector(genre: 'Madame'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _cardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.medium('Nom et prénoms'),
                    const SizedBox(height: 5),
                    InfosColumn(
                      opacity: 0.12,
                      label: 'Nom',
                      widget: Expanded(
                        child: Functions.getTextField(
                          controller: _nameController,
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
                      label: 'Prénoms',
                      widget: Expanded(
                        child: Functions.getTextField(
                          controller: _prenomsController,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
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

  Widget _genderSelector({required String genre}) {
    bool isSelected = _selectedGenre == genre;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGenre = genre;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? Palette.primaryColor.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(6.5),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: isSelected
                      ? Palette.primaryColor
                      : Color.fromARGB(255, 185, 185, 185),
                ),
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            AppText.medium(
              genre,
              color: isSelected
                  ? Palette.primaryColor
                  : Color.fromARGB(255, 159, 159, 159),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent({required Widget child}) {
    return child;
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
                // a l'index 0, on vérifie que les champs nom et prenoms
                if (activeIndex == 0) {
                  if (_nameController.text.trim().isEmpty) {
                    Functions.showToast(
                      msg: 'Veuillez renseigner le nom',
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }
                  if (_prenomsController.text.trim().isEmpty) {
                    Functions.showToast(
                      msg: 'Veuillez renseigner le prénom',
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                // a l'index 1, on vérifie que le numéro de téléphone est renseigné
                if (activeIndex == 1) {
                  if (_phoneController.text.trim().isEmpty) {
                    Functions.showToast(
                      msg: 'Veuillez renseigner un numéro de téléphone',
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }
                  if (_phoneController.text.trim().length != 10) {
                    Functions.showToast(
                      msg: 'Veuillez renseigner un numéro de téléphone valide',
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }

                  if (_idcardController.text.trim().isEmpty) {
                    Functions.showToast(
                      msg: 'Veuillez renseigner le numéro de la piéce',
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                if (activeIndex == 2) {
                  if (_entrepriseController.text.trim().isEmpty) {
                    Functions.showToast(
                      msg: 'Veuillez renseigner l\'entreprise',
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }
                  /* if (_selectedMotif == null) {
                    Functions.showToast(
                      msg: 'Veuillez sélectionner un motif de visite',
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }
                  if (_selectedAmin == null) {
                    Functions.showToast(
                      msg: 'Veuillez sélectionner un admin',
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  } */
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
                    AppText.medium('Informations générales'),
                    InfosColumn(
                      label: 'Genre',
                      // opacity: 0.12,
                      widget: Expanded(
                        child: AppText.medium(_selectedGenre),
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        height: 0.8,
                        color: Palette.separatorColor),
                    Row(
                      children: [
                        Expanded(
                            child: InfosColumn(
                          label: 'Noms',
                          //opacity: 0.12,
                          widget: Expanded(
                            child: AppText.medium(
                              _nameController.text,
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
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppText.medium('Coordonnées'),
                    const SizedBox(height: 10),
                    InfosColumn(
                      label: 'n° de téléphone',
                      widget: Expanded(
                        child: AppText.medium(_phoneController.text),
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
                            label: 'N° de la piéce',
                            widget: Expanded(
                              child: AppText.medium(
                                _idcardController.text,
                              ),
                            ),
                            //opacity: 0.12,
                          ),
                        ),
                        Expanded(
                          child: InfosColumn(
                            label: 'Type de la piéce',
                            widget: Expanded(
                              child: AppText.medium(
                                _idCardType,
                              ),
                            ),
                            //opacity: 0.12,
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
                      label: 'n° d\'immatriculation',
                      widget: Expanded(
                        child: AppText.medium(
                          _cardIdController.text,
                        ),
                      ),
                      //opacity: 0.12,
                    ),
                    const SizedBox(height: 10),
                    AppText.medium('Détails de la visite'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            label: 'Du',
                            widget: Expanded(
                              child: AppText.medium(
                                  DateFormat('EE dd MMM yyyy', 'fr')
                                      .format(_startDate)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InfosColumn(
                            label: 'Au',
                            widget: Expanded(
                              child: AppText.medium(
                                  DateFormat('EE dd MMM yyyy', 'fr')
                                      .format(_endDate)),
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
                            label: 'Entreprise',
                            widget: Expanded(
                              child: AppText.medium(_entrepriseController.text),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InfosColumn(
                            label: 'Motif de la visite',
                            widget: Expanded(
                              child: AppText.medium(_selectedMotif.libelle),
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*  Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            label: 'N° de badge',
                            widget: Expanded(
                              child: AppText.medium(_badgeController.text),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InfosColumn(
                            label: 'Motif de la visite',
                            widget: Expanded(
                              child: AppText.medium(_giletController.text),
                            ),
                          ),
                        ),
                      ],
                    ), */
                    InfosColumn(
                      label: 'Visite autorisée par',
                      widget: Expanded(
                        child: AppText.medium(_selectedAmin.name),
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
                  showAdaptiveModalDialog(
                    context,
                    _phoneController.text,
                  );
                },
              ),
            )
          ],
        ),
      );

  void showAdaptiveModalDialog(BuildContext context, String phone) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async => false,
          child: Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text('Attention'),
                  content: Text(
                      'Le visiteur recevra un SMS sur le $phone contenant un code d\'accès à présenter avant son accès au site.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: AppText.medium(
                        'Annuler',
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 142, 4, 25),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Add your "Créer" button action here
                        LocalService localService = LocalService();
                        DeviceModel? _device = await localService.getDevice();
                        AgentModel? _agent = await Functions.fetchAgent();
                        if (_agent == null) {
                          Functions.showToast(
                            msg: 'Une erreur s\'est produite',
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }
                        if (_device == null) {
                          Functions.showToast(
                            msg: 'Une erreur s\'est produite',
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }
                        _postVisit(
                          agent: _agent,
                          device: _device,
                          admin: _selectedAmin,
                        );
                      },
                      child: AppText.medium(
                        'Créer',
                        fontWeight: FontWeight.w400,
                        color: Palette.primaryColor,
                      ),
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text('Attention'),
                  content: Text(
                      'Le visiteur recevra un SMS sur le $phone contenant un code d\'accès à présenter avant son accès au site.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: AppText.medium(
                        'Annuler',
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 142, 4, 25),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Add your "Créer" button action here
                        LocalService localService = LocalService();
                        DeviceModel? _device = await localService.getDevice();
                        AgentModel? _agent = await Functions.fetchAgent();
                        if (_agent == null) {
                          Functions.showToast(
                            msg: 'Une erreur s\'est produite',
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }
                        if (_device == null) {
                          Functions.showToast(
                            msg: 'Une erreur s\'est produite',
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }
                        _postVisit(
                            agent: _agent,
                            device: _device,
                            admin: _selectedAmin);
                      },
                      child: AppText.medium(
                        'Créer',
                        fontWeight: FontWeight.w400,
                        color: Palette.primaryColor,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _postVisit(
      {required AgentModel agent,
      required AgentModel admin,
      required DeviceModel device}) async {
    // création d'une visite par un agent de sécurité
    String hour = DateFormat('HH:mm:ss').format(DateTime.now());
    var postData = {
      "genre": _selectedGenre,
      "user_id": agent.id,
      "admin_id": admin.id,
      "motif_id": _selectedMotif.id,
      "nom": _nameController.text,
      "prenoms": _prenomsController.text,
      "entreprise": _entrepriseController.text,
      "date_visite": _startDate.toString(),
      "heure_visite": hour,
      "date_fin_visite": _endDate.toString(),
      "numero_piece": _idcardController.text.toUpperCase(),
      "type_piece": _idCardType,
      "type_visiteur": "Visiteur",
      //"numero_badge": _badgeController.text,
      // "numero_gilet": _giletController.text,
      "plaque_vehicule": _cardIdController.text.toUpperCase(),
      /* "email": _emailController.text, */
      "number": _phoneController.text,
      "motif_visite": _selectedMotif.libelle,
      /* "code_visite": "AG-24-4781300", */
      "is_already_scanned": 0,
      "is_active": 1,
      "localisation_id": device.localisationId,
      /*  "localisation": {
        "id": device.localisationId,
        /*  "libelle": agent.localisation.libelle, */
        "site_id": device.siteId,
      },
      "motif": {
        "id": _selectedMotif!.id,
        "libelle": _selectedMotif!.libelle,
      } */
    };

    /* print(postData);
    EasyLoading.dismiss();
    return; */
    print(postData);
    Navigator.pop(context);
    /* print(postData);
    return; */

    EasyLoading.show(status: 'Envoie de la visite...');
    await RemoteService()
        .postData(
      endpoint: 'visiteurs',
      postData: postData,
    )
        .then((response) {
      print(response.statusCode);
      print(response.body);
      EasyLoading.dismiss();
      if (response.statusCode == 200 || response.statusCode == 201) {
        Functions.showToast(
          msg: 'Visite enregistrée avec succès',
          gravity: ToastGravity.TOP,
        );
        EasyLoading.dismiss();
        _pageController.animateToPage(
          0,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
        );
        _clearControllers();
      } else {
        sendErrorEmail(
          subject: 'Erreur d\'enregistrement d\'une visite',
          title:
              'Une erreur s\'est produite lors de l\'enregistrement d\'une visite',
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

  void _clearControllers() {
    setState(() {
      _nameController.clear();
      _prenomsController.clear();
      _emailController.clear();
      _phoneController.clear();
      _idcardController.clear();
      _cardIdController.clear();
    });
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
}
