// To parse this JSON data, do
//
//     final getTowerResponseModel = getTowerResponseModelFromJson(jsonString);

import 'dart:convert';

GetTowerResponseModel getTowerResponseModelFromJson(String str) =>
    GetTowerResponseModel.fromJson(json.decode(str));

String getTowerResponseModelToJson(GetTowerResponseModel data) =>
    json.encode(data.toJson());

class GetTowerResponseModel {
  String? status;
  String? message;
  List<TowerDatum>? towerData;

  GetTowerResponseModel({
    this.status,
    this.message,
    this.towerData,
  });

  factory GetTowerResponseModel.fromJson(Map<String, dynamic> json) =>
      GetTowerResponseModel(
        status: json["status"],
        message: json["message"],
        towerData: List<TowerDatum>.from(
            json["tower_data"].map((x) => TowerDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "tower_data": List<dynamic>.from(towerData!.map((x) => x.toJson())),
      };
}

class TowerDatum {
  int? towerId;
  String? name;

  TowerDatum({
    this.towerId,
    this.name,
  });

  factory TowerDatum.fromJson(Map<String, dynamic> json) => TowerDatum(
        towerId: json["tower_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "tower_id": towerId,
        "name": name,
      };
}
