// To parse this JSON data, do
//
//     final floorNcResponseModel = floorNcResponseModelFromJson(jsonString);

import 'dart:convert';

FloorNcResponseModel floorNcResponseModelFromJson(String str) =>
    FloorNcResponseModel.fromJson(json.decode(str));

String floorNcResponseModelToJson(FloorNcResponseModel data) =>
    json.encode(data.toJson());

class FloorNcResponseModel {
  String? status;
  String? message;
  FloorNCProjectData? projectData;

  FloorNcResponseModel({
    this.status,
    this.message,
    this.projectData,
  });

  factory FloorNcResponseModel.fromJson(Map<String, dynamic> json) =>
      FloorNcResponseModel(
        status: json["status"],
        message: json["message"],
        projectData: json["project_data"] == null
            ? null
            : FloorNCProjectData.fromJson(json["project_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "project_data": projectData?.toJson(),
      };
}

class FloorNCProjectData {
  String? name;
  int? id;
  int? nc;
  int? floorsYellow;
  int? floorsOrange;
  int? floorsRed;
  int? floorsGreen;
  List<FloorActivityNcData>? activityData;

  FloorNCProjectData({
    this.name,
    this.id,
    this.nc,
    this.floorsYellow,
    this.floorsOrange,
    this.floorsRed,
    this.floorsGreen,
    this.activityData,
  });

  factory FloorNCProjectData.fromJson(Map<String, dynamic> json) =>
      FloorNCProjectData(
        name: json["name"],
        id: json["id"],
        nc: json["nc"],
        floorsYellow: json["floors_yellow"],
        floorsOrange: json["floors_orange"],
        floorsRed: json["floors_red"],
        floorsGreen: json["floors_green"],
        activityData: json["activity_data"] == null
            ? []
            : List<FloorActivityNcData>.from(json["activity_data"]!
                .map((x) => FloorActivityNcData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "nc": nc,
        "floors_yellow": floorsYellow,
        "floors_orange": floorsOrange,
        "floors_red": floorsRed,
        "floors_green": floorsGreen,
        "activity_data": activityData == null
            ? []
            : List<dynamic>.from(activityData!.map((x) => x.toJson())),
      };
}

class FloorActivityNcData {
  String? activityName;
  int? activityId;

  FloorActivityNcData({
    this.activityName,
    this.activityId,
  });

  factory FloorActivityNcData.fromJson(Map<String, dynamic> json) =>
      FloorActivityNcData(
        activityName: json["activity_name"],
        activityId: json["activity_id"],
      );

  Map<String, dynamic> toJson() => {
        "activity_name": activityName,
        "activity_id": activityId,
      };
}
