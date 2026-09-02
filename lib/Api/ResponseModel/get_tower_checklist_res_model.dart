// To parse this JSON data, do
//
//     final getTowerInfoChecklistResponseModel = getTowerInfoChecklistResponseModelFromJson(jsonString);

import 'dart:convert';

GetTowerInfoChecklistResponseModel getTowerInfoChecklistResponseModelFromJson(
        String str) =>
    GetTowerInfoChecklistResponseModel.fromJson(json.decode(str));

String getTowerInfoChecklistResponseModelToJson(
        GetTowerInfoChecklistResponseModel data) =>
    json.encode(data.toJson());

class GetTowerInfoChecklistResponseModel {
  String? status;
  String? message;
  ProjectData? projectData;

  GetTowerInfoChecklistResponseModel({
    this.status,
    this.message,
    this.projectData,
  });

  factory GetTowerInfoChecklistResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetTowerInfoChecklistResponseModel(
        status: json["status"].toString(),
        message: json["message"].toString(),
        projectData: json["project_data"] == null
            ? null
            : ProjectData.fromJson(json["project_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "project_data": projectData?.toJson(),
      };
}

class ProjectData {
  String? checklistName;
  String? imageUrl;
  int? checklistId;
  double? progress;
  List<TowerData>? towerData;

  ProjectData({
    this.checklistName,
    this.imageUrl,
    this.checklistId,
    this.progress,
    this.towerData,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) => ProjectData(
        checklistName: json["checklist_name"].toString(),
        imageUrl: json["image_url"].toString(),
        checklistId: json["checklist_id"],
        progress: json["progress"],
        towerData: json["tower_data"] == null
            ? []
            : List<TowerData>.from(
                json["tower_data"]!.map((x) => TowerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "checklist_name": checklistName,
        "image_url": imageUrl,
        "checklist_id": checklistId,
        "progress": progress,
        "tower_data": towerData == null
            ? []
            : List<dynamic>.from(towerData!.map((x) => x.toJson())),
      };
}

class TowerData {
  String? name;
  int? towerId;
  double? progress;
  String? type;


TowerData({
    this.name,
    this.towerId,
    this.progress,
    this.type,
  });

  factory TowerData.fromJson(Map<String, dynamic> json) => TowerData(
        name: json["name"].toString(),
        towerId: json["tower_id"],
        progress: json["progress"],
        type: json["type"]?.toString(),
      );


  Map<String, dynamic> toJson() => {
        "name": name,
        "tower_id": towerId,
        "progress": progress,
        "type": type,
      };
}
