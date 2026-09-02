// To parse this JSON data, do
//
//     final towerNcResponseModel = towerNcResponseModelFromJson(jsonString);

import 'dart:convert';

TowerNcResponseModel towerNcResponseModelFromJson(String str) =>
    TowerNcResponseModel.fromJson(json.decode(str));

String towerNcResponseModelToJson(TowerNcResponseModel data) =>
    json.encode(data.toJson());

class TowerNcResponseModel {
  String? status;
  String? message;
  TowerNCProjectData? projectData;

  TowerNcResponseModel({
    this.status,
    this.message,
    this.projectData,
  });

  factory TowerNcResponseModel.fromJson(Map<String, dynamic> json) =>
      TowerNcResponseModel(
        status: json["status"],
        message: json["message"],
        projectData: json["project_data"] == null
            ? null
            : TowerNCProjectData.fromJson(json["project_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "project_data": projectData?.toJson(),
      };
}

class TowerNCProjectData {
  String? towerName;
  int? towerId;
  int? projectNc;
  int? projectYellow;
  int? projectOrange;
  int? projectRed;
  int? greenFlagCount;
  List<NcFloorData>? floorData;
  List<NcFlatData>? flatData;

  TowerNCProjectData({
    this.towerName,
    this.towerId,
    this.projectNc,
    this.projectYellow,
    this.projectOrange,
    this.projectRed,
    this.greenFlagCount,
    this.floorData,
    this.flatData,
  });

  factory TowerNCProjectData.fromJson(Map<String, dynamic> json) =>
      TowerNCProjectData(
        towerName: json["tower_name"],
        towerId: json["tower_id"],
        projectNc: json["project_nc"],
        projectYellow: json["project_yellow"],
        projectOrange: json["project_orange"],
        projectRed: json["project_red"],
        greenFlagCount: json["green_flag_count"],
        floorData: json["floor_data"] == null
            ? []
            : List<NcFloorData>.from(
                json["floor_data"]!.map((x) => NcFloorData.fromJson(x))),
        flatData: json["flat_data"] == null
            ? []
            : List<NcFlatData>.from(
                json["flat_data"]!.map((x) => NcFlatData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tower_name": towerName,
        "tower_id": towerId,
        "project_nc": projectNc,
        "project_yellow": projectYellow,
        "project_orange": projectOrange,
        "project_red": projectRed,
        "green_flag_count": greenFlagCount,
        "floor_data": floorData == null
            ? []
            : List<dynamic>.from(floorData!.map((x) => x.toJson())),
        "flat_data": flatData == null
            ? []
            : List<dynamic>.from(flatData!.map((x) => x.toJson())),
      };
}

class NcFlatData {
  String? flatName;
  int? flatId;

  NcFlatData({
    this.flatName,
    this.flatId,
  });

  factory NcFlatData.fromJson(Map<String, dynamic> json) => NcFlatData(
        flatName: json["flat_name"],
        flatId: json["flat_id"],
      );

  Map<String, dynamic> toJson() => {
        "flat_name": flatName,
        "flat_id": flatId,
      };
}

class NcFloorData {
  String? floorName;
  int? floorId;

  NcFloorData({
    this.floorName,
    this.floorId,
  });

  factory NcFloorData.fromJson(Map<String, dynamic> json) => NcFloorData(
        floorName: json["floor_name"],
        floorId: json["floor_id"],
      );

  Map<String, dynamic> toJson() => {
        "floor_name": floorName,
        "floor_id": floorId,
      };
}
