// To parse this JSON data, do
//
//     final getFloorDataResponseModel = getFloorDataResponseModelFromJson(jsonString);

import 'dart:convert';

GetFloorDataResponseModel getFloorDataResponseModelFromJson(String str) =>
    GetFloorDataResponseModel.fromJson(json.decode(str));

String getFloorDataResponseModelToJson(GetFloorDataResponseModel data) =>
    json.encode(data.toJson());

class GetFloorDataResponseModel {
  String? status;
  String? message;
  ActivityData? activityData;

  GetFloorDataResponseModel({
    this.status,
    this.message,
    this.activityData,
  });

  factory GetFloorDataResponseModel.fromJson(Map<String, dynamic> json) =>
      GetFloorDataResponseModel(
        status: json["status"].toString(),
        message: json["message"].toString(),
        activityData: json["activity_data"] == null
            ? null
            : ActivityData.fromJson(json["activity_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "activity_data": activityData?.toJson(),
      };
}

class ActivityData {
  String? floorName;
  int? floorId;
  List<ListFloorData>? listFloorData;
  String? totalCount;

  ActivityData({
    this.floorName,
    this.floorId,
    this.listFloorData,
    this.totalCount,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) => ActivityData(
        floorName: json["floor_name"].toString(),
        floorId: json["floor_id"],
        listFloorData: json["list_floor_data"] == null
            ? []
            : List<ListFloorData>.from(
                json["list_floor_data"]!.map((x) => ListFloorData.fromJson(x))),
        totalCount: json["total_count"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "floor_name": floorName,
        "floor_id": floorId,
        "list_floor_data": listFloorData == null
            ? []
            : List<dynamic>.from(listFloorData!.map((x) => x.toJson())),
        "total_count": totalCount
      };
}

class ListFloorData {
  String? name;
  dynamic desc;
  int? activityId;
  String? progress;
  DateTime? writeDate;
  bool? activity_type_status;
  String? color;

  ListFloorData({
    this.name,
    this.desc,
    this.activityId,
    this.writeDate,
    this.progress,
    this.activity_type_status,
    this.color,
  });

  factory ListFloorData.fromJson(Map<String, dynamic> json) => ListFloorData(
        name: json["name"].toString(),
        desc: json["desc"].toString(),
        activityId: json["activity_id"],
        progress: json["progress"].toString(),
        activity_type_status: json["activity_type_status"] ?? false,
        writeDate: json["write_date"] == null
            ? null
            : DateTime.parse(json["write_date"]),
        color: json["color"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "progress": progress,
        "desc": desc,
        "activity_type_status": activity_type_status,
        "activity_id": activityId,
        "write_date": writeDate?.toIso8601String(),
        "color": color,
      };
}
