// To parse this JSON data, do
//
//     final projectDetailsResponseModel = projectDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

ProjectDetailsResponseModel projectDetailsResponseModelFromJson(String str) =>
    ProjectDetailsResponseModel.fromJson(json.decode(str));

String projectDetailsResponseModelToJson(ProjectDetailsResponseModel data) =>
    json.encode(data.toJson());

class ProjectDetailsResponseModel {
  String? status;
  String? message;
  ProjectData? projectData;

  ProjectDetailsResponseModel({
    this.status,
    this.message,
    this.projectData,
  });

  factory ProjectDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      ProjectDetailsResponseModel(
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
  String? projectName;
  String? imageUrl;
  List<ChecklistData>? checklistData;

  ProjectData({
    this.projectName,
    this.imageUrl,
    this.checklistData,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) => ProjectData(
        projectName: json["project_name"].toString(),
        imageUrl: json["image_url"].toString(),
        checklistData: json["checklist_data"] == null
            ? []
            : List<ChecklistData>.from(
                json["checklist_data"]!.map((x) => ChecklistData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "project_name": projectName,
        "image_url": imageUrl,
        "checklist_data": checklistData == null
            ? []
            : List<dynamic>.from(checklistData!.map((x) => x.toJson())),
      };
}

class ChecklistData {
  String? name;
  String? image;
  int? checklistId;

  ChecklistData({
    this.name,
    this.image,
    this.checklistId,
  });

  factory ChecklistData.fromJson(Map<String, dynamic> json) => ChecklistData(
        name: json["name"].toString(),
        image: json["image"].toString(),
        checklistId: json["checklist_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "checklist_id": checklistId,
      };
}
