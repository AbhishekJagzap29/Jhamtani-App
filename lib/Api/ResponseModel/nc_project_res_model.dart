import 'dart:convert';

ProjectNcResponseModel projectNcResponseModelFromJson(String str) => ProjectNcResponseModel.fromJson(json.decode(str));

String projectNcResponseModelToJson(ProjectNcResponseModel data) => json.encode(data.toJson());

class ProjectNcResponseModel {
  String? status;
  String? message;
  NCProjectData? projectData;

  ProjectNcResponseModel({
    this.status,
    this.message,
    this.projectData,
  });

  factory ProjectNcResponseModel.fromJson(Map<String, dynamic> json) => ProjectNcResponseModel(
        status: json["status"],
        message: json["message"],
        projectData: json["project_data"] == null ? null : NCProjectData.fromJson(json["project_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "project_data": projectData?.toJson(),
      };
}

class NCProjectData {
  String? projectName;
  int? projectId;
  int? ncCount;
  int? yellowFlagCount;
  int? orangeFlagCount;
  int? redFlagCount;
  int? greenFlagCount;
  List<NCTowerDataList>? towerData;
  double? progress;

  NCProjectData({
    this.projectName,
    this.projectId,
    this.ncCount,
    this.yellowFlagCount,
    this.orangeFlagCount,
    this.redFlagCount,
    this.greenFlagCount,
    this.towerData,
    this.progress,
  });

  factory NCProjectData.fromJson(Map<String, dynamic> json) => NCProjectData(
        projectName: json["project_name"],
        projectId: json["project_id"],
        ncCount: json["nc_count"],
        yellowFlagCount: json["yellow_flag_count"],
        orangeFlagCount: json["orange_flag_count"],
        redFlagCount: json["red_flag_count"],
        greenFlagCount: json["green_flag_count"],
        progress: json["progress"] == null ? 0.0 : json["progress"],
        towerData:
            json["tower_data"] == null ? [] : List<NCTowerDataList>.from(json["tower_data"]!.map((x) => NCTowerDataList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "project_name": projectName,
        "project_id": projectId,
        "nc_count": ncCount,
        "yellow_flag_count": yellowFlagCount,
        "orange_flag_count": orangeFlagCount,
        "red_flag_count": redFlagCount,
        "green_flag_count": greenFlagCount,
        "progress": progress,
        "tower_data": towerData == null ? [] : List<dynamic>.from(towerData!.map((x) => x.toJson())),
      };
}

class NCTowerDataList {
  String? towerName;
  int? towerId;

  NCTowerDataList({
    this.towerName,
    this.towerId,
  });

  factory NCTowerDataList.fromJson(Map<String, dynamic> json) => NCTowerDataList(
        towerName: json["tower_name"],
        towerId: json["tower_id"],
      );

  Map<String, dynamic> toJson() => {
        "tower_name": towerName,
        "tower_id": towerId,
      };
}
