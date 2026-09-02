// To parse this JSON data, do
//
//     final getFlatDataResponseModel = getFlatDataResponseModelFromJson(jsonString);

import 'dart:convert';

GetFlatDataResponseModel getFlatDataResponseModelFromJson(String str) =>
    GetFlatDataResponseModel.fromJson(json.decode(str));

String getFlatDataResponseModelToJson(GetFlatDataResponseModel data) =>
    json.encode(data.toJson());

class GetFlatDataResponseModel {
  String? status;
  String? message;
  ActivityData? activityData;

  GetFlatDataResponseModel({
    this.status,
    this.message,
    this.activityData,
  });

  factory GetFlatDataResponseModel.fromJson(Map<String, dynamic> json) =>
      GetFlatDataResponseModel(
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
  String? flatName;
  int? flatId;
  List<ListFlatData>? listFlatData;
  String? totalCount;

  ActivityData({
    this.flatName,
    this.flatId,
    this.listFlatData,
    this.totalCount,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) => ActivityData(
        flatName: json["flat_name"].toString(),
        flatId: json["flat_id"],
        listFlatData: json["list_flat_data"] == null
            ? []
            : List<ListFlatData>.from(
                json["list_flat_data"]!.map((x) => ListFlatData.fromJson(x))),
        totalCount: json["total_count"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "flat_name": flatName,
        "flat_id": flatId,
        "list_flat_data": listFlatData == null
            ? []
            : List<dynamic>.from(listFlatData!.map((x) => x.toJson())),
        "total_count": totalCount,
      };
}

class ListFlatData {
  String? name;
  dynamic desc;
  int? activityId;
  String? progress;
  DateTime? writeDate;
  bool? activity_type_status;
  String? color;

  ListFlatData({
    this.name,
    this.desc,
    this.activity_type_status,
    this.progress,
    this.activityId,
    this.writeDate,
    this.color,
  });

  factory ListFlatData.fromJson(Map<String, dynamic> json) => ListFlatData(
        name: json["name"].toString(),
        desc: json["desc"].toString(),
        activity_type_status: json["activity_type_status"] ?? false,
        activityId: json["activity_id"],
        progress: json["progress"].toString(),
        writeDate: json["write_date"] == null
            ? null
            : DateTime.parse(json["write_date"]),
        color: json["color"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "desc": desc,
        "progress": progress,
        "activity_type_status": activity_type_status,
        "activity_id": activityId,
        "write_date": writeDate?.toIso8601String(),
        "color": color,
      };
}
