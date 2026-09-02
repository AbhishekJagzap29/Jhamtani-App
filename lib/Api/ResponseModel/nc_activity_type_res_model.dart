// To parse this JSON data, do
//
//     final floorAcTypeNcResponseModel = floorAcTypeNcResponseModelFromJson(jsonString);

import 'dart:convert';

ActivityTypeNcResponseModel floorAcTypeNcResponseModelFromJson(String str) =>
    ActivityTypeNcResponseModel.fromJson(json.decode(str));

String floorAcTypeNcResponseModelToJson(ActivityTypeNcResponseModel data) =>
    json.encode(data.toJson());

class ActivityTypeNcResponseModel {
  String? status;
  String? message;
  ActivityTypeNCProjectData? projectData;

  ActivityTypeNcResponseModel({
    this.status,
    this.message,
    this.projectData,
  });

  factory ActivityTypeNcResponseModel.fromJson(Map<String, dynamic> json) =>
      ActivityTypeNcResponseModel(
        status: json["status"],
        message: json["message"],
        projectData: json["project_data"] == null
            ? null
            : ActivityTypeNCProjectData.fromJson(json["project_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "project_data": projectData?.toJson(),
      };
}

class ActivityTypeNCProjectData {
  String? activityTypeName;
  int? activityTypeId;
  int? actTypeNc;
  int? actTypeYellow;
  int? actTypeOrange;
  int? actTypeRed;
  int? actTypeGreen;
  List<NcChecklist>? checklist;

  ActivityTypeNCProjectData({
    this.activityTypeName,
    this.activityTypeId,
    this.actTypeNc,
    this.actTypeYellow,
    this.actTypeOrange,
    this.actTypeRed,
    this.actTypeGreen,
    this.checklist,
  });

  factory ActivityTypeNCProjectData.fromJson(Map<String, dynamic> json) =>
      ActivityTypeNCProjectData(
        activityTypeName: json["activity_type_name"],
        activityTypeId: json["activity_type_id"],
        actTypeNc: json["act_type_nc"],
        actTypeYellow: json["act_type_yellow"],
        actTypeOrange: json["act_type_orange"],
        actTypeRed: json["act_type_red"],
        actTypeGreen: json["act_type_green"],
        checklist: json["checklist"] == null
            ? []
            : List<NcChecklist>.from(
                json["checklist"]!.map((x) => NcChecklist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "activity_type_name": activityTypeName,
        "activity_type_id": activityTypeId,
        "act_type_nc": actTypeNc,
        "act_type_yellow": actTypeYellow,
        "act_type_orange": actTypeOrange,
        "act_type_red": actTypeRed,
        "act_type_green": actTypeGreen,
        "checklist": checklist == null
            ? []
            : List<dynamic>.from(checklist!.map((x) => x.toJson())),
      };
}

class NcChecklist {
  String? checklistName;
  int? checklistId;

  NcChecklist({
    this.checklistName,
    this.checklistId,
  });

  factory NcChecklist.fromJson(Map<String, dynamic> json) => NcChecklist(
        checklistName: json["checklist_name"],
        checklistId: json["checklist_id"],
      );

  Map<String, dynamic> toJson() => {
        "checklist_name": checklistName,
        "checklist_id": checklistId,
      };
}
