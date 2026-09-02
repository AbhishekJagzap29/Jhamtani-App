// To parse this JSON data, do
//
//     final flatNcResponseModel = flatNcResponseModelFromJson(jsonString);

import 'dart:convert';

FlatNcResponseModel flatNcResponseModelFromJson(String str) =>
    FlatNcResponseModel.fromJson(json.decode(str));

String flatNcResponseModelToJson(FlatNcResponseModel data) =>
    json.encode(data.toJson());

class FlatNcResponseModel {
  String? status;
  String? message;
  FlatNCProjectData? projectData;

  FlatNcResponseModel({
    this.status,
    this.message,
    this.projectData,
  });

  factory FlatNcResponseModel.fromJson(Map<String, dynamic> json) =>
      FlatNcResponseModel(
        status: json["status"],
        message: json["message"],
        projectData: json["project_data"] == null
            ? null
            : FlatNCProjectData.fromJson(json["project_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "project_data": projectData?.toJson(),
      };
}

class FlatNCProjectData {
  String? name;
  int? id;
  int? nc;
  int? flatsYellow;
  int? flatsOrange;
  int? flatsRed;
  int? flatsGreen;
  List<FlatActivityNcData>? activityData;

  FlatNCProjectData({
    this.name,
    this.id,
    this.nc,
    this.flatsYellow,
    this.flatsOrange,
    this.flatsRed,
    this.flatsGreen,
    this.activityData,
  });

  factory FlatNCProjectData.fromJson(Map<String, dynamic> json) =>
      FlatNCProjectData(
        name: json["name"],
        id: json["id"],
        nc: json["nc"],
        flatsYellow: json["flats_yellow"],
        flatsOrange: json["flats_orange"],
        flatsRed: json["flats_red"],
        flatsGreen: json["flats_green"],
        activityData: json["activity_data"] == null
            ? []
            : List<FlatActivityNcData>.from(json["activity_data"]!
                .map((x) => FlatActivityNcData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "nc": nc,
        "flats_yellow": flatsYellow,
        "flats_orange": flatsOrange,
        "flats_red": flatsRed,
        "flats_green": flatsGreen,
        "activity_data": activityData == null
            ? []
            : List<dynamic>.from(activityData!.map((x) => x.toJson())),
      };
}

class FlatActivityNcData {
  String? activityName;
  int? activityId;

  FlatActivityNcData({
    this.activityName,
    this.activityId,
  });

  factory FlatActivityNcData.fromJson(Map<String, dynamic> json) =>
      FlatActivityNcData(
        activityName: json["activity_name"],
        activityId: json["activity_id"],
      );

  Map<String, dynamic> toJson() => {
        "activity_name": activityName,
        "activity_id": activityId,
      };
}
