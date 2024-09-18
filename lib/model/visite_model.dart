// To parse this JSON data, do
//
//     final visiteModel = visiteModelFromJson(jsonString);
import 'dart:convert';

import '../remote_service/remote_service.dart';
import 'localisation_model.dart';
import 'members_model.dart';
import 'motif_model.dart';

// list
List<VisiteModel> listVisiteModelFromJson(String str) => List<VisiteModel>.from(
    json.decode(str).map((x) => VisiteModel.fromJson(x)));

String listVisiteModelToJson(List<VisiteModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//single
VisiteModel visiteModelFromJson(String str) =>
    VisiteModel.fromJson(json.decode(str));

String visiteModelToJson(VisiteModel data) => json.encode(data.toJson());

class VisiteModel {
  int id;
  int userId;
  String genre;

  String nom;
  String prenoms;
  String entreprise;
  DateTime dateVisite;
  String? heureVisite;
  String? heureFinVisite;
  String typeVisiteur;
  DateTime? dateFinVisite;
  String numeroCni;
  final String typePiece;
  String plaqueVehicule;
  String email;
  String number;
  String codeVisite;
  bool isAlreadyScanned;
  bool isActive;
  LocalisationModel localisation;
  MotifModel motif;
  List<Member> members;

  VisiteModel({
    required this.id,
    required this.genre,
    required this.userId,
    required this.nom,
    required this.prenoms,
    required this.entreprise,
    required this.dateVisite,
    required this.dateFinVisite,
    required this.numeroCni,
    required this.typePiece,
    required this.plaqueVehicule,
    required this.email,
    required this.number,
    required this.codeVisite,
    required this.isAlreadyScanned,
    required this.isActive,
    required this.localisation,
    required this.motif,
    this.members = const [],
    required this.heureFinVisite,
    required this.heureVisite,
    required this.typeVisiteur,
  });

  factory VisiteModel.fromJson(Map<String, dynamic> json) => VisiteModel(
        id: json["id"],
        genre: json["genre"] ?? "",
        userId: json["user_id"] ?? 0,
        nom: json["nom"] ?? "",
        prenoms: json["prenoms"] ?? "",
        entreprise: json["entreprise"] ?? "",
        dateVisite: DateTime.parse(json["date_visite"]) /* DateTime.now() */,
        dateFinVisite: json["date_fin_visite"] != null
            ? DateTime.parse(json["date_fin_visite"])
            : null,
        numeroCni: json["numero_piece"] ?? "",
        typePiece: json["type_piece"] ?? "",
        plaqueVehicule: json["plaque_vehicule"] ?? "",
        email: json["email"] ?? "",
        number: json["number"] ?? "",
        codeVisite: json["code_visite"] ?? "",
        isAlreadyScanned: json["is_already_scanned"] == 1 ? true : false,
        isActive: json["is_active"] == 1 ? true : false,
        localisation: LocalisationModel.fromJson(json["localisation"]),
        motif: MotifModel.fromJson(json["motif"]),
        members: List<Member>.from(
          json["membre_visites"].map((x) => Member.fromJson(x)),
        ),
        heureFinVisite: json["heure_fin_visite"],
        heureVisite: json["heure_visite"],
        typeVisiteur: json["type_visiteur"] ?? '',
        /*  members: Member.memberdata, */
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "genre": genre,
        "user_id": userId,
        "nom": nom,
        "prenoms": prenoms,
        "entreprise": entreprise,
        "date_visite":
            "${dateVisite.year.toString().padLeft(4, '0')}-${dateVisite.month.toString().padLeft(2, '0')}-${dateVisite.day.toString().padLeft(2, '0')}",
        /*  "date_fin_visite":
            "${dateFinVisite?.year.toString().padLeft(4, '0')}-${dateFinVisite?.month.toString().padLeft(2, '0')}-${dateFinVisite?.day.toString().padLeft(2, '0')}", */
        "numero_cni": numeroCni,
        "plaque_vehicule": plaqueVehicule,
        "email": email,
        "number": number,
        "code_visite": codeVisite,
        "is_already_scanned": isAlreadyScanned,
        "is_active": isActive,
        "localisation": localisation.toJson(),
        "motif": motif.toJson(),
      };

  // Getter qui utilise RemoteService().getVisites() et renvoie la liste des visites
  static Future<List<VisiteModel>> get visites async {
    final List<VisiteModel> visiteData = await RemoteService().getVisites();
    return visiteData;
  }
}
