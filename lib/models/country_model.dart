import 'dart:convert';

List<LocationModel> locationsFromMap(String str) => List<LocationModel>.from(
    json.decode(str).map((x) => LocationModel.fromMap(x)));

String locationsToMap(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class LocationModel {
  LocationModel({
    required this.id,
    required this.name,
    required this.iso2,
  });

  int id;
  String name;
  String iso2;

  factory LocationModel.fromMap(Map<String, dynamic> json) => LocationModel(
        id: json["id"],
        name: json["name"],
        iso2: json["iso2"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "iso2": iso2,
      };
}
