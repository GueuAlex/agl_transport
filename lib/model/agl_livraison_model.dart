// To parse this JSON data, do
//
//     final aglLivraisonModel = aglLivraisonModelFromJson(jsonString);

import 'dart:convert';

import 'package:scanner/model/localisation_model.dart';

//List
List<AglLivraisonModel> listAglLivraisonModelFromJson(String str) =>
    List<AglLivraisonModel>.from(
        json.decode(str).map((x) => AglLivraisonModel.fromJson(x)));

String listAglLivraisonModelToJson(List<AglLivraisonModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// single
AglLivraisonModel aglLivraisonModelFromJson(String str) =>
    AglLivraisonModel.fromJson(json.decode(str));

String aglLivraisonModelToJson(AglLivraisonModel data) =>
    json.encode(data.toJson());

class AglLivraisonModel {
  int id;
  int userId;
  int localisationId;
  bool active;
  String nom;
  String prenoms;
  String numeroRemorque;
  String telephone;
  String entreprise;
  String typeColis;
  bool statutLivraison;
  DateTime dateVisite;
  DateTime? dateLivraison;
  String status;
  String heureEntree;
  String heureSortie;
  LocalisationModel localisation;

  AglLivraisonModel({
    required this.id,
    required this.userId,
    required this.localisationId,
    required this.active,
    required this.nom,
    required this.prenoms,
    required this.numeroRemorque,
    required this.telephone,
    required this.entreprise,
    required this.typeColis,
    required this.statutLivraison,
    required this.dateVisite,
    required this.dateLivraison,
    required this.status,
    required this.heureEntree,
    required this.heureSortie,
    required this.localisation,
  });

  factory AglLivraisonModel.fromJson(Map<String, dynamic> json) =>
      AglLivraisonModel(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        localisationId: json["localisation_id"] ?? 0,
        active: json["active"] == 1 ? true : false,
        nom: json["nom"] ?? "",
        prenoms: json["prenoms"] ?? "",
        numeroRemorque: json["numero_remorque"] ?? "",
        telephone: json["telephone"] ?? "",
        entreprise: json["entreprise"] ?? "",
        typeColis: json["type_colis"] ?? "",
        statutLivraison: json["statut_livraison"] == 1 ? true : false,
        dateVisite: DateTime.parse(json["date_visite"]) /* DateTime.now() */,
        dateLivraison: json["date_livraison"] != null
            ? DateTime.parse(json["date_livraison"])
            : null,
        status: json["status"] ?? "",
        heureEntree: json["heure_entree"] ?? "",
        heureSortie: json["heure_sortie"] ?? "",
        localisation: LocalisationModel.fromJson(json["localisation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "localisation_id": localisationId,
        "active": active,
        "nom": nom,
        "prenoms": prenoms,
        "numero_remorque": numeroRemorque,
        "telephone": telephone,
        "entreprise": entreprise,
        "type_colis": typeColis,
        "statut_livraison": statutLivraison,
        "date_visite":
            "${dateVisite.year.toString().padLeft(4, '0')}-${dateVisite.month.toString().padLeft(2, '0')}-${dateVisite.day.toString().padLeft(2, '0')}",
        "date_livraison": dateLivraison,
        "status": status,
        "heure_entree": heureEntree,
        "heure_sortie": heureSortie,
        "localisation": localisation.toJson(),
      };

  /* copy with methode */
  AglLivraisonModel copyWith({
    int? id,
    int? userId,
    int? localisationId,
    bool? active,
    String? nom,
    String? prenoms,
    String? numeroRemorque,
    String? telephone,
    String? entreprise,
    String? typeColis,
    bool? statutLivraison,
    DateTime? dateVisite,
    DateTime? dateLivraison,
    String? status,
    String? heureEntree,
    String? heureSortie,
    LocalisationModel? localisation,
  }) {
    return AglLivraisonModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      localisationId: localisationId ?? this.localisationId,
      active: active ?? this.active,
      nom: nom ?? this.nom,
      prenoms: prenoms ?? this.prenoms,
      numeroRemorque: numeroRemorque ?? this.numeroRemorque,
      telephone: telephone ?? this.telephone,
      entreprise: entreprise ?? this.entreprise,
      typeColis: typeColis ?? this.typeColis,
      statutLivraison: statutLivraison ?? this.statutLivraison,
      dateVisite: dateVisite ?? this.dateVisite,
      dateLivraison: dateLivraison ?? this.dateLivraison,
      status: status ?? this.status,
      heureEntree: heureEntree ?? this.heureEntree,
      heureSortie: heureSortie ?? this.heureSortie,
      localisation: localisation ?? this.localisation,
    );
  }
}
