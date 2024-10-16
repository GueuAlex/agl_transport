// To parse this JSON data, do
//
//     final vehiculeModel = vehiculeModelFromJson(jsonString);

import 'dart:convert';

List<VehiculeModel> vehiculeModelFromJson(String str) =>
    List<VehiculeModel>.from(
        json.decode(str).map((x) => VehiculeModel.fromJson(x)));

String vehiculeModelToJson(List<VehiculeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehiculeModel {
  int id;
  String? nom;
  String? prenoms;
  String? typePiece;
  String? numeroPiece;
  DateTime? validitePiece;
  String numeroImmatriculation;
  String? numeroRemorque;
  String? numeroConteneur;
  String? typeEngin;
  String? marque;
  String? entreprise;

  VehiculeModel({
    required this.id,
    required this.nom,
    required this.prenoms,
    required this.typePiece,
    required this.numeroPiece,
    required this.validitePiece,
    required this.numeroImmatriculation,
    required this.numeroRemorque,
    required this.numeroConteneur,
    required this.typeEngin,
    required this.marque,
    required this.entreprise,
  });

  factory VehiculeModel.fromJson(Map<String, dynamic> json) => VehiculeModel(
        id: json["id"],
        nom: json["nom"],
        prenoms: json["prenoms"],
        typePiece: json["type_piece"],
        numeroPiece: json["numero_piece"],
        validitePiece: json["validite_piece"] != null
            ? DateTime.parse(json["validite_piece"])
            : null,
        numeroImmatriculation: json["numero_immatriculation"],
        numeroRemorque: json["numero_remorque"],
        numeroConteneur: json["numero_conteneur"],
        typeEngin: json["type_engin"],
        marque: json["marque"],
        entreprise: json["entreprise"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenoms": prenoms,
        "type_piece": typePiece,
        "numero_piece": numeroPiece,
        "validite_piece": validitePiece != null
            ? "${validitePiece!.year.toString().padLeft(4, '0')}-${validitePiece!.month.toString().padLeft(2, '0')}-${validitePiece!.day.toString().padLeft(2, '0')}"
            : null,
        "numero_immatriculation": numeroImmatriculation,
        "numero_remorque": numeroRemorque,
        "numero_conteneur": numeroConteneur,
        "type_engin": typeEngin,
        "marque": marque,
        "entreprise": entreprise,
      };
}
