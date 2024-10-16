import 'dart:convert';

List<Member> listMemberFromJson(String str) =>
    List<Member>.from(json.decode(str).map((x) => Member.fromJson(x)));

String listMemberToJson(List<Member> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//single
Member memberFromJson(String str) => Member.fromJson(json.decode(str));

String memberToJson(Member data) => json.encode(data.toJson());

class Member {
  final int id;
  final int visiteId;
  final String nom;
  final String prenoms;
  String idCard;
  String badge;
  String gilet;
  String typePiece;
  int status;
  int withBadge;

  Member({
    required this.id,
    required this.nom,
    required this.prenoms,
    required this.visiteId,
    required this.idCard,
    required this.badge,
    required this.gilet,
    required this.typePiece,
    this.status = 1,
    this.withBadge = 1,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        nom: json["nom"] == null ? '' : json["nom"],
        prenoms: json["prenoms"] == null ? '' : json["prenoms"],
        visiteId: json["visite_id"] ?? 0,
        idCard: json["numero_cni"] ?? '',
        badge: json["numero_badge"] ?? '',
        gilet: json["numero_gilet"] ?? '',
        typePiece: json["type_piece"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenoms": prenoms,
        "visite_id": visiteId,
        "numero_cni": idCard,
        "numero_badge": badge,
        "numero_gilet": gilet,
        "type_piece": typePiece,
      };

  static List<Member> memberdata = [
    Member(
      id: 1,
      nom: 'Soro',
      prenoms: 'David',
      visiteId: 1,
      idCard: 'CI490039493',
      badge: 'CI490039493',
      gilet: 'CI490039493',
      typePiece: 'CNI',
    ),
    Member(
      id: 2,
      nom: 'Kouadio',
      prenoms: 'Koffi David',
      visiteId: 1,
      idCard: 'CI00495889',
      badge: 'CI00495889',
      gilet: 'CI00495889',
      typePiece: 'CNI',
    ),
    Member(
      id: 3,
      nom: 'Gnosoro',
      prenoms: 'David',
      visiteId: 1,
      idCard: '',
      badge: '',
      gilet: '',
      typePiece: 'CNI',
    )
  ];
}
