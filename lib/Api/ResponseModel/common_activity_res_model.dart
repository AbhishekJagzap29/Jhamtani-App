import 'dart:convert';

CommonActivityResponseModel commonActivityResponseModelFromJson(String str) =>
    CommonActivityResponseModel.fromJson(json.decode(str));

String commonActivityResponseModelToJson(CommonActivityResponseModel data) =>
    json.encode(data.toJson());

class CommonActivityResponseModel {
  String? status;
  String? message;
  ActivityData? activityData;

  CommonActivityResponseModel({
    this.status,
    this.message,
    this.activityData,
  });

  factory CommonActivityResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonActivityResponseModel(
        status: json["status"]?.toString(),
        message: json["message"]?.toString(),
        activityData: json["activity_data"] != null
            ? ActivityData.fromJson(json["activity_data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "activity_data": activityData?.toJson(),
      };
}

class ActivityData {
  String? towerName;
  int? towerId;
  List<ActivityItem>? activityCommonData;
  int? totalCount;

  ActivityData({
    this.towerName,
    this.towerId,
    this.activityCommonData,
    this.totalCount,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) => ActivityData(
        towerName: json["tower_name"] ?? "",
        towerId: json["tower_id"],
        activityCommonData: json["list_flat_data"] != null
            ? List<ActivityItem>.from(
                json["list_flat_data"].map((x) => ActivityItem.fromJson(x)))
            : [],
        totalCount: json["total_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "tower_name": towerName,
        "tower_id": towerId,
        "list_flat_data": activityCommonData?.map((x) => x.toJson()).toList(),
        "total_count": totalCount,
      };
}

class ActivityItem {
  int? activityId;
  String? name;
  String? desc;
  DateTime? writeDate;
  bool? activityTypeStatus;
  double? progress;
  String? color;

  ActivityItem({
    this.activityId,
    this.name,
    this.desc,
    this.writeDate,
    this.activityTypeStatus,
    this.progress,
    this.color,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) => ActivityItem(
        activityId: json["activity_id"],
        name: json["name"] ?? "",
        desc: json["desc"] ?? "",
        writeDate: json["write_date"] != null
            ? DateTime.tryParse(json["write_date"])
            : null,
        activityTypeStatus: json["activity_type_status"] ?? false,
        progress: json["progress"] != null
            ? double.tryParse(json["progress"].toString())
            : 0.0,
        color: json["color"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "activity_id": activityId,
        "name": name,
        "desc": desc,
        "write_date": writeDate?.toIso8601String(),
        "activity_type_status": activityTypeStatus,
        "progress": progress,
        "color": color,
      };
}