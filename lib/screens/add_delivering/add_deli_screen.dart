import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:scanner/screens/scanner/widgets/infos_column.dart';
import 'package:scanner/screens/side_bar/open_side_dar.dart';

import '../../config/app_text.dart';
import '../../config/functions.dart';
import '../../config/palette.dart';
import '../../draggable_menu.dart';
import '../../model/agent_model.dart';
import '../../model/agl_livraison_model.dart';
import '../../model/tracteur_modal.dart';
import '../../remote_service/remote_service.dart';
import '../../widgets/custom_button.dart';

class AddDeliScree extends StatefulWidget {
  static String routeName = 'add_deli_screen';
  const AddDeliScree({super.key});

  @override
  State<AddDeliScree> createState() => _AddDeliScreeState();
}

class _AddDeliScreeState extends State<AddDeliScree> {
  AglLivraisonModel? _widgetDeli;
  TracteurModel? _tracteur;
  bool showForm = false;

  // Text Editing Controllers

  final TextEditingController _numTracteurController = TextEditingController();
  final TextEditingController _numRemorqueController = TextEditingController();
  // update controllers
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomsController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController idCardController = TextEditingController();
  final TextEditingController _badgeController = TextEditingController();
  final TextEditingController _commentaireController = TextEditingController();

  @override
  void dispose() {
    _numTracteurController.dispose();
    _numRemorqueController.dispose();
    nomController.dispose();
    prenomsController.dispose();
    telController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initialActions();
    super.initState();
  }

  void _initialActions() async {
    EasyLoading.show();
    await TracteurModel.getTracteurListFromApi().whenComplete(() {
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
          _widgetDeli != null
              ? Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Palette.primaryColor,
                  ),
                  padding: const EdgeInsets.all(0),
                  child: InkWell(
                    onTap: () {
                      if (_widgetDeli!.status.toLowerCase() == 'terminée') {
                        Functions.showToast(
                          msg: 'Livraison déjà terminée',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }
                      Functions.showPlatformDialog(
                        context: context,
                        onCancel: () => Navigator.pop(context),
                        onConfirme: () {
                          if (!_widgetDeli!.statutLivraison) {
                            _handleDeliEntry();
                          } else {
                            _handleDeliOut();
                          }
                        },
                        title: AppText.medium(
                          'Confirmation',
                          textAlign: TextAlign.center,
                        ),
                        content: Container(
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.5,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                        controller: _badgeController),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                )
              : Container(),
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
              onTap: () => Functions.showBottomSheet(
                ctxt: context,
                widget: _formSheet(),
              ),
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
      body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
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
                                    color:
                                        Palette.primaryColor.withOpacity(0.05),
                                    width: double.infinity,
                                    height: 35,
                                    radius: 5,
                                    text: 'Réessayer',
                                    textColor: Palette.primaryColor,
                                    onPress: () => _showBonCommandeSheet(),
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
      }),
    );
  }

  Column _deliDetails({required AglLivraisonModel deli}) {
    return Column(
      children: [
        _deliStatutBar(delisStatus: deli.status),
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
                                    controller: nomController,
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
                                    controller: prenomsController,
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
                              controller: telController,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.8,
                          color: Palette.separatorColor,
                        ),
                        InfosColumn(
                          label: 'N° de carte d\'identité',
                          opacity: 0.12,
                          widget: Expanded(
                            child: Functions.getTextField(
                              controller: idCardController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _cardContainer(
                      child: SizedBox(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium('Quelque chose a noté ?'),
                        Expanded(
                          child: InfosColumn(
                            opacity: 0.12,
                            label: 'Écrivez un commentaire',
                            widget: Expanded(
                              child: Functions.getTextField(
                                maxLines: 5,
                                controller: _commentaireController,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 10),
                  // date et heure de livraison
                  _cardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium('Date et heure de livraison'),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                label: 'Heure d\'entrée',
                                widget: Expanded(
                                  child: AppText.medium(
                                    _widgetDeli!.heureEntree,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InfosColumn(
                                label: 'Heure de sortie',
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
                        InfosColumn(
                          label: 'Date de livraison',
                          widget: Expanded(
                            child: AppText.medium(
                              '${DateFormat('EE dd MMM yyyy', 'fr').format(
                                _widgetDeli!.dateVisite,
                              )}',
                            ),
                          ),
                        )
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
                          'Entreprise et Type de colis',
                        ),
                        InfosColumn(
                          label: 'Entreprise',
                          widget: Expanded(
                            child: AppText.medium(
                              _widgetDeli!.entreprise,
                            ),
                          ),
                        ),
                        InfosColumn(
                          label: 'Type de colis',
                          widget: Expanded(
                            child: AppText.medium(
                              _widgetDeli!.typeColis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  //vehicule de livraison
                  _cardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium('Livraison'),
                        InfosColumn(
                          label: "N° du tracteur",
                          widget: Expanded(
                            child: AppText.medium(_tracteur!.numeroTracteur),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.8,
                          color: Palette.separatorColor,
                        ),
                        InfosColumn(
                          label: "N° de conteneur / Remorque",
                          widget: Expanded(
                            child: AppText.medium(_widgetDeli!.numeroRemorque),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      if (_widgetDeli!.status.toLowerCase() == 'terminée') {
                        Functions.showToast(
                          msg: 'Livraison déjà terminée',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }
                      Functions.showPlatformDialog(
                        context: context,
                        onCancel: () => Navigator.pop(context),
                        onConfirme: () {
                          if (!_widgetDeli!.statutLivraison) {
                            _handleDeliEntry();
                          } else {
                            _handleDeliOut();
                          }
                        },
                        title: AppText.medium(
                          'Confirmation',
                          textAlign: TextAlign.center,
                        ),
                        content: Container(
                          // Limiter la hauteur maximale du contenu
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.5,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                      controller: _badgeController,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
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

  _handleDeliEntry() async {
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
      "heure_entree": hours,
      "statut_livraison": 1,
      "telephone": telController.text,
      "date_livraison": DateTime.now().toIso8601String(),
      "status": "En cours",
      "numero_cni": idCardController.text,
    };

    // CREATE HISTORY
    Map<String, dynamic> _livraisonCount = {
      "livraison_id": _widgetDeli!.id,
      "user_id": _agent.id,
      "scan_date": DateTime.now().toIso8601String(),
      "scan_hour": hours,
      "motif": "Entrée",
      "plaque_immatriculation": _tracteur!.numeroTracteur,
      "commentaire": _commentaireController.text,
      "numero_badge": _badgeController.text,
    };

    await RemoteService()
        .putSomethings(
      api: 'livraisons/${_widgetDeli!.id}',
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
          _widgetDeli!.statutLivraison = true;
          _widgetDeli!.status = 'En cours';
        });
      });
    });
  }

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
      "telephone": telController.text,
      "status": "Terminée",
      "numero_cni": idCardController.text,
    };

    // CREATE HISTORY
    Map<String, dynamic> _livraisonCount = {
      "livraison_id": _widgetDeli!.id,
      "scan_date": DateTime.now().toIso8601String(),
      "user_id": _agent.id,
      "scan_hour": hours,
      "motif": "Sortie",
      "plaque_immatriculation": _tracteur!.numeroTracteur,
      "commentaire": _commentaireController.text,
      "numero_badge": _badgeController.text,
    };

    await RemoteService()
        .putSomethings(
      api: 'livraisons/${_widgetDeli!.id}',
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
          _widgetDeli!.status = 'Terminée';
        });
      });
    });
  }

  Container _deliStatutBar({required String delisStatus}) {
    if (delisStatus.toLowerCase().trim() == 'terminée') {
      return Container(
        width: double.infinity,
        color: Color.fromARGB(255, 201, 40, 28),
        child: AppText.small(
          'Livraison terminée',
          fontWeight: FontWeight.w600,
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
      );
    }
    if (delisStatus.toLowerCase().trim() == 'en cours') {
      return Container(
        width: double.infinity,
        color: Color.fromARGB(255, 9, 163, 150),
        child: AppText.small(
          'Livraison en cours',
          fontWeight: FontWeight.w600,
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container(
      width: double.infinity,
      color: Color.fromARGB(255, 96, 96, 96),
      child: AppText.small(
        'Livraison en attente',
        fontWeight: FontWeight.w600,
        color: Colors.white,
        textAlign: TextAlign.center,
      ),
    );
  }

// filtrer la liste des livraisons
  Future<AglLivraisonModel?> getLivraison({
    required String numRemorque,
    required List<AglLivraisonModel> deliList,
  }) async {
    for (AglLivraisonModel element in deliList) {
      if (element.numeroRemorque == numRemorque) {
        return element;
      }
    }
    return null;
  }

// form sheet
  Container _formSheet() {
    return Container(
      width: double.infinity,
      height: 270,
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
                  'Veuillez renseigner le n° de tracteur et le n° de la remorque pour cette livraison.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: InfosColumn(
                        opacity: 0.12,
                        label: 'Entrer le n° de tracteur',
                        widget: Expanded(
                          child: Functions.getTextField(
                            controller: _numTracteurController,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InfosColumn(
                        opacity: 0.12,
                        label: 'Entrer le n° de remorque',
                        widget: Expanded(
                          child: Functions.getTextField(
                            controller: _numRemorqueController,
                          ),
                        ),
                      ),
                    )
                  ],
                )
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
                if (_numTracteurController.text.isEmpty) {
                  Functions.showToast(
                    msg: 'Renseigner le numéro du tracteur',
                    gravity: ToastGravity.TOP,
                  );
                  return;
                }
                if (_numRemorqueController.text.isEmpty) {
                  Functions.showToast(
                    msg: 'Renseigner le numéro de la remorque',
                    gravity: ToastGravity.TOP,
                  );
                  return;
                }
                /*   Functions.showLoadingSheet(ctxt: context);
                String _tracteur = _numTracteurController.text.toString(); */
                //fetch agent
                EasyLoading.show();
                AgentModel? agent = await Functions.fetchAgent();
                if (agent == null) {
                  Functions.showToast(
                    msg: 'Veuillez vous connecter avec un n° matricule valide',
                    gravity: ToastGravity.TOP,
                  );
                  EasyLoading.dismiss();
                  return;
                }

                //search tracteur from tracteur liste
                EasyLoading.show();
                _findTracteur(numTracteur: _numTracteurController.text)
                    .whenComplete(() {
                  if (_tracteur != null) {
                    print('tracteur found !');

                    _findLivraison(
                      numRemorque: _numRemorqueController.text,
                      agne: agent,
                    ).whenComplete(() {
                      EasyLoading.dismiss();
                    });
                  } else {
                    EasyLoading.dismiss();
                    Functions.showToast(
                      msg: 'Tracteur introuvable',
                      gravity: ToastGravity.TOP,
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _findLivraison(
      {required String numRemorque, required AgentModel agne}) async {
    // print('search livraison');
    await getLivraison(
      numRemorque: numRemorque,
      deliList: _tracteur!.livraisons,
    ).then((deli) {
      // Navigator.pop(context);
      if (deli == null) {
        print('not  livraison found');
        Functions.showToast(
          msg: 'Remorque introuvable !',
          gravity: ToastGravity.TOP,
        );
        // _showBonCommandeSheet();
        return;
      } else {
        print(' livraison found');
        if (!Functions.isToday(deli.dateVisite)) {
          Functions.showToast(
            msg: 'Cette livraison n\'est pas pour aujourd\'hui',
            gravity: ToastGravity.TOP,
          );
          return;
        }
        if (deli.localisationId != agne.localisationId) {
          Functions.showToast(
            msg: 'Cette livraison n\'a pas lieu sur ce site',
            gravity: ToastGravity.TOP,
          );
          return;
        }
        setState(() {
          _widgetDeli = deli;
          // Set controllers
          nomController.text = deli.nom;
          prenomsController.text = deli.prenoms;
          telController.text = deli.telephone;
          /* emailController.text = deli.email; */
          /* carIdController.text = deli.immatriculation; */
          showForm = true;
        });

        Navigator.pop(context);
      }
    });
  }

  Future<void> _findTracteur({required String numTracteur}) async {
    // implement first or null
    TracteurModel? t = await TracteurModel.tracteurList
        .firstWhereOrNull((element) => element.numeroTracteur == numTracteur);
    if (t != null) {
      setState(() {
        _tracteur = t;
      });
    }
  }

// mise a jour d'une livraison
  /*  void _handleLivraison(BuildContext context) {
    if (_widgetDeli!.status.toLowerCase().trim() == 'terminée') {
      Functions.showToast(msg: 'Livraison terminée');
    } else {
      if (nomController.text.trim().isEmpty) {
        Functions.showToast(msg: 'Renseigner le nom du livreur');
      } else if (prenomsController.text.trim().isEmpty) {
        Functions.showToast(msg: 'Renseigner le prénom du livreur');
      } else if (telController.text.trim().isEmpty) {
        Functions.showToast(msg: 'Renseigner le numéro du livreur');
      } else {
        Functions.showLoadingSheet(ctxt: context);
        String dateDeli = DateTime.now().toString();
        String heureDeli = DateFormat('HH:mm', 'fr_FR').format(
          DateTime.now(),
        );

        Map<String, dynamic> _payload = {
          "nom": nomController.text,
          "prenoms": prenomsController.text,
          "telephone": telController.text,
          "date_livraison": dateDeli,
          "statut_livraison": 1,
          "heure_entree": heureDeli,
          "status": "en cours"
        };

        RemoteService()
            .putSomethings(
          api: 'livraisons/${_widgetDeli!.id}',
          data: _payload,
        )
            .then((_) {
          _widgetDeli!.copyWith(
            nom: nomController.text,
            prenoms: prenomsController.text,
            telephone: telController.text,
            //immatriculation: carIdController.text,
            statutLivraison: true,
          );

          for (Livraison element in Livraison.livraisonList) {
            if (element.id == _widgetDeli!.id) {
              setState(() {
                element.statutLivraison = true;
              });
            }
          }

          Functions.allLivrason().then((_) {
            Navigator.pop(context);
            Functions.showToast(msg: 'Livraison enregistrée');
            Future.delayed(const Duration(milliseconds: 500)).then(
              (value) => Navigator.pushNamedAndRemoveUntil(
                context,
                DeliveringScreen.routeName,
                (route) => false,
              ),
            );
          });
        });
      }
    }
  } */

  ///
  ///
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

  ///
}
