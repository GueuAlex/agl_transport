class LocalisationModel {
  int id;
  String libelle;
  int siteId;

  LocalisationModel({
    required this.id,
    required this.libelle,
    required this.siteId,
  });

  factory LocalisationModel.fromJson(Map<String, dynamic> json) =>
      LocalisationModel(
        id: json["id"] ?? 0,
        libelle: json["libelle"] ?? '',
        siteId: json["site_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "site_id": siteId,
      };
}
