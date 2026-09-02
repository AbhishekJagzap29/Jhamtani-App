import 'dart:convert';

CommonActivityTypeResponseModel commonActivityTypeResponseModelFromJson(
        String str) =>
    CommonActivityTypeResponseModel.fromJson(json.decode(str));

String commonActivityTypeResponseModelToJson(
        CommonActivityTypeResponseModel data) =>
    json.encode(data.toJson());

class CommonActivityTypeResponseModel {
  dynamic status;
  dynamic message;
  ActivityDataItem? activityData;

  CommonActivityTypeResponseModel({
    this.status,
    this.message,
    this.activityData,
  });

  factory CommonActivityTypeResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonActivityTypeResponseModel(
        status: json["status"]?.toString(),
        message: json["message"]?.toString(),
        activityData: json["activity_data"] != null
            ? ActivityDataItem.fromJson(json["activity_data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "activity_data": activityData?.toJson(),
      };
}

class ActivityDataItem {
  String? activityName;
  int? activityId;
  double? activityProgress;
  int? projectId;
  String? projectName;
  int? towerId;
  String? towerName;
  int? floorId;
  String? floorName;
  List<ActivityTypeItem>? listChecklistData;
  int? totalCount;

  ActivityDataItem({
    this.activityName,
    this.activityId,
    this.activityProgress,
    this.projectId,
    this.projectName,
    this.towerId,
    this.towerName,
    this.floorId,
    this.floorName,
    this.listChecklistData,
    this.totalCount,
  });

  factory ActivityDataItem.fromJson(Map<String, dynamic> json) => ActivityDataItem(
        activityName: json["activity_name"] ?? "",
        activityId: json["activity_id"],
        activityProgress: json["activity_progress"]?.toDouble() ?? 0.0,
        projectId: json["project_id"],
        projectName: json["project_name"] ?? "",
        towerId: json["tower_id"],
        towerName: json["tower_name"] ?? "",
        floorId: json["floor_id"],
        floorName: json["floor_name"] ?? "",
        listChecklistData: json["checklist_data"] != null
            ? List<ActivityTypeItem>.from(json["checklist_data"]
                .map((x) => ActivityTypeItem.fromJson(x)))
            : [],
        totalCount: json["total_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "activity_name": activityName,
        "activity_id": activityId,
        "activity_progress": activityProgress,
        "project_id": projectId,
        "project_name": projectName,
        "tower_id": towerId,
        "tower_name": towerName,
        "floor_id": floorId,
        "floor_name": floorName,
        "checklist_data":
            listChecklistData?.map((x) => x.toJson()).toList(),
        "total_count": totalCount,
      };
}

class ActivityTypeItem {
  int? activityId;
  String? name;
  String? desc;
  String? writeDate;
  bool? activityTypeStatus;
  double? progress;
  String? color;

  ActivityTypeItem({
    this.activityId,
    this.name,
    this.desc,
    this.writeDate,
    this.activityTypeStatus,
    this.progress,
    this.color,
  });

  factory ActivityTypeItem.fromJson(Map<String, dynamic> json) =>
      ActivityTypeItem(
        activityId: json["activity_id"],
        name: json["name"] ?? "",
        desc: json["desc"] ?? "",
        writeDate: json["write_date"] ?? "",
        activityTypeStatus: json["activity_type_status"] ?? false,
        progress: json["progress"]?.toDouble() ?? 0.0,
        color: json["color"] ?? "",
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
