// To parse this JSON data, do
//
//     final aglLivraisonModel = aglLivraisonModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:scanner/local_service/local_service.dart';

import '../remote_service/remote_service.dart';
import 'DeviceModel.dart';
import 'logistic_agent_model.dart';

AglLivraisonModel aglLivraisonModelFromJson(String str) =>
    AglLivraisonModel.fromJson(json.decode(str));

String aglLivraisonModelToJson(AglLivraisonModel data) =>
    json.encode(data.toJson());

///list
List<AglLivraisonModel> aglLivraisonModelListFromJson(String str) =>
    List<AglLivraisonModel>.from(
        json.decode(str).map((x) => AglLivraisonModel.fromJson(x)));

class AglLivraisonModel {
  final int id;
  final int userId;
  final int localisationId;
  final String mouvements;
  final String formatVehicule;
  final bool active;
  final String nom;
  final String prenoms;
  final String typePiece;
  final String numeroPiece;
  final String validitePiece;
  final String numeroImmatriculation;
  final String numeroRemorque;
  final String numeroConteneur;
  final String numeroPlomb;
  final String etatConteneur;
  final String tailleConteneur;
  final String motif;
  final String referenceDocument;
  final String typeEngin;
  final String marque;
  final String telephone;
  final String entreprise;
  final DateTime dateVisite;
  /*  final DateTime? dateLivraison; */
  final DateTime? dateEntree;
  final DateTime? DateSortie;
  final String heureEntree;
  final String heureSortie;
  /* final String heure; */
  final String observation;
  final String designation;
  final List<LogisticAgent> logisticAgents;

  AglLivraisonModel({
    required this.id,
    required this.userId,
    required this.localisationId,
    required this.mouvements,
    required this.formatVehicule,
    required this.active,
    required this.nom,
    required this.prenoms,
    required this.typePiece,
    required this.numeroPiece,
    required this.validitePiece,
    required this.numeroImmatriculation,
    required this.numeroRemorque,
    required this.numeroConteneur,
    required this.numeroPlomb,
    required this.etatConteneur,
    required this.tailleConteneur,
    required this.motif,
    required this.referenceDocument,
    required this.typeEngin,
    required this.marque,
    required this.telephone,
    required this.entreprise,
    required this.dateVisite,
    /*   required this.dateLivraison,
    required this.heure, */
    required this.observation,
    required this.designation,
    required this.dateEntree,
    required this.DateSortie,
    required this.heureEntree,
    required this.heureSortie,
    this.logisticAgents = const [],
  });

  factory AglLivraisonModel.fromJson(Map<String, dynamic> json) =>
      AglLivraisonModel(
        id: json["id"],
        userId: json["user_id"] ?? 0,
        localisationId: json["localisation_id"] ?? 0,
        mouvements: json["mouvements"] ?? "Entrée",
        formatVehicule: json["format_vehicule"] ?? "Tracteur",
        active: json["active"] == 0 ? false : true,
        nom: json["nom"] ?? "",
        prenoms: json["prenoms"] ?? "",
        typePiece: json["type_piece"] ?? "",
        numeroPiece: json["numero_piece"] ?? "",
        validitePiece: json["validite_piece"] ?? "",
        numeroImmatriculation: json["numero_immatriculation"] ?? "",
        numeroRemorque: json["numero_remorque"] ?? "",
        numeroConteneur: json["numero_conteneur"] ?? "",
        numeroPlomb: json["numero_plomb"] ?? "",
        etatConteneur: json["etat_conteneur"] ?? "",
        tailleConteneur: json["taille_conteneur"] ?? "",
        motif: json["motif"] ?? "Livraison",
        referenceDocument: json["reference_document"] ?? "",
        typeEngin: json["type_engin"] ?? "",
        marque: json["marque"] ?? "",
        telephone: json["telephone"] ?? "",
        entreprise: json["entreprise"] ?? "",
        dateVisite: json["date_visite"] != null
            ? DateTime.parse(json["date_visite"])
            : DateTime.now(),
        /*  dateLivraison: json["date_livraison"] != null
            ? DateTime.parse(json["date_livraison"])
            : null, */
        dateEntree: json["date_entree"] != null
            ? DateTime.parse(json["date_entree"])
            : null,
        DateSortie: json["date_sortie"] != null
            ? DateTime.parse(json["date_sortie"])
            : null,
        heureEntree: json["heure_entree"] ?? "",
        heureSortie: json["heure_sortie"] ?? "",
        /*   heure: json["heure"] ?? "", */
        observation: json["observation"] ?? "",
        designation: json["designation"] ?? "",
        logisticAgents: List<LogisticAgent>.from(
          json["membre_livraisons"].map((x) => LogisticAgent.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "localisation_id": localisationId,
        "mouvements": mouvements,
        "format_vehicule": formatVehicule,
        "active": active,
        "nom": nom,
        "prenoms": prenoms,
        "type_piece": typePiece,
        "numero_piece": numeroPiece,
        "validite_piece": validitePiece,
        "numero_immatriculation": numeroImmatriculation,
        "numero_remorque": numeroRemorque,
        "numero_conteneur": numeroConteneur,
        "numero_plomb": numeroPlomb,
        "etat_conteneur": etatConteneur,
        "taille_conteneur": tailleConteneur,
        "motif": motif,
        "reference_document": referenceDocument,
        "type_engin": typeEngin,
        "marque": marque,
        "telephone": telephone,
        "entreprise": entreprise,
        "date_visite":
            "${dateVisite.year.toString().padLeft(4, '0')}-${dateVisite.month.toString().padLeft(2, '0')}-${dateVisite.day.toString().padLeft(2, '0')}",
        /*  "date_livraison": dateLivraison,
        "heure": heure, */
        "observation": observation,
      };

  static List<AglLivraisonModel> livraisonList = [];
  static List<AglLivraisonModel> avalaibleDeli = [];

  static Future<void> getTracteurListFromApi() async {
    avalaibleDeli = [];
    livraisonList = await RemoteService().getLivraisons();
    livraisonList.forEach((deli) {
      if (deli.active && deli.DateSortie == null) {
        avalaibleDeli.add(deli);
      }
    });
  }

  static Future<List<AglLivraisonModel>> getDeli(
      {required DateTime date}) async {
    LocalService localService = LocalService();
    DeviceModel? _device = await localService.getDevice();
    if (_device == null) {
      return [];
    }
    List<AglLivraisonModel> _list = await RemoteService().getLivraisons();
    return _list
        .where(
          (element) =>
              /* !element.active && */
              element.localisationId == _device.localisationId &&
              element.heureEntree.trim().isNotEmpty &&
              element.dateEntree != null &&
              element.dateVisite.isAtSameMomentAs(date),
        )
        .toList();
  }

  static AglLivraisonModel? findLivraison({
    required String numMatricule,
    required int localisationId,
    required String mouvement,
  }) {
    return livraisonList.firstWhereOrNull((livraison) {
      return (livraison.numeroImmatriculation.toUpperCase() ==
              numMatricule.toUpperCase() &&
          livraison.mouvements.toLowerCase() == mouvement.toLowerCase() &&
          /* Functions.isToday(livraison.dateVisite) && */
          livraison.active &&
          livraison.localisationId == localisationId &&
          livraison.DateSortie == null &&
          livraison.heureSortie.trim().isEmpty);
    });
  }
}
