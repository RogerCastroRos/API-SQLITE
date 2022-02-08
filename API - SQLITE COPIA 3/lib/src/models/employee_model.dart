import 'dart:convert';

List<TopUci> employeeFromJson(String str) =>
    List<TopUci>.from(json.decode(str).map((x) => TopUci.fromJson(x)));

String employeeToJson(List<TopUci> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopUci {
  int? id;
  String? nom;
  String? equip;
  String? punts;
  String? imatge;
  bool? done = false;

  TopUci({
    this.id,
    this.nom,
    this.equip,
    this.punts,
    this.imatge,
    //this.done,
  });

  factory TopUci.fromJson(Map<String, dynamic> json) => TopUci(
        id: json["id"],
        nom: json["nom"],
        equip: json["equip"],
        punts: json["punts"],
        imatge: json["imatge"],
        //   done: json["done"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "equip": equip,
        "punts": punts,
        "imatge": imatge,
        //   "done": done,
      };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nom,
      'equip': equip,
      'punts': punts,
      'imatge': imatge
    };
  }
}
