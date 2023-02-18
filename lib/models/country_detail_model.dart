import 'dart:convert';

CountryDetail countryDetailFromMap(String str) =>
    CountryDetail.fromMap(json.decode(str));

String countryDetailToMap(CountryDetail data) => json.encode(data.toMap());

class CountryDetail {
  CountryDetail({
    required this.id,
    required this.name,
    required this.iso3,
    required this.iso2,
    required this.translations,
    required this.emoji,
    required this.emojiU,
  });

  int id;
  String name;
  String iso3;
  String iso2;

  String translations;
  String emoji;
  String emojiU;

  factory CountryDetail.fromMap(Map<String, dynamic> json) => CountryDetail(
        id: json["id"],
        name: json["name"],
        iso3: json["iso3"],
        iso2: json["iso2"],
        translations: json["translations"],
        emoji: json["emoji"],
        emojiU: json["emojiU"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "iso3": iso3,
        "iso2": iso2,
        "translations": translations,
      };
}
