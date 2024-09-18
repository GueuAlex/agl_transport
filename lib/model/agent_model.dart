// To parse this JSON data, do
//
//     final agentModel = agentModelFromJson(jsonString);

import 'dart:convert';

List<AgentModel> agentModelListFromJson(String str) =>
    List<AgentModel>.from(json.decode(str).map((x) => AgentModel.fromJson(x)));
AgentModel agentModelFromJson(String str) =>
    AgentModel.fromJson(json.decode(str));

String agentModelToJson(List<AgentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AgentModel {
  int id;
  String name;
  String email;
  String telephone;
  bool actif;
  String matricule;
  String avatar;
  AgentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.telephone,
    required this.actif,
    required this.matricule,
    required this.avatar,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) => AgentModel(
        id: json["id"],
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        telephone: json["telephone"] ?? '',
        actif: json["actif"] == 0 ? false : true,
        matricule: json["matricule"] ?? '',
        //localisationId: json["localisation_id"] ?? 0,
        avatar: json["avatar"] ?? '',
        //localisation: LocalisationModel.fromJson(json["localisation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "telephone": telephone,
        "actif": actif,
        "matricule": matricule,
        //"localisation_id": localisationId,
        "avatar": avatar,
        //"localisation": localisation.toJson(),
      };
}
