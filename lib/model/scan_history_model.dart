// To parse this JSON data, do
//
//     final scanHistoryModel = scanHistoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:scanner/remote_service/remote_service.dart';

ScanHistoryModel scanHistoryModelFromJson(String str) =>
    ScanHistoryModel.fromJson(json.decode(str));

String scanHistoryModelToJson(ScanHistoryModel data) =>
    json.encode(data.toJson());

/////////////////////////////////////////////////////////////////
///

List<ScanHistoryModel> scanHistoryModelListFromJson(String str) =>
    List<ScanHistoryModel>.from(
        json.decode(str).map((x) => ScanHistoryModel.fromJson(x)));

String scanHistoryModelListToJson(List<ScanHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

///
////////////////////////////////////////////////////////////////////

class ScanHistoryModel {
  final int id;
  final int visiteId;
  final DateTime scandDate;
  final String scanHour;
  final String motif;
  final String numeroBaget;
  final String numeroGilet;
  String carId;
  final bool isPrimaryVisitor;
  final bool isPresente;
  final bool withBadge;

  ScanHistoryModel(
      {required this.id,
      required this.visiteId,
      required this.scandDate,
      required this.scanHour,
      required this.motif,
      required this.numeroBaget,
      required this.numeroGilet,
      this.carId = '',
      this.isPresente = true,
      this.isPrimaryVisitor = true,
      this.withBadge = true});

  factory ScanHistoryModel.fromJson(Map<String, dynamic> json) =>
      ScanHistoryModel(
        id: json["id"],
        visiteId: json["visite_id"],
        scandDate: DateTime.parse(json["scan_date"]),
        scanHour: json["scan_hour"].substring(0, 5),
        motif: json["motif"],
        carId: json["plaque_immatriculation"] ?? '',
        numeroBaget: json["numero_badge"] ?? '',
        numeroGilet: json["numero_gilet"] ?? '',
        isPrimaryVisitor: json["type_visiteur"] == 1 ? true : false,
        isPresente: json["statut"] == 1 ? true : false,
        withBadge: json["badge"] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "qr_code_id": visiteId,
        "scan_date": scandDate.toIso8601String(),
        "scan_hour": scanHour,
        "motif": motif,
        "plaque_immatriculation": carId,
        "numero_baget": numeroBaget,
      };

  static DateTime today = DateTime(
    DateTime.now().subtract(const Duration(days: 2)).year,
    DateTime.now().subtract(const Duration(days: 2)).month,
    DateTime.now().subtract(const Duration(days: 2)).day,
  );

  // creer un getter pour retourner la liste des scan historiques depuis l'api
  static Future<List<ScanHistoryModel>> get scanHistories async {
    return await RemoteService().getScanHistories();
  }
}
