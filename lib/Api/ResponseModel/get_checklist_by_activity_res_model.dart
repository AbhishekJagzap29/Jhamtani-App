//WORKING CODE
// import 'dart:convert';

// import 'package:flutter/material.dart';

// ChecklistByActivityResponseModel checklistByActivityResponseModelFromJson(
//         String str) =>
//     ChecklistByActivityResponseModel.fromJson(json.decode(str));

// String checklistByActivityResponseModelToJson(
//         ChecklistByActivityResponseModel data) =>
//     json.encode(data.toJson());

// class ChecklistByActivityResponseModel {
//   String? status;
//   String? message;
//   ChecklistData? checklistData;

//   ChecklistByActivityResponseModel({
//     this.status,
//     this.message,
//     this.checklistData,
//   });

//   factory ChecklistByActivityResponseModel.fromJson(
//           Map<String, dynamic> json) =>
//       ChecklistByActivityResponseModel(
//         status: json["status"].toString(),
//         message: json["message"].toString(),
//         checklistData: json["checklist_data"] == null
//             ? null
//             : ChecklistData.fromJson(json["checklist_data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "checklist_data": checklistData?.toJson(),
//       };
// }

// class ChecklistData {
//   String? activityName;
//   int? activityId;
//   List<ListChecklistDataByAc>? listChecklistData;

//   ChecklistData({
//     this.activityName,
//     this.activityId,
//     this.listChecklistData,
//   });

//   factory ChecklistData.fromJson(Map<String, dynamic> json) => ChecklistData(
//         activityName: json["activity_name"].toString(),
//         activityId: json["activity_id"],
//         listChecklistData: json["list_checklist_data"] == null
//             ? []
//             : List<ListChecklistDataByAc>.from(json["list_checklist_data"]!
//                 .map((x) => ListChecklistDataByAc.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "activity_name": activityName,
//         "activity_id": activityId,
//         "list_checklist_data": listChecklistData == null
//             ? []
//             : List<dynamic>.from(listChecklistData!.map((x) => x.toJson())),
//       };
// }

// class ListChecklistDataByAc {
//   String? name;
//   String? activity_name;
//   String? activityStatus;
//   int? checklistId;
//   int? activityTypeId;
//   String? activityTypeProgress;
//   List<LineData>? lineData;
//   String? projectId;
//   String? projectName;
//   String? flat;
//   String? flatName;
//   String? towerId;
//   String? towerName;
//   dynamic floodId;
//   dynamic flooName;
//   TextEditingController controller;
//   List? overallImagesList;
//   String? color;
//   String? wiStatus;

//   ListChecklistDataByAc({
//     this.name,
//     this.activity_name,
//     this.activityStatus,
//     this.checklistId,
//     this.activityTypeId,
//     this.lineData,
//     this.activityTypeProgress,
//     this.projectId,
//     this.towerName,
//     this.flat,
//     this.flatName,
//     this.floodId,
//     this.flooName,
//     this.projectName,
//     this.towerId,
//     required this.controller,
//     this.overallImagesList,
//     this.color,
//     this.wiStatus,
//   });

//   factory ListChecklistDataByAc.fromJson(Map<String, dynamic> json) =>
//       ListChecklistDataByAc(
//         projectId: json["project_id"].toString(),
//         activity_name: json["activity_name"].toString(),
//         projectName: json["project_name"].toString(),
//         flat: json["flat"].toString(),
//         flatName: json["flat_name"].toString(),
//         towerId: json["tower_id"].toString(),
//         towerName: json["tower_name"].toString(),
//         floodId: json["floor_id"].toString(),
//         flooName: json["floor_name"].toString(),
//         name: json["name"].toString(),
//         checklistId: json["checklist_id"],
//         activityTypeId: json["activity_type_id"],
//         activityStatus: json["activity_status"].toString(),
//         activityTypeProgress: json["activity_type_progress"].toString(),
//         lineData: json["line_data"] == null
//             ? []
//             : List<LineData>.from(
//                 json["line_data"]!.map((x) => LineData.fromJson(x))),
//         controller: TextEditingController(
//             text: json["overall_remarks"] == null ||
//                     json["overall_remarks"] == false ||
//                     json["overall_remarks"] == "false"
//                 ? ""
//                 : json["overall_remarks"].toString()),
//         overallImagesList: json["overall_images"] ?? [],
//         color: json["color"] ?? '',
//         wiStatus: json["wi_status"] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//         "project_id": projectId,
//         "activity_name": activity_name,
//         "project_name": projectName,
//         "flat": flat,
//         "flat_name": flatName,
//         "tower_id": towerId,
//         "tower_name": towerName,
//         "floor_id": floodId,
//         "floor_name": flooName,
//         "name": name,
//         "activity_status": activityStatus,
//         "checklist_id": checklistId,
//         "activity_type_progress": activityTypeProgress,
//         "activity_type_id": activityTypeId,
//         "line_data": lineData == null
//             ? []
//             : List<dynamic>.from(lineData!.map((x) => x.toJson())),
//         "overall_images": overallImagesList ?? [],
//         "color": color,
//         "wi_status": wiStatus,
//       };
// }

// class LineData {
//   dynamic name;
//   int? lineId;
//   TextEditingController controller;
//   List imageList;
//   List imageData;
//   String value = "Yes";
//   dynamic reason;
//   List<History>? history;

//   LineData(
//       {this.name,
//       this.lineId,
//       required this.controller,
//       required this.imageList,
//       required this.imageData,
//       this.value = "Yes",
//       this.history,
//       this.reason});

//   factory LineData.fromJson(Map<String, dynamic> json) => LineData(
//         name: json["name"].toString(),
//         lineId: json["line_id"],
//         controller: TextEditingController(
//             text: json["reason"] == null ||
//                     json["reason"] == false ||
//                     json["reason"] == "false"
//                 ? ""
//                 : json["reason"].toString()),
//         imageList: json["image_url"] ?? json["image_urls"] ?? [],
//         imageData: json["image_data"] ?? [],
//         value: json["is_pass"] == null ||
//                 json["is_pass"] == false ||
//                 json["is_pass"] == "false"
//             ? "yes"
//             : json["is_pass"].toString(),
//         reason: json["reason"] == null ||
//                 json["reason"] == false ||
//                 json["reason"] == "false"
//             ? ""
//             : json["reason"].toString(),
//         history: json["history"] == null
//             ? []
//             : List<History>.from(
//                 json["history"]!.map((x) => History.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "image_data": imageData,
//         "name": name,
//         "line_id": lineId,
//         "image_url": imageList,
//         "image_urls": imageList,
//         "is_pass": value,
//         "reason": reason,
//         "history": history == null
//             ? []
//             : List<dynamic>.from(history!.map((x) => x.toJson())),
//       };
// }

// class History {
//   int? id;
//   String? name;
//   dynamic reason;
//   String? isPass;
//   SubmittedBy? submittedBy;
//   List imageList;
//   String? updateTime;
//   TextEditingController controller;

//   History(
//       {this.id,
//       this.name,
//       required this.imageList,
//       this.reason,
//       this.isPass,
//       this.submittedBy,
//       this.updateTime,
//       required this.controller});

//   factory History.fromJson(Map<String, dynamic> json) => History(
//         id: json["id"],
//         name: json["name"].toString(),
//         reason: json["reason"].toString(),
//         imageList: json["image_url"] ?? json["image_urls"] ?? [],
//         controller: TextEditingController(
//             text: json["reason"] == null ||
//                     json["reason"] == false ||
//                     json["reason"] == "false"
//                 ? ""
//                 : json["reason"].toString()),
//         isPass: json["is_pass"] == null ||
//                 json["is_pass"] == false ||
//                 json["is_pass"] == "false"
//             ? "yes"
//             : json["is_pass"].toString(),
//         submittedBy: json["submittedBy"] == null
//             ? null
//             : SubmittedBy.fromJson(json["submittedBy"]),
//         updateTime: json["update_time"].toString(),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "reason": reason,
//         "image_url": imageList,
//         "is_pass": isPass,
//         "submittedBy": submittedBy?.toJson(),
//         "update_time": updateTime,
//       };
// }

// class SubmittedBy {
//   dynamic id;
//   dynamic name;
//   String? role;

//   SubmittedBy({
//     this.id,
//     this.name,
//     this.role,
//   });

//   factory SubmittedBy.fromJson(Map<String, dynamic> json) => SubmittedBy(
//         id: json["id"] ?? 0,
//         name: json["name"].toString(),
//         role: json["role"].toString(),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "role": role,
//       };
// }

//LAST UPDATED BY USERNAME 31/10
import 'dart:convert';

import 'package:flutter/material.dart';

ChecklistByActivityResponseModel checklistByActivityResponseModelFromJson(
        String str) =>
    ChecklistByActivityResponseModel.fromJson(json.decode(str));

String checklistByActivityResponseModelToJson(
        ChecklistByActivityResponseModel data) =>
    json.encode(data.toJson());

class ChecklistByActivityResponseModel {
  String? status;
  String? message;
  ChecklistData? checklistData;

  ChecklistByActivityResponseModel({
    this.status,
    this.message,
    this.checklistData,
  });

  factory ChecklistByActivityResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ChecklistByActivityResponseModel(
        status: json["status"]?.toString(),
        message: json["message"]?.toString(),
        checklistData: json["checklist_data"] == null
            ? null
            : ChecklistData.fromJson(json["checklist_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "checklist_data": checklistData?.toJson(),
      };
}

class ChecklistData {
  String? activityName;
  int? activityId;
  List<ListChecklistDataByAc>? listChecklistData;

  ChecklistData({
    this.activityName,
    this.activityId,
    this.listChecklistData,
  });

  factory ChecklistData.fromJson(Map<String, dynamic> json) => ChecklistData(
        activityName: json["activity_name"]?.toString(),
        activityId: json["activity_id"],
        listChecklistData: json["list_checklist_data"] == null
            ? []
            : List<ListChecklistDataByAc>.from(json["list_checklist_data"]!
                .map((x) => ListChecklistDataByAc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "activity_name": activityName,
        "activity_id": activityId,
        "list_checklist_data": listChecklistData == null
            ? []
            : List<dynamic>.from(listChecklistData!.map((x) => x.toJson())),
      };
}

class ListChecklistDataByAc {
  String? name;
  String? activity_name;
  String? activityStatus;
  int? checklistId;
  int? activityTypeId;
  String? activityTypeProgress;
  List<LineData>? lineData;
  String? projectId;
  String? projectName;
  String? flat;
  String? flatName;
  String? towerId;
  String? towerName;
  dynamic floodId;
  dynamic flooName;
  TextEditingController controller;
  List? overallImagesList;
  String? color;
  String? wiStatus;
  String? lastUpdatedBy;

  ListChecklistDataByAc({
    this.name,
    this.activity_name,
    this.activityStatus,
    this.checklistId,
    this.activityTypeId,
    this.lineData,
    this.activityTypeProgress,
    this.projectId,
    this.towerName,
    this.flat,
    this.flatName,
    this.floodId,
    this.flooName,
    this.projectName,
    this.towerId,
    required this.controller,
    this.overallImagesList,
    this.color,
    this.wiStatus,
    this.lastUpdatedBy,
  });

  factory ListChecklistDataByAc.fromJson(Map<String, dynamic> json) {
    final model = ListChecklistDataByAc(
      projectId: json["project_id"]?.toString(),
      activity_name: json["activity_name"]?.toString(),
      projectName: json["project_name"]?.toString(),
      flat: json["flat"]?.toString(),
      flatName: json["flat_name"]?.toString(),
      towerId: json["tower_id"]?.toString(),
      towerName: json["tower_name"]?.toString(),
      floodId: json["floor_id"]?.toString(),
      flooName: json["floor_name"]?.toString(),
      name: json["name"]?.toString(),
      checklistId: json["checklist_id"],
      activityTypeId: json["activity_type_id"],
      activityStatus: json["activity_status"]?.toString(),
      activityTypeProgress: json["activity_type_progress"]?.toString(),
      lineData: json["line_data"] == null
          ? []
          : List<LineData>.from(
              json["line_data"]!.map((x) => LineData.fromJson(x))),
      controller: TextEditingController(
          text: json["overall_remarks"] == null ||
                  json["overall_remarks"] == false ||
                  json["overall_remarks"] == "false"
              ? ""
              : json["overall_remarks"]?.toString() ?? ""),
      overallImagesList: json["overall_images"] ?? [],
      color: json["color"] ?? '',
      wiStatus: json["wi_status"] ?? '',
    );

    // Compute lastUpdatedBy from history
    String? lastUpdated = '';
    if (model.lineData != null &&
        model.lineData!.isNotEmpty &&
        model.lineData![0].history != null &&
        model.lineData![0].history!.isNotEmpty) {
      lastUpdated = model.lineData![0].history!.first.submittedBy?.name ?? '';
    }
    model.lastUpdatedBy = lastUpdated;

    return model;
  }

  Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "activity_name": activity_name,
        "project_name": projectName,
        "flat": flat,
        "flat_name": flatName,
        "tower_id": towerId,
        "tower_name": towerName,
        "floor_id": floodId,
        "floor_name": flooName,
        "name": name,
        "activity_status": activityStatus,
        "checklist_id": checklistId,
        "activity_type_progress": activityTypeProgress,
        "activity_type_id": activityTypeId,
        "line_data": lineData == null
            ? []
            : List<dynamic>.from(lineData!.map((x) => x.toJson())),
        "overall_images": overallImagesList ?? [],
        "color": color,
        "wi_status": wiStatus,
        "last_updated_by": lastUpdatedBy,
      };
}

class LineData {
  dynamic name;
  int? lineId;
  TextEditingController controller;
  List imageList;
  List imageData;
  String value = "Yes";
  dynamic reason;
  List<History>? history;

  LineData(
      {this.name,
      this.lineId,
      required this.controller,
      required this.imageList,
      required this.imageData,
      this.value = "Yes",
      this.history,
      this.reason});

  factory LineData.fromJson(Map<String, dynamic> json) => LineData(
        name: json["name"]?.toString(),
        lineId: json["line_id"],
        controller: TextEditingController(
            text: json["reason"] == null ||
                    json["reason"] == false ||
                    json["reason"] == "false"
                ? ""
                : json["reason"]?.toString() ?? ""),
        imageList: json["image_url"] ?? json["image_urls"] ?? [],
        imageData: json["image_data"] ?? [],
        value: json["is_pass"] == null ||
                json["is_pass"] == false ||
                json["is_pass"] == "false"
            ? "yes"
            : json["is_pass"]?.toString() ?? "yes",
        reason: json["reason"] == null ||
                json["reason"] == false ||
                json["reason"] == "false"
            ? ""
            : json["reason"]?.toString() ?? "",
        history: json["history"] == null
            ? []
            : List<History>.from(
                json["history"]!.map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "image_data": imageData,
        "name": name,
        "line_id": lineId,
        "image_url": imageList,
        "image_urls": imageList,
        "is_pass": value,
        "reason": reason,
        "history": history == null
            ? []
            : List<dynamic>.from(history!.map((x) => x.toJson())),
      };
}

class History {
  int? id;
  String? name;
  dynamic reason;
  String? isPass;
  SubmittedBy? submittedBy;
  List imageList;
  String? updateTime;
  TextEditingController controller;

  History(
      {this.id,
      this.name,
      required this.imageList,
      this.reason,
      this.isPass,
      this.submittedBy,
      this.updateTime,
      required this.controller});

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        name: json["name"]?.toString(),
        reason: json["reason"]?.toString(),
        imageList: json["image_url"] ?? json["image_urls"] ?? [],
        controller: TextEditingController(
            text: json["reason"] == null ||
                    json["reason"] == false ||
                    json["reason"] == "false"
                ? ""
                : json["reason"]?.toString() ?? ""),
        isPass: json["is_pass"] == null ||
                json["is_pass"] == false ||
                json["is_pass"] == "false"
            ? "yes"
            : json["is_pass"]?.toString() ?? "yes",
        submittedBy: json["submittedBy"] == null
            ? null
            : SubmittedBy.fromJson(json["submittedBy"]),
        updateTime: json["update_time"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reason": reason,
        "image_url": imageList,
        "is_pass": isPass,
        "submittedBy": submittedBy?.toJson(),
        "update_time": updateTime,
      };
}

class SubmittedBy {
  dynamic id;
  dynamic name;
  String? role;

  SubmittedBy({
    this.id,
    this.name,
    this.role,
  });

  factory SubmittedBy.fromJson(Map<String, dynamic> json) => SubmittedBy(
        id: json["id"] ?? 0,
        name: json["name"]?.toString(),
        role: json["role"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
      };
}

















/// OLD CODE
// import 'dart:convert';
// import 'package:flutter/material.dart';
//
// ChecklistByActivityResponseModel checklistByActivityResponseModelFromJson(String str) =>
//     ChecklistByActivityResponseModel.fromJson(json.decode(str));
//
// String checklistByActivityResponseModelToJson(ChecklistByActivityResponseModel data) =>
//     json.encode(data.toJson());
//
// class ChecklistByActivityResponseModel {
//   String? status;
//   String? message;
//   ChecklistData? checklistData;
//
//   ChecklistByActivityResponseModel({
//     this.status,
//     this.message,
//     this.checklistData,
//   });
//
//   factory ChecklistByActivityResponseModel.fromJson(Map<String, dynamic> json) =>
//       ChecklistByActivityResponseModel(
//         status: json["status"].toString(),
//         message: json["message"].toString(),
//         checklistData: json["checklist_data"] == null ? null : ChecklistData.fromJson(json["checklist_data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "checklist_data": checklistData?.toJson(),
//       };
// }
//
// class ChecklistData {
//   String? activityName;
//   int? activityId;
//   List<ListChecklistDataByAc>? listChecklistData;
//
//   ChecklistData({
//     this.activityName,
//     this.activityId,
//     this.listChecklistData,
//   });
//
//   factory ChecklistData.fromJson(Map<String, dynamic> json) => ChecklistData(
//         activityName: json["activity_name"].toString(),
//         activityId: json["activity_id"],
//         listChecklistData: json["list_checklist_data"] == null
//             ? []
//             : List<ListChecklistDataByAc>.from(
//                 json["list_checklist_data"]!.map((x) => ListChecklistDataByAc.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "activity_name": activityName,
//         "activity_id": activityId,
//         "list_checklist_data":
//             listChecklistData == null ? [] : List<dynamic>.from(listChecklistData!.map((x) => x.toJson())),
//       };
// }
//
// class ListChecklistDataByAc {
//   String? name;
//   String? activity_name;
//   String? activityStatus;
//   int? checklistId;
//   int? activityTypeId;
//   String? activityTypeProgress;
//   List<LineData>? lineData;
//   String? projectId;
//   String? projectName;
//   String? flat;
//   String? flatName;
//   String? towerId;
//   String? towerName;
//   String? floodId;
//   String? flooName;
//   TextEditingController controller;
//
//   ListChecklistDataByAc({
//     this.name,
//     this.activity_name,
//     this.activityStatus,
//     this.checklistId,
//     this.activityTypeId,
//     this.lineData,
//     this.activityTypeProgress,
//     this.projectId,
//     this.towerName,
//     this.flat,
//     this.flatName,
//     this.floodId,
//     this.flooName,
//     this.projectName,
//     this.towerId,
//     required this.controller,
//   });
//
//   factory ListChecklistDataByAc.fromJson(Map<String, dynamic> json) => ListChecklistDataByAc(
//         projectId: json["project_id"].toString(),
//         activity_name: json["activity_name"].toString(),
//         projectName: json["project_name"].toString(),
//         flat: json["flat"].toString(),
//         flatName: json["flat_name"].toString(),
//         towerId: json["tower_id"].toString(),
//         towerName: json["tower_name"].toString(),
//         floodId: json["floor_id"].toString(),
//         flooName: json["floor_name"].toString(),
//         name: json["name"].toString(),
//         checklistId: json["checklist_id"],
//         activityTypeId: json["activity_type_id"],
//         activityStatus: json["activity_status"].toString(),
//         activityTypeProgress: json["activity_type_progress"].toString(),
//         lineData: json["line_data"] == null
//             ? []
//             : List<LineData>.from(json["line_data"]!.map((x) => LineData.fromJson(x))),
//         controller: TextEditingController(
//             text: json["overall_remarks"] == null ||
//                     json["overall_remarks"] == false ||
//                     json["overall_remarks"] == "false"
//                 ? ""
//                 : json["overall_remarks"].toString()),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "project_id": projectId,
//         "activity_name": activity_name,
//         "project_name": projectName,
//         "flat": flat,
//         "flat_name": flatName,
//         "tower_id": towerId,
//         "tower_name": towerName,
//         "floor_id": floodId,
//         "floor_name": flooName,
//         "name": name,
//         "activity_status": activityStatus,
//         "checklist_id": checklistId,
//         "activity_type_progress": activityTypeProgress,
//         "activity_type_id": activityTypeId,
//         "line_data": lineData == null ? [] : List<dynamic>.from(lineData!.map((x) => x.toJson())),
//       };
// }
//
// class LineData {
//   dynamic name;
//   int? lineId;
//   TextEditingController controller;
//   List imageList;
//   List imageData;
//   String value = "Yes";
//   String? reason;
//   List<History>? history;
//
//   LineData(
//       {this.name,
//       this.lineId,
//       required this.controller,
//       required this.imageList,
//       required this.imageData,
//       this.value = "Yes",
//       this.history,
//       this.reason});
//
//   factory LineData.fromJson(Map<String, dynamic> json) => LineData(
//         name: json["name"].toString(),
//         lineId: json["line_id"],
//         controller: TextEditingController(
//             text: json["reason"] == null || json["reason"] == false || json["reason"] == "false"
//                 ? ""
//                 : json["reason"].toString()),
//         imageList: json["image_url"] ?? json["image_urls"] ?? [],
//         imageData: json["image_data"] ?? [],
//         value: json["is_pass"] == null || json["is_pass"] == false || json["is_pass"] == "false"
//             ? "yes"
//             : json["is_pass"].toString(),
//         reason: json["reason"] == null || json["reason"] == false || json["reason"] == "false"
//             ? ""
//             : json["reason"].toString(),
//         history: json["history"] == null
//             ? []
//             : List<History>.from(json["history"]!.map((x) => History.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "image_data": imageData,
//         "name": name,
//         "line_id": lineId,
//         "image_url": imageList,
//         "image_urls": imageList,
//         "is_pass": value,
//         "reason": reason,
//         "history": history == null ? [] : List<dynamic>.from(history!.map((x) => x.toJson())),
//       };
// }
//
// class History {
//   int? id;
//   String? name;
//   String? reason;
//   String? isPass;
//   SubmittedBy? submittedBy;
//   List imageList;
//   String? updateTime;
//   TextEditingController controller;
//
//   History(
//       {this.id,
//       this.name,
//       required this.imageList,
//       this.reason,
//       this.isPass,
//       this.submittedBy,
//       this.updateTime,
//       required this.controller});
//
//   factory History.fromJson(Map<String, dynamic> json) => History(
//         id: json["id"],
//         name: json["name"].toString(),
//         reason: json["reason"].toString(),
//         imageList: json["image_url"] ?? json["image_urls"] ?? [],
//         controller: TextEditingController(
//             text: json["reason"] == null || json["reason"] == false || json["reason"] == "false"
//                 ? ""
//                 : json["reason"].toString()),
//         isPass: json["is_pass"] == null || json["is_pass"] == false || json["is_pass"] == "false"
//             ? "yes"
//             : json["is_pass"].toString(),
//         submittedBy: json["submittedBy"] == null ? null : SubmittedBy.fromJson(json["submittedBy"]),
//         updateTime: json["update_time"].toString(),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "reason": reason,
//         "image_url": imageList,
//         "is_pass": isPass,
//         "submittedBy": submittedBy?.toJson(),
//         "update_time": updateTime,
//       };
// }
//
// class SubmittedBy {
//   int? id;
//   String? name;
//   String? role;
//
//   SubmittedBy({
//     this.id,
//     this.name,
//     this.role,
//   });
//
//   factory SubmittedBy.fromJson(Map<String, dynamic> json) => SubmittedBy(
//         id: json["id"] ?? 0,
//         name: json["name"].toString(),
//         role: json["role"].toString(),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "role": role,
//       };
// }
