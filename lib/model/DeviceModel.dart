class DeviceModel {
  final int localisationId;
  final int siteId;
  final String uid;
  final String model;
  final String manufacturer;
  final String os;
  final String osVersion;

  DeviceModel({
    required this.localisationId,
    required this.siteId,
    required this.uid,
    required this.model,
    required this.manufacturer,
    required this.os,
    required this.osVersion,
  });

  // Méthode pour convertir un Map en DeviceModel
  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      localisationId: map['localisation_id'],
      siteId: map['site_id'],
      uid: map['uid'],
      model: map['model'],
      manufacturer: map['manufacturer'],
      os: map['os'],
      osVersion: map['os_version'],
    );
  }

  // Méthode pour convertir un DeviceModel en Map
  Map<String, dynamic> toMap() {
    return {
      'id': localisationId,
      'site_id': siteId,
      'uid': uid,
      'model': model,
      'manufacturer': manufacturer,
      'os': os,
      'os_version': osVersion,
    };
  }
}
