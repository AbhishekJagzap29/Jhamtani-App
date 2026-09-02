// import 'dart:convert';

// GetHQIFlatsOfflineResponseModel getHQIFlatsOfflineResponseModelFromJson(String str) =>
//     GetHQIFlatsOfflineResponseModel.fromJson(json.decode(str));

// String getHQIFlatsOfflineResponseModelToJson(GetHQIFlatsOfflineResponseModel data) =>
//     json.encode(data.toJson());

// class GetHQIFlatsOfflineResponseModel {
//   String? status;
//   String? message;
//   List<OfflineHQIFlatData>? data;

//   GetHQIFlatsOfflineResponseModel({
//     this.status,
//     this.message,
//     this.data,
//   });

//   factory GetHQIFlatsOfflineResponseModel.fromJson(Map<String, dynamic> json) =>
//       GetHQIFlatsOfflineResponseModel(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null
//             ? []
//             : List<OfflineHQIFlatData>.from(json["data"].map((x) => OfflineHQIFlatData.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

// class OfflineHQIFlatData {
//   int? flatId;
//   String? flatName;
//   int? projectId;
//   String? projectName;
//   int? towerId;
//   String? towerName;
//   int? floorId;
//   String? floorName;

//   OfflineHQIFlatData({
//     this.flatId,
//     this.flatName,
//     this.projectId,
//     this.projectName,
//     this.towerId,
//     this.towerName,
//     this.floorId,
//     this.floorName,
//   });

//   factory OfflineHQIFlatData.fromJson(Map<String, dynamic> json) => OfflineHQIFlatData(
//         flatId: json["flat_id"],
//         flatName: json["flat_name"],
//         projectId: json["project_id"],
//         projectName: json["project_name"],
//         towerId: json["tower_id"],
//         towerName: json["tower_name"],
//         floorId: json["floor_id"],
//         floorName: json["floor_name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "flat_id": flatId,
//         "flat_name": flatName,
//         "project_id": projectId,
//         "project_name": projectName,
//         "tower_id": towerId,
//         "tower_name": towerName,
//         "floor_id": floorId,
//         "floor_name": floorName,
//       };
// }

import 'dart:convert';

FlatLocationObservationOfflineResponseModel flatLocationObservationOfflineResponseModelFromJson(String str) =>
    FlatLocationObservationOfflineResponseModel.fromJson(json.decode(str));

String flatLocationObservationOfflineResponseModelToJson(FlatLocationObservationOfflineResponseModel data) => json.encode(data.toJson());

class FlatLocationObservationOfflineResponseModel {
  String? status;
  String? message;
  List<LocationObservationData>? data;

  FlatLocationObservationOfflineResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory FlatLocationObservationOfflineResponseModel.fromJson(Map<String, dynamic> json) => FlatLocationObservationOfflineResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<LocationObservationData>.from(json["data"].map((x) => LocationObservationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LocationObservationData {
  int? observationId;
  String? name;
  String? state;
  String? date;
  String? targetDate;
  int? issueCategoryId;
  String? issueCategoryName;
  int? issueTypeId;
  String? issueTypeName;
  String? description;
  String? remark;
  String? impact;
  int? locationId;
  bool? checkerSubmitted;
  bool? makerSubmitted;
  String? color;
  String? locationOverallColor;
  VisitDetails? visitDetails;
  List<ImageData>? imgData;

  LocationObservationData({
    this.observationId,
    this.name,
    this.state,
    this.date,
    this.targetDate,
    this.issueCategoryId,
    this.issueCategoryName,
    this.issueTypeId,
    this.issueTypeName,
    this.description,
    this.remark,
    this.impact,
    this.locationId,
    this.checkerSubmitted,
    this.makerSubmitted,
    this.color,
    this.locationOverallColor,
    this.visitDetails,
    this.imgData,
  });

  factory LocationObservationData.fromJson(Map<String, dynamic> json) => LocationObservationData(
        observationId: json["observation_id"],
        name: json["name"],
        state: json["state"],
        date: json["date"],
        targetDate: json["target_date"],
        issueCategoryId: json["issue_category_id"],
        issueCategoryName: json["issue_category_name"],
        issueTypeId: json["issue_type_id"],
        issueTypeName: json["issue_type_name"],
        description: json["description"],
        remark: json["remark"],
        impact: json["impact"],
        locationId: json["location_id"],
        checkerSubmitted: json["checker_submitted"],
        makerSubmitted: json["maker_submitted"],
        color: json["color"],
        locationOverallColor: json["location_overall_color"],
        visitDetails: json["visit_details"] == null ? null : VisitDetails.fromJson(json["visit_details"]),
        imgData: json["img_data"] == null ? [] : List<ImageData>.from(json["img_data"].map((x) => ImageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "observation_id": observationId,
        "name": name,
        "state": state,
        "date": date,
        "target_date": targetDate,
        "issue_category_id": issueCategoryId,
        "issue_category_name": issueCategoryName,
        "issue_type_id": issueTypeId,
        "issue_type_name": issueTypeName,
        "description": description,
        "remark": remark,
        "impact": impact,
        "location_id": locationId,
        "checker_submitted": checkerSubmitted,
        "maker_submitted": makerSubmitted,
        "color": color,
        "location_overall_color": locationOverallColor,
        "visit_details": visitDetails?.toJson(),
        "img_data": imgData == null ? [] : List<dynamic>.from(imgData!.map((x) => x.toJson())),
      };
}

class VisitDetails {
  String? visitName;
  int? sequence;
  int? visitId;

  VisitDetails({
    this.visitName,
    this.sequence,
    this.visitId,
  });

  factory VisitDetails.fromJson(Map<String, dynamic> json) => VisitDetails(
        visitName: json["visit_name"],
        sequence: json["sequence"],
        visitId: json["visit_id"],
      );

  Map<String, dynamic> toJson() => {
        "visit_name": visitName,
        "sequence": sequence,
        "visit_id": visitId,
      };
}

class ImageData {
  String? checkerImgUrl;
  int? userChecker;
  String? makerImgUrl;
  int? userMaker;

  ImageData({
    this.checkerImgUrl,
    this.userChecker,
    this.makerImgUrl,
    this.userMaker,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        checkerImgUrl: json["checker_img_url"],
        userChecker: json["user_checker"],
        makerImgUrl: json["maker_img_url"],
        userMaker: json["user_maker"],
      );

  Map<String, dynamic> toJson() => {
        "checker_img_url": checkerImgUrl,
        "user_checker": userChecker,
        "maker_img_url": makerImgUrl,
        "user_maker": userMaker,
      };
}
