// To parse this JSON data, do
//
//     final siteModel = siteModelFromJson(jsonString);

import 'dart:convert';

List<SiteModel> siteModelFromJson(String str) =>
    List<SiteModel>.from(json.decode(str).map((x) => SiteModel.fromJson(x)));

String siteModelToJson(List<SiteModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// ceci est le model de localisation sans les données liées pour éviter
// la lenteur de la requête
class SiteModel {
  int id;
  int siteId;
  String libelle;

  SiteModel({
    required this.id,
    required this.libelle,
    required this.siteId,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) => SiteModel(
        id: json["id"],
        libelle: json["libelle"],
        siteId: json["site_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "site_id": siteId,
      };
}
