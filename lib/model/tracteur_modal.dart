/* // To parse this JSON data, do
//
//     final tracteur = tracteurFromJson(jsonString);
import 'dart:convert';

import 'package:scanner/local_service/local_service.dart';
import 'package:scanner/model/DeviceModel.dart';

import '../remote_service/remote_service.dart';
import 'agl_livraison_model.dart';

List<TracteurModel> listTracteurFromJson(String str) =>
    List<TracteurModel>.from(
        json.decode(str).map((x) => TracteurModel.fromJson(x)));

String listTracteurToJson(List<TracteurModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TracteurModel {
  int id;
  String numeroTracteur;
  List<AglLivraisonModel> livraisons;

  TracteurModel({
    required this.id,
    required this.numeroTracteur,
    required this.livraisons,
  });

  factory TracteurModel.fromJson(Map<String, dynamic> json) => TracteurModel(
        id: json["id"],
        numeroTracteur: json["numero_tracteur"] ?? "",
        livraisons: List<AglLivraisonModel>.from(
            json["livraisons"].map((x) => AglLivraisonModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "numero_tracteur": numeroTracteur,
        "livraisons":
            List<AglLivraisonModel>.from(livraisons.map((x) => x.toJson())),
      };

  static List<TracteurModel> tracteurList = [];

  static Future<void> getTracteurListFromApi() async {
    tracteurList = await RemoteService().getTracteurs();
  }

  // écrire un getter ici qui retourne la liste des tracteur en utilisant "RemoteService().getTracteurs()" qui un Future<List<TracteurModel>> chager de fetch l'api

  static Future<List<TracteurModel>> fetchTracteurs() async {
    return await RemoteService().getTracteurs();
  }

  // Cette méthode renvoie une liste de livraisons avec les détails demandés
  static Future<List<DeliDetailsModel>> getLivraisonsDetails({
    required String status,
    required DateTime date,
  }) async {
    List<TracteurModel> tracteurs = await fetchTracteurs();
    List<DeliDetailsModel> details = [];
    //AgentModel? _agent = await Functions.fetchAgent();
    LocalService localService = LocalService();
    DeviceModel? device = await localService.getDevice();

    for (var tracteur in tracteurs) {
      for (var livraison in tracteur.livraisons) {
        if (livraison.statutLivraison) {
          if (livraison.status.trim().toLowerCase() ==
                  status.trim().toLowerCase() &&
              livraison.dateLivraison!.isAtSameMomentAs(date) &&
              livraison.localisationId == device!.localisationId) {
            details.add(DeliDetailsModel(
              tracteurId: tracteur.id,
              numeroTracteur: tracteur.numeroTracteur,
              livraison: livraison,
            ));
          }
        }
      }
    }
    return details;
  }
} */

import 'agl_livraison_model.dart';

class DeliDetailsModel {
  // tracteur
  final int tracteurId;
  final String numeroTracteur;

//livraison
  final AglLivraisonModel livraison;

  DeliDetailsModel({
    required this.tracteurId,
    required this.numeroTracteur,
    required this.livraison,
  });
}
