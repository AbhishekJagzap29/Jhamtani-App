// To parse this JSON data, do
//
//     final floorChecklistNcResponseModel = floorChecklistNcResponseModelFromJson(jsonString);

import 'dart:convert';

ChecklistNcResponseModel floorChecklistNcResponseModelFromJson(String str) =>
    ChecklistNcResponseModel.fromJson(json.decode(str));

String floorChecklistNcResponseModelToJson(ChecklistNcResponseModel data) =>
    json.encode(data.toJson());

class ChecklistNcResponseModel {
  String? status;
  String? message;
  ProjectData? projectData;

  ChecklistNcResponseModel({
    this.status,
    this.message,
    this.projectData,
  });

  factory ChecklistNcResponseModel.fromJson(Map<String, dynamic> json) =>
      ChecklistNcResponseModel(
        status: json["status"],
        message: json["message"],
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
  int? checklistId;
  int? projectLineNc;
  int? projectLineYellow;
  int? projectLineOrange;
  int? projectLineRed;

  ProjectData({
    this.checklistName,
    this.checklistId,
    this.projectLineNc,
    this.projectLineYellow,
    this.projectLineOrange,
    this.projectLineRed,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) => ProjectData(
        checklistName: json["checklist_name"],
        checklistId: json["checklist_id"],
        projectLineNc: json["project_line_nc"],
        projectLineYellow: json["project_line_yellow"],
        projectLineOrange: json["project_line_orange"],
        projectLineRed: json["project_line_red"],
      );

  Map<String, dynamic> toJson() => {
        "checklist_name": checklistName,
        "checklist_id": checklistId,
        "project_line_nc": projectLineNc,
        "project_line_yellow": projectLineYellow,
        "project_line_orange": projectLineOrange,
        "project_line_red": projectLineRed,
      };
}
