import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../config/app_text.dart';
import '../../config/functions.dart';
import '../../config/palette.dart';
import '../../draggable_menu.dart';
import '../../model/agent_model.dart';
import '../../remote_service/remote_service.dart';
import '../../widgets/custom_button.dart';
import '../scanner/widgets/infos_column.dart';

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
  final _numremorqueController = TextEditingController();
  final _commentaireController = TextEditingController();
  final _badgeController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  List<String> _colisList = [
    'Alimentaire',
    'Dangereux',
    'Pharmaceutique',
    'Palettisés',
    'Isotherme',
  ];
  String _selectedColis = 'Alimentaire';

/* // création d'une livraison par un agent de sécurité
  Object postData = const {
    //foreign keys
    'localisation_id': 1,
    'user_id': 1,
    //infos livraison
    'date_visite': '12/03/2024',
    'date_fin_visite': '12/03/2024',
    'type_colis': 'type de colis',
    'entreprise': 'entreprise du livreur',
    //infos du livreur
    'nom': 'nom du livreur si renseigné',
    'prenoms': 'prenoms du livreur si renseigné',
    'carte_cni': 'carte_cni du livreur si renseigné',
    'telephone': 'telephone du livreur',
    'email': 'email du livreur si renseigné',
  }; */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevent keyboard from resizing the content
      appBar: AppBar(
        title: AppText.medium('Nouvelle livraison'),
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
                  if (_entrepriseController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Entreprise requise', gravity: ToastGravity.TOP);
                    return;
                  }
                  if (_numtracteurController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Numéro de tracteur requis',
                        gravity: ToastGravity.TOP);
                    return;
                  }
                  if (_numremorqueController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Numéro de remorque requis',
                        gravity: ToastGravity.TOP);
                    return;
                  }
                  if (!_colisList.contains(_selectedColis)) {
                    Functions.showToast(
                        msg: 'Type de colis requis', gravity: ToastGravity.TOP);
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
                  if (_phoneController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Renseigner le numéro de téléphone',
                        gravity: ToastGravity.TOP);
                    return;
                  }

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
        children: List.generate(2, (index) {
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
          0.7, // Hauteur fixe pour le PageView, à ajuster si nécessaire
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            activeIndex = index;
          });
        },
        children: [_deliGeneraleInfos(), _deliBoyInfos()],
      ),
    );
  }

  Column _deliBoyInfos() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.large('Informations du livreur'),
          AppText.small(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
          ),
          const SizedBox(
            height: 10,
          ),
          _cardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.medium('Générales'),
                const SizedBox(height: 10),
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
                  label: 'N° CNI',
                  widget: Expanded(
                    child: Functions.getTextField(
                      controller: _idCardController,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _cardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.medium('Coordonnées'),
                const SizedBox(height: 10),
                InfosColumn(
                  opacity: 0.12,
                  label: 'Portable',
                  widget: Expanded(
                    child: Container(
                      child: Row(
                        children: [
                          AppText.medium('+225 '),
                          Expanded(
                            child: Functions.getTextField(
                              controller: _phoneController,
                            ),
                          ),
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
                  opacity: 0.12,
                  label: 'Courriel',
                  widget: Expanded(
                    child: Functions.getTextField(
                      controller: _emailController,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Column _deliGeneraleInfos() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.large('Informations de livraison'),
          AppText.small(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
          ),
          const SizedBox(
            height: 10,
          ),
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
                        label: 'Date',
                        widget: Expanded(
                          child: AppText.medium(
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
                const SizedBox(height: 10),
                CustomButton(
                  color: Palette.primaryColor.withOpacity(0.06),
                  textColor: Palette.primaryColor,
                  width: double.infinity,
                  height: 35,
                  radius: 5,
                  text: 'Changer les dates',
                  // onPress: () => _pickDateRange(context),
                  onPress: () => Functions.showToast(
                    msg:
                        'Veuillez contacter votre responsable pour la création d\'une livraison planifiée',
                    gravity: ToastGravity.TOP,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          _cardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.medium('Type de colis et Entreprise'),
                const SizedBox(height: 10),
                InfosColumn(
                  opacity: 0.12,
                  label: 'Type de colis',
                  widget: Expanded(
                    child: InkWell(
                      onTap: () => Functions.showBottomSheet(
                        ctxt: context,
                        widget: _colisSelector(),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppText.medium(_selectedColis),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                          ),
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
                  opacity: 0.12,
                  label: 'Entreprise',
                  widget: Expanded(
                    child: Functions.getTextField(
                      controller: _entrepriseController,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AppText.medium('Tracteur & Remorque (conteneur)'),
                Row(
                  children: [
                    Expanded(
                      child: InfosColumn(
                        opacity: 0.12,
                        label: 'N° tracteur',
                        widget: Expanded(
                          child: Functions.getTextField(
                            controller: _numtracteurController,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: InfosColumn(
                        opacity: 0.12,
                        label: 'N° remorque',
                        widget: Expanded(
                          child: Functions.getTextField(
                              controller: _numremorqueController),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );

  Container _colisSelector() => Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: ListView.builder(
          itemCount: _colisList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_colisList[index]),
              selected: _selectedColis == _colisList[index],
              selectedColor: Palette.primaryColor,
              onTap: () {
                setState(() {
                  _selectedColis = _colisList[index];
                });
                Navigator.pop(context);
              },
            );
          },
        ),
      );

  /*  void _pickDateRange(BuildContext context) async {
    final dateRange = await showCustomDateRangePicker(context);
    if (dateRange != null) {
      /* print("Start Date: ${dateRange['start']}");
      print("End Date: ${dateRange['end']}"); */
      setState(() {
        _startDate = dateRange['start']!;
        _endDate = dateRange['end']!;
      });
    } else {
      print("No date range selected");
    }
  } */

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
        height: MediaQuery.of(context).size.height * 0.5,
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
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
                    ),
                    InfosColumn(
                      label: 'n° de téléphone',
                      // opacity: 0.12,
                      widget: Expanded(
                        child: AppText.medium(_phoneController.text),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
                    ),
                    InfosColumn(
                      label: 'Email',
                      widget: Expanded(
                        child: Functions.getTextField(
                            controller: _emailController),
                      ),
                      // opacity: 0.12,
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
                    ),
                    InfosColumn(
                      label: 'n° CNI',
                      widget: Expanded(
                        child: Functions.getTextField(
                            controller: _idCardController),
                      ),
                      // opacity: 0.12,
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
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
                            label: 'N° tracteur',
                            widget: Expanded(
                              child: AppText.medium(
                                _numtracteurController.text,
                              ),
                            ),
                          ),
                        ),
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
                      ],
                    ),
                    InfosColumn(
                      label: 'Entreprise',
                      widget: Expanded(
                        child: AppText.medium(_entrepriseController.text),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Palette.separatorColor,
                    ),
                    InfosColumn(
                      label: 'Motif de la visite',
                      widget: Expanded(
                        child: AppText.medium(_selectedColis),
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
                  showAdaptiveModalDialog(context, _phoneController.text);
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
        return WillPopScope(
          onWillPop: () async => false,
          child: Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text('Attention'),
                  content: Column(
                    children: [
                      Text(
                        'Veuillez renseigner le numéro de badget si le livreur en a réçu',
                      ),
                      const SizedBox(height: 5),
                      CupertinoTextField(
                        controller: _badgeController,
                        /* onChanged: (value) {
                          print(_badgeController.text);
                        }, */
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: AppText.medium(
                        'Annuler',
                        color: Color.fromARGB(255, 142, 4, 25),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Add your "Créer" button action here
                        AgentModel? _agent = await Functions.fetchAgent();
                        if (_agent == null) {
                          Functions.showToast(
                            msg: 'Veuillez une erreur s\'est produite',
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }
                        _postVisit(agent: _agent);
                      },
                      child: AppText.medium(
                        'Créer',
                        color: Palette.primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text('Attention'),
                  content: Container(
                    child: Column(
                      children: [
                        Text(
                          'Veuillez renseigner le numéro de badget si le livreur en a réçu',
                        ),
                        const SizedBox(height: 5),
                        InfosColumn(
                          label: 'N° badget',
                          widget: Functions.getTextField(
                            controller: _badgeController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: AppText.medium(
                        'Annuler',
                        color: Color.fromARGB(255, 142, 4, 25),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Add your "Créer" button action here
                        AgentModel? _agent = await Functions.fetchAgent();
                        if (_agent == null) {
                          Functions.showToast(
                            msg: 'Veuillez une erreur s\'est produite',
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }
                        _postVisit(agent: _agent);
                      },
                      child: AppText.medium(
                        'Créer',
                        color: Palette.primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  //
  void _postVisit({required AgentModel agent}) async {
    // création d'une visite par un agent de sécurité
    final String hours = DateFormat('HH:mm:ss', 'fr_FR').format(
      DateTime.now(),
    );
    var postData = {
      "id": 1,
      "user_id": agent.id,
      "localisation_id": agent.localisation.id,
      "active": 1,
      "nom": _nameController.text,
      "prenoms": _prenomsController.text,
      /* "num_bon": 'BC$random', */
      "numero_remorque": _numremorqueController.text,
      "immatriculation": _idCardController.text,
      "telephone": _phoneController.text,
      "email": _emailController.text,
      "entreprise": _entrepriseController.text,
      "type_colis": _selectedColis,
      "statut_livraison": 1,
      "heure_entree": hours,
      "date_visite": _startDate.toString(),
      "date_fin_visite": _endDate.toString(),
      "status": "En cours",
      "numero_tracteur": _numtracteurController.text,
      "date_livraison": DateTime.now().toIso8601String(),
    };
    Navigator.pop(context);
    EasyLoading.show(status: 'Envoie de la livraison...');
    await RemoteService()
        .postData(
      endpoint: 'livraisons',
      postData: postData,
    )
        .then((response) async {
      /* print(response.statusCode);
      print(response.body); */
      if (response.statusCode == 200 || response.statusCode == 201) {
        Functions.showToast(
          msg: 'Visite enregistrée avec succès',
          gravity: ToastGravity.TOP,
        );
        // recuperer l'id dans response.body
        var data = jsonDecode(response.body);
        var id = data['data']['id'];
        await _handleDeliEntry(id: id, agentId: agent.id)
            .whenComplete(() async {
          ////////////////////////
          ///pas necessaire
          Map<String, dynamic> data = {
            "status": "En cours",
            "statut_livraison": 1,
          };
          await RemoteService().putSomethings(
            api: 'livraisons/${id}',
            data: data,
          );
          ////////////////////////
          _pageController.animateToPage(
            0,
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
          );
          _clearControllers();
        });
      } else {
        Functions.showToast(
          msg: 'Une erreur s\'est produite',
          gravity: ToastGravity.TOP,
        );
      }
    });
    EasyLoading.dismiss();
  }

  _handleDeliEntry({required int id, required agentId}) async {
    String hours = DateFormat('HH:mm', 'fr_FR').format(
      DateTime.now(),
    );

    // CREATE HISTORY
    Map<String, dynamic> _livraisonCount = {
      "livraison_id": id,
      "scan_date": DateTime.now().toIso8601String(),
      "scan_hour": hours,
      "user_id": agentId,
      "motif": "Entrée",
      "plaque_immatriculation": _numtracteurController.text,
      "commentaire": _commentaireController.text,
      "numero_badge": _badgeController.text,
    };
    RemoteService().postData(
      endpoint: 'scanLivraisons',
      postData: _livraisonCount,
    );
  }

  String generateRandomNumber() {
    final Random random = Random();
    final int length = 8 + random.nextInt(6); // Génère un nombre entre 8 et 13
    final StringBuffer randomNumber = StringBuffer();

    for (int i = 0; i < length; i++) {
      randomNumber.write(random.nextInt(10)); // Ajoute un chiffre entre 0 et 9
    }

    return randomNumber.toString();
  }

  // AgentModel? _agent;

  void _clearControllers() {
    setState(() {
      _nameController.clear();
      _prenomsController.clear();
      _emailController.clear();
      _phoneController.clear();
      _idCardController.clear();
      _numtracteurController.clear();
      _numremorqueController.clear();
      _commentaireController.clear();
      _badgeController.clear();
      _entrepriseController.clear();
    });
  }
}
