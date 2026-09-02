/// NEW CODE
import 'dart:convert';

GetFlatFloorDataResponseModel getFlatFloorDataResponseModelFromJson(
        String str) =>
    GetFlatFloorDataResponseModel.fromJson(json.decode(str));

String getFlatFloorDataResponseModelToJson(
        GetFlatFloorDataResponseModel data) =>
    json.encode(data.toJson());

class GetFlatFloorDataResponseModel {
  dynamic status;
  dynamic message;
  TowerData? towerData;

  GetFlatFloorDataResponseModel({
    this.status,
    this.message,
    this.towerData,
  });

  factory GetFlatFloorDataResponseModel.fromJson(Map<String, dynamic> json) =>
      GetFlatFloorDataResponseModel(
        status: json["status"].toString(),
        message: json["message"].toString(),
        towerData: json["tower_data"] == null
            ? null
            : TowerData.fromJson(json["tower_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "tower_data": towerData?.toJson(),
      };
}

// class TowerData {
//   dynamic towerName;
//   int? towerId;
//   double? progress;
//   List<ListFloor>? listFloorData;
//   List<ListFloor>? listFlatData;
//   int? towerTotalCount;
//   int? towerMakerCount;
//   int? towerCheckerCount;
//   int? towerApproverCount;
//   int? flatTotalCount;
//   int? flatMakerCount;
//   int? flatCheckerCount;
//   int? flatApproverCount;
//   int? floorTotalCount;
//   int? floorMakerCount;
//   int? floorCheckerCount;
//   int? floorApproverCount;

//   TowerData({
//     this.towerName,
//     this.towerId,
//     this.progress,
//     this.listFloorData,
//     this.listFlatData,
//     this.towerTotalCount,
//     this.towerMakerCount,
//     this.towerCheckerCount,
//     this.towerApproverCount,
//     this.flatTotalCount,
//     this.flatMakerCount,
//     this.flatCheckerCount,
//     this.flatApproverCount,
//     this.floorTotalCount,
//     this.floorMakerCount,
//     this.floorCheckerCount,
//     this.floorApproverCount,
//   });

//   factory TowerData.fromJson(Map<String, dynamic> json) => TowerData(
//         towerName: json["tower_name"].toString(),
//         towerId: json["tower_id"],
//          progress: json["progress"],
//         listFloorData: json["list_floor_data"] == null
//             ? []
//             : List<ListFloor>.from(
//                 json["list_floor_data"]!.map((x) => ListFloor.fromJson(x))),
//         listFlatData: json["list_flat_data"] == null
//             ? []
//             : List<ListFloor>.from(
//                 json["list_flat_data"]!.map((x) => ListFloor.fromJson(x))),
//         towerTotalCount: json["tower_total_count"],
//         towerMakerCount: json["tower_maker_count"],
//         towerCheckerCount: json["tower_checker_count"],
//         towerApproverCount: json["tower_approver_count"],
//         flatTotalCount: json["flat_total_count"],
//         flatMakerCount: json["flat_maker_count"],
//         flatCheckerCount: json["flat_checker_count"],
//         flatApproverCount: json["flat_approver_count"],
//         floorTotalCount: json["floor_total_count"],
//         floorMakerCount: json["floor_maker_count"],
//         floorCheckerCount: json["floor_checker_count"],
//         floorApproverCount: json["floor_approver_count"],
//       );

//   Map<String, dynamic> toJson() => {
//         "tower_name": towerName,
//         "tower_id": towerId,
//         "progress": progress,
//         "list_floor_data": listFloorData == null
//             ? []
//             : List<dynamic>.from(listFloorData!.map((x) => x.toJson())),
//         "list_flat_data": listFlatData == null
//             ? []
//             : List<dynamic>.from(listFlatData!.map((x) => x.toJson())),
//         "tower_total_count": towerTotalCount,
//         "tower_maker_count": towerMakerCount,
//         "tower_checker_count": towerCheckerCount,
//         "tower_approver_count": towerApproverCount,
//         "flat_total_count": flatTotalCount,
//         "flat_maker_count": flatMakerCount,
//         "flat_checker_count": flatCheckerCount,
//         "flat_approver_count": flatApproverCount,
//         "floor_total_count": floorTotalCount,
//         "floor_maker_count": floorMakerCount,
//         "floor_checker_count": floorCheckerCount,
//         "floor_approver_count": floorApproverCount,
//       };
// }

// class ListFloor {
//   dynamic name;
//   int? floorId;
//   String? progress;
//   String? totalCount;
//   String? makerCount;
//   String? checkerCount;
//   String? approverCount;

//   ListFloor({
//     this.name,
//     this.floorId,
//     this.progress,
//     this.totalCount,
//     this.approverCount,
//     this.checkerCount,
//     this.makerCount,
//   });

//   factory ListFloor.fromJson(Map<String, dynamic> json) => ListFloor(
//         name: json["name"].toString(),
//         progress: json["progress"].toString(),
//         floorId: json["floor_id"] ?? json["flat_id"],
//         totalCount: json["total_count"].toString(),
//         makerCount: json["maker_count"].toString(),
//         checkerCount: json["checker_count"].toString(),
//         approverCount: json["approver_count"].toString(),
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "floor_id": floorId,
//         "progress": progress,
//         "total_count": totalCount,
//         "maker_count": makerCount,
//         "checker_count": checkerCount,
//         "approver_count": approverCount,
//       };
// }



class TowerData {

 dynamic towerName;
  int? towerId;
  double? progress;
  List<ListFloor>? listFloorData;
  List<ListFloor>? listFlatData;
  int? towerTotalCount;
  int? towerMakerCount;
  int? towerCheckerCount;
  int? towerApproverCount;
  int? flatTotalCount;
  int? flatMakerCount;
  int? flatCheckerCount;
  int? flatApproverCount;
  int? floorTotalCount;
  int? floorMakerCount;
  int? floorCheckerCount;
  int? floorApproverCount;

  int? comTotal;
  int? comMaker;
  int? comChecker;
   int? comApprover;

  List<CommonData>? comData;

  int? devTotal;
  int? devMaker;
  int? devChecker;
  int?devApprover;
  List<DevData>? devData;

  TowerData({
    this.towerName,
    this.towerId,
    this.progress,
    this.listFloorData,
    this.listFlatData,
    this.towerTotalCount,
    this.towerMakerCount,
    this.towerCheckerCount,
    this.towerApproverCount,
    this.flatTotalCount,
    this.flatMakerCount,
    this.flatCheckerCount,
    this.flatApproverCount,
    this.floorTotalCount,
    this.floorMakerCount,
    this.floorCheckerCount,
    this.floorApproverCount,
    this.comTotal,
    this.comMaker,
    this.comChecker,
    this.comApprover,
    this.comData,
    this.devTotal,
    this.devMaker,
    this.devChecker,
    this.devApprover,
    this.devData,
  });

  factory TowerData.fromJson(Map<String, dynamic> json) => TowerData(
        towerName: json["tower_name"].toString(),
        towerId: json["tower_id"],
        progress: json["progress"],
        listFloorData: json["list_floor_data"] == null
            ? []
            : List<ListFloor>.from(json["list_floor_data"]!.map((x) => ListFloor.fromJson(x))),
        listFlatData: json["list_flat_data"] == null
            ? []
            : List<ListFloor>.from(json["list_flat_data"]!.map((x) => ListFloor.fromJson(x))),
        towerTotalCount: json["tower_total_count"],
        towerMakerCount: json["tower_maker_count"],
        towerCheckerCount: json["tower_checker_count"],
        towerApproverCount: json["tower_approver_count"],
        flatTotalCount: json["flat_total_count"],
        flatMakerCount: json["flat_maker_count"],
        flatCheckerCount: json["flat_checker_count"],
        flatApproverCount: json["flat_approver_count"],
        floorTotalCount: json["floor_total_count"],
        floorMakerCount: json["floor_maker_count"],
        floorCheckerCount: json["floor_checker_count"],
        floorApproverCount: json["floor_approver_count"],
        comTotal: json["com_total"],
        comMaker: json["com_maker"],
        comChecker: json["com_checker"],
        comApprover: json["com_approver"],
        comData: json["com_data"] == null
            ? []
            : List<CommonData>.from(json["com_data"].map((x) => CommonData.fromJson(x))),
        devTotal: json["dev_total"],
        devMaker: json["dev_maker"],
        devChecker: json["dev_checker"],
        devApprover: json["dev_approver"],
        devData: json["dev_data"] == null
            ? []
            : List<DevData>.from(json["dev_data"].map((x) => DevData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tower_name": towerName,
        "tower_id": towerId,
        "progress": progress,
        "list_floor_data": listFloorData == null ? [] : List<dynamic>.from(listFloorData!.map((x) => x.toJson())),
        "list_flat_data": listFlatData == null ? [] : List<dynamic>.from(listFlatData!.map((x) => x.toJson())),
        "tower_total_count": towerTotalCount,
        "tower_maker_count": towerMakerCount,
        "tower_checker_count": towerCheckerCount,
        "tower_approver_count": towerApproverCount,
        "flat_total_count": flatTotalCount,
        "flat_maker_count": flatMakerCount,
        "flat_checker_count": flatCheckerCount,
        "flat_approver_count": flatApproverCount,
        "floor_total_count": floorTotalCount,
        "floor_maker_count": floorMakerCount,
        "floor_checker_count": floorCheckerCount,
        "floor_approver_count": floorApproverCount,
        "com_total": comTotal,
        "com_maker": comMaker,
        "com_checker": comChecker,
        "com_approver": comApprover,
        "com_data": comData == null ? [] : List<dynamic>.from(comData!.map((x) => x.toJson())),
        "dev_total": devTotal,
        "dev_maker": devMaker,
        "dev_checker": devChecker,
        "dev_approver": devApprover,
        "dev_data": devData == null ? [] : List<dynamic>.from(devData!.map((x) => x.toJson())),
      };
}



class ListFloor {
  dynamic name;
  int? floorId;
  String? progress;
  String? totalCount;
  String? makerCount;
  String? checkerCount;
  String? approverCount;

  ListFloor({
    this.name,
    this.floorId,
    this.progress,
    this.totalCount,
    this.approverCount,
    this.checkerCount,
    this.makerCount,
  });

  factory ListFloor.fromJson(Map<String, dynamic> json) => ListFloor(
        name: json["name"].toString(),
        progress: json["progress"].toString(),
        floorId: json["floor_id"] ?? json["flat_id"],
        totalCount: json["total_count"].toString(),
        makerCount: json["maker_count"].toString(),
        checkerCount: json["checker_count"].toString(),
        approverCount: json["approver_count"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "floor_id": floorId,
        "progress": progress,
        "total_count": totalCount,
        "maker_count": makerCount,
        "checker_count": checkerCount,
        "approver_count": approverCount,
      };
}




class CommonData {
  String? name;
  int? commonActId;
  double? progress;
  int? totalCount;
  int? makerCount;
  int? checkerCount;
  int? approverCount;

  CommonData({
    this.name,
    this.commonActId,
    this.progress,
    this.totalCount,
    this.makerCount,
    this.checkerCount,
    this.approverCount,
  });

  factory CommonData.fromJson(Map<String, dynamic> json) => CommonData(
        name: json["name"].toString(),
        commonActId: json["common_act_id"],
        progress: json["progress"]?.toDouble(),
        totalCount: json["total_count"],
        makerCount: json["maker_count"],
        checkerCount: json["checker_count"],
        approverCount: json["approver_count"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "common_act_id": commonActId,
        "progress": progress,
        "total_count": totalCount,
        "maker_count": makerCount,
        "checker_count": checkerCount,
        "approver_count": approverCount,
      };
}

class DevData {
  String? name;
  int? devActId;
  double? progress;
  int? totalCount;
  int? makerCount;
  int? checkerCount;
  int? approverCount;

  DevData({
    this.name,
    this.devActId,
    this.progress,
    this.totalCount,
    this.makerCount,
    this.checkerCount,
    this.approverCount,
  });

  factory DevData.fromJson(Map<String, dynamic> json) => DevData(
        name: json["name"].toString(),
        devActId: json["dev_act_id"],
        progress: json["progress"]?.toDouble(),
        totalCount: json["total_count"],
        makerCount: json["maker_count"],
        checkerCount: json["checker_count"],
        approverCount: json["approver_count"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "dev_act_id": devActId,
        "progress": progress,
        "total_count": totalCount,
        "maker_count": makerCount,
        "checker_count": checkerCount,
        "approver_count": approverCount,
      };
}
