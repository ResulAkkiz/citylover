// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

List<LocationModel> locationsFromMap(String str) => List<LocationModel>.from(
    json.decode(str).map((x) => LocationModel.fromMap(x)));

String locationsToMap(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class LocationModel {
  LocationModel({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory LocationModel.fromMap(Map<String, dynamic> json) => LocationModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
  @override
  String toString() {
    return '(id:$id, name:$name )';
  }

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
