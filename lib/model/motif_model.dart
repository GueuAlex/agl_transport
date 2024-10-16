// To parse this JSON data, do
//
//     final motifModel = motifModelFromJson(jsonString);
import 'dart:convert';

List<MotifModel> motifModelFromJson(String str) =>
    List<MotifModel>.from(json.decode(str).map((x) => MotifModel.fromJson(x)));

String motifModelToJson(List<MotifModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MotifModel {
  int id;
  String libelle;

  MotifModel({
    required this.id,
    required this.libelle,
  });

  factory MotifModel.fromJson(Map<String, dynamic> json) => MotifModel(
        id: json["id"] ?? 0,
        libelle: json["libelle"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
      };

  static List<MotifModel> glogalModitif = [];
}
