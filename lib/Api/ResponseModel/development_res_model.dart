import 'dart:convert';

DevelopmentResponseModel DevelopmentResponseModelFromJson(String str) =>
    DevelopmentResponseModel.fromJson(json.decode(str));

String DevelopmentResponseModelToJson(DevelopmentResponseModel data) =>
    json.encode(data.toJson());

class DevelopmentResponseModel {
  String? status;
  String? message;
  DevelopmentActivityData? developmentactivityData;

  DevelopmentResponseModel({
    this.status,
    this.message,
    this.developmentactivityData,
  });

  factory DevelopmentResponseModel.fromJson(Map<String, dynamic> json) =>
      DevelopmentResponseModel(
        status: json["status"]?.toString(),
        message: json["message"]?.toString(),
        developmentactivityData: json["activity_data"] != null
            ? DevelopmentActivityData.fromJson(json["activity_data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "activity_data": developmentactivityData?.toJson(),
      };
}

class DevelopmentActivityData {
  String? towerName;
  int? towerId;
  List<DevelopmentActivityItem>? developmentActivityCommonData;
  int? totalCount;

  DevelopmentActivityData({
    this.towerName,
    this.towerId,
    this.developmentActivityCommonData,
    this.totalCount,
  });

  factory DevelopmentActivityData.fromJson(Map<String, dynamic> json) => DevelopmentActivityData(
        towerName: json["tower_name"] ?? "",
        towerId: json["tower_id"],
        developmentActivityCommonData: json["list_flat_data"] != null
            ? List<DevelopmentActivityItem>.from(
                json["list_flat_data"].map((x) => DevelopmentActivityItem.fromJson(x)))
            : [],
        totalCount: json["total_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "tower_name": towerName,
        "tower_id": towerId,
        "list_flat_data": developmentActivityCommonData?.map((x) => x.toJson()).toList(),
        "total_count": totalCount,
      };
}

class DevelopmentActivityItem {
  int? activityId;
  String? name;
  String? desc;
  String? writeDate; 
  bool? activityTypeStatus;
  double? progress;
  String? color;

  DevelopmentActivityItem({
    this.activityId,
    this.name,
    this.desc,
    this.writeDate,
    this.activityTypeStatus,
    this.progress,
    this.color,
  });

  factory DevelopmentActivityItem.fromJson(Map<String, dynamic> json) => DevelopmentActivityItem(
        activityId: json["activity_id"],
        name: json["name"] ?? "",
        desc: json["desc"] ?? "", 
        writeDate: json["write_date"] ?? "", 
        activityTypeStatus: json["activity_type_status"] ?? false,
        progress: json["progress"] != null
            ? double.tryParse(json["progress"].toString())
            : 0.0,
        color: json["color"] ?? "yellow",
      );

  Map<String, dynamic> toJson() => {
        "activity_id": activityId,
        "name": name,
        "desc": desc,
        "write_date": writeDate,
        "activity_type_status": activityTypeStatus,
        "progress": progress,
        "color": color,
      };
}
