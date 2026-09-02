// To parse this JSON data, do
//
//     final floorAcNcResponseModel = floorAcNcResponseModelFromJson(jsonString);

import 'dart:convert';

ActivityNcResponseModel floorAcNcResponseModelFromJson(String str) =>
    ActivityNcResponseModel.fromJson(json.decode(str));

String floorAcNcResponseModelToJson(ActivityNcResponseModel data) =>
    json.encode(data.toJson());

class ActivityNcResponseModel {
  String? status;
  String? message;
  ActivityNCProjectData? projectData;

  ActivityNcResponseModel({
    this.status,
    this.message,
    this.projectData,
  });

  factory ActivityNcResponseModel.fromJson(Map<String, dynamic> json) =>
      ActivityNcResponseModel(
        status: json["status"],
        message: json["message"],
        projectData: json["project_data"] == null
            ? null
            : ActivityNCProjectData.fromJson(json["project_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "project_data": projectData?.toJson(),
      };
}

class ActivityNCProjectData {
  String? activityName;
  int? activityId;
  int? actNc;
  int? actYellow;
  int? actOrange;
  int? actRed;
  int? actGreen;
  List<NcActivityTypeList>? activityType;

  ActivityNCProjectData({
    this.activityName,
    this.activityId,
    this.actNc,
    this.actYellow,
    this.actOrange,
    this.actRed,
    this.actGreen,
    this.activityType,
  });

  factory ActivityNCProjectData.fromJson(Map<String, dynamic> json) =>
      ActivityNCProjectData(
        activityName: json["activity_name"],
        activityId: json["activity_id"],
        actNc: json["act_nc"],
        actYellow: json["act_yellow"],
        actOrange: json["act_orange"],
        actRed: json["act_red"],
        actGreen: json["act_green"],
        activityType: json["activity_type"] == null
            ? []
            : List<NcActivityTypeList>.from(json["activity_type"]!
                .map((x) => NcActivityTypeList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "activity_name": activityName,
        "activity_id": activityId,
        "act_nc": actNc,
        "act_yellow": actYellow,
        "act_orange": actOrange,
        "act_red": actRed,
        "act_green": actGreen,
        "activity_type": activityType == null
            ? []
            : List<dynamic>.from(activityType!.map((x) => x.toJson())),
      };
}

class NcActivityTypeList {
  String? activityTypeName;
  int? activityTypeId;

  NcActivityTypeList({
    this.activityTypeName,
    this.activityTypeId,
  });

  factory NcActivityTypeList.fromJson(Map<String, dynamic> json) =>
      NcActivityTypeList(
        activityTypeName: json["activity_type_name"],
        activityTypeId: json["activity_type_id"],
      );

  Map<String, dynamic> toJson() => {
        "activity_type_name": activityTypeName,
        "activity_type_id": activityTypeId,
      };
}
