// To parse this JSON data, do
//
//     final logisticAgent = logisticAgentFromJson(jsonString);

import 'dart:convert';

List<LogisticAgent> logisticAgentFromJson(String str) =>
    List<LogisticAgent>.from(
        json.decode(str).map((x) => LogisticAgent.fromJson(x)));

String logisticAgentToJson(List<LogisticAgent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LogisticAgent {
  int id;
  String nom;
  String prenoms;
  String numeroCni;
  String typePiece;

  LogisticAgent({
    required this.id,
    required this.nom,
    required this.prenoms,
    required this.numeroCni,
    required this.typePiece,
  });

  factory LogisticAgent.fromJson(Map<String, dynamic> json) => LogisticAgent(
        id: json["id"],
        nom: json["nom"],
        prenoms: json["prenoms"],
        numeroCni: json["numero_cni"],
        typePiece: json["type_piece"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenoms": prenoms,
        "numero_cni": numeroCni,
        "type_piece": typePiece,
      };
}
